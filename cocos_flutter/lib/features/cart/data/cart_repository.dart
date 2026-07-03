import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sqflite/sqflite.dart';
import '../../../../core/database/sqlite_helper.dart';
import '../../../../core/network/connectivity_service.dart';
import '../models/cart_model.dart';
 
class CartRepository {
  CartRepository._();
  static final CartRepository instance = CartRepository._();
 
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ConnectivityService _connectivity = ConnectivityService.instance;
 
  // Menambahkan item ke keranjang dengan strategi Hybrid
  Future<void> addToCart(CartItem item, String userId) async {
    final db = await SqliteHelper.instance.database;
 
    if (_connectivity.isConnected) {
      try {
        // 1. Jika online, tulis ke Cloud Firestore terlebih dahulu
        final docRef = _firestore.collection('users').doc(userId).collection('cart').doc(item.id);
        await docRef.set({
          'product_name': item.productName,
          'image_url': item.imageUrl,
          'price': item.price,
          'quantity': item.quantity,
          'selected_size': item.selectedSize,
          'selected_material': item.selectedMaterial,
        });
 
        // 2. Jika sukses di cloud, simpan ke SQLite lokal dengan flag is_synced = 1
        await db.insert(
          'cart',
          {
            'id': item.id,
            'product_name': item.productName,
            'image_url': item.imageUrl,
            'price': item.price,
            'quantity': item.quantity,
            'selected_size': item.selectedSize,
            'selected_material': item.selectedMaterial,
            'is_synced': 1,
            'firebase_id': docRef.id,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      } catch (e) {
        // Fallback ke offline mode jika Firebase gagal merespon meskipun ada sinyal
        await _saveToLocalOnly(db, item, null);
      }
    } else {
      // 3. Jika offline, simpan hanya ke SQLite lokal dengan flag is_synced = 0
      await _saveToLocalOnly(db, item, null);
    }
  }
 
  Future<void> _saveToLocalOnly(Database db, CartItem item, String? firebaseId) async {
    await db.insert(
      'cart',
      {
        'id': item.id,
        'product_name': item.productName,
        'image_url': item.imageUrl,
        'price': item.price,
        'quantity': item.quantity,
        'selected_size': item.selectedSize,
        'selected_material': item.selectedMaterial,
        'is_synced': 0,
        'firebase_id': firebaseId,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
 
  // Mengambil data keranjang belanja
  Future<List<CartItem>> getCartItems(String userId) async {
    final db = await SqliteHelper.instance.database;
    // Offline-First: Selalu baca dari lokal untuk performa kilat dan jaminan offline
    final List<Map<String, dynamic>> maps = await db.query('cart');
    return List.generate(maps.length, (i) {
      return CartItem(
        id: maps[i]['id'],
        productName: maps[i]['product_name'],
        imageUrl: maps[i]['image_url'],
        price: maps[i]['price'],
        quantity: maps[i]['quantity'],
        selectedSize: maps[i]['selected_size'],
        selectedMaterial: maps[i]['selected_material'],
      );
    });
  }

  // Hapus satu item dari keranjang (lokal + Firestore jika online)
  Future<void> removeCartItem(String userId, String itemId) async {
    final db = await SqliteHelper.instance.database;

    // 1. Hapus dari SQLite
    await db.delete(
      'cart',
      where: 'id = ?',
      whereArgs: [itemId],
    );

    // 2. Jika online, hapus dari Firestore
    if (_connectivity.isConnected) {
      try {
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('cart')
            .doc(itemId)
            .delete();
      } catch (e) {
        // Gagal hapus dari Firestore: item sudah hilang dari lokal,
        // kita biarkan saja karena user tidak akan melihatnya lagi.
        // Log untuk debug.
        // ignore: avoid_print
        print('Failed to delete cart item from Firestore: $e');
      }
    }
  }

  // Update quantity item di keranjang
  Future<void> updateCartItemQuantity(
    String userId,
    String itemId,
    int newQuantity,
  ) async {
    final db = await SqliteHelper.instance.database;

    // 1. Update di SQLite
    await db.update(
      'cart',
      {'quantity': newQuantity},
      where: 'id = ?',
      whereArgs: [itemId],
    );

    // 2. Jika online, update di Firestore
    if (_connectivity.isConnected) {
      try {
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('cart')
            .doc(itemId)
            .update({'quantity': newQuantity});
      } catch (e) {
        // Gagal update Firestore: tandai lokal sebagai unsynced
        // agar sync service nanti mengirim perubahan.
        await db.update(
          'cart',
          {'is_synced': 0},
          where: 'id = ?',
          whereArgs: [itemId],
        );
      }
    } else {
      // Offline: tandai sebagai unsynced
      await db.update(
        'cart',
        {'is_synced': 0},
        where: 'id = ?',
        whereArgs: [itemId],
      );
    }
  }

  // Mengosongkan keranjang secara lokal dan di Firestore
  Future<void> clearCart(String userId) async {
    final db = await SqliteHelper.instance.database;
    if (_connectivity.isConnected) {
      try {
        final col = _firestore.collection('users').doc(userId).collection('cart');
        final snapshot = await col.get();
        for (final doc in snapshot.docs) {
          await doc.reference.delete();
        }
      } catch (e) {
        // abaikan error saat menghapus di firestore dan lanjutkan menghapus DB lokal
      }
    }

    try {
      await db.delete('cart');
    } catch (e) {
      // abaikan
    }
  }
}