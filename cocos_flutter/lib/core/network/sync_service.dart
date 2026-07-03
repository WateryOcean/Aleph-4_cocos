import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../database/sqlite_helper.dart';
import '../../features/auth/data/user_service.dart';
 
class SyncService {
  SyncService._();

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
 
  /// Fungsi utama untuk memicu sinkronisasi massal dari SQLite ke Firestore
  static Future<void> triggerSync() async {
    final String userId = UserService.instance.fullName.isNotEmpty 
        ? UserService.instance.fullName 
        : 'guest_user';
 
    debugPrint('SyncService: Mendeteksi koneksi pulih. Memulai sinkronisasi otomatis...');
 
    try {
      final db = await SqliteHelper.instance.database;

      // 1. SINKRONISASI TABEL KERANJANG (CART)
      final List<Map<String, dynamic>> pendingCart = await db.query(
        'cart',
        where: 'is_synced = ?',
        whereArgs: [0],
      );
 
      if (pendingCart.isNotEmpty) {
        debugPrint('SyncService: Menemukan ${pendingCart.length} item keranjang tertunda.');
        final batch = _firestore.batch();
        final List<MapEntry<Object?, String>> cartDocIds = [];

        for (var item in pendingCart) {
          final docRef = _firestore
              .collection('users')
              .doc(userId)
              .collection('cart')
              .doc(item['id']);

          batch.set(docRef, {
            'product_name': item['product_name'],

            'image_url': item['image_url'],

            'price': item['price'],

            'quantity': item['quantity'],

            'selected_size': item['selected_size'],

            'selected_material': item['selected_material'],
          });

          cartDocIds.add(MapEntry(item['id'], docRef.id));
        }

        await batch.commit();
        // Perbarui flag lokal di SQLite dengan firebase_id yang sebenarnya
        for (final entry in cartDocIds) {
          await db.update(
            'cart',
            {'is_synced': 1, 'firebase_id': entry.value},
            where: 'id = ?',
            whereArgs: [entry.key],
          );
        }
        debugPrint('SyncService: Sinkronisasi data keranjang sukses.');
      }
 
      // 2. SINKRONISASI TABEL PESANAN (ORDERS)
      final List<Map<String, dynamic>> pendingOrders = await db.query(
        'orders',
        where: 'is_synced = ?',
        whereArgs: [0],
      );
 
      if (pendingOrders.isNotEmpty) {
        debugPrint('SyncService: Menemukan ${pendingOrders.length} pesanan tertunda.');

        final batch = _firestore.batch();
        final List<MapEntry<Object?, String>> orderDocIds = [];

        for (var order in pendingOrders) {
          final docRef = _firestore
              .collection('users')
              .doc(userId)
              .collection('orders')
              .doc(order['id']);

          batch.set(docRef, {
            'id': order['id'],

            'order_number': order['order_number'],

            'product_name': order['product_name'],

            'image_url': order['image_url'],

            'price': order['price'],

            'quantity': order['quantity'],

            'selected_size': order['selected_size'],

            'selected_material': order['selected_material'],

            'category': order['category'],

            'current_step': order['current_step'],

            'order_date': order['order_date'],

            'estimated_date': order['estimated_date'],
          });

          orderDocIds.add(MapEntry(order['id'], docRef.id));
        }

        await batch.commit();
        // Perbarui flag lokal di SQLite pesanan dengan firebase_id yang sebenarnya
        for (final entry in orderDocIds) {
          await db.update(
            'orders',
            {'is_synced': 1, 'firebase_id': entry.value},
            where: 'id = ?',
            whereArgs: [entry.key],
          );
        }
        debugPrint('SyncService: Sinkronisasi data pesanan sukses.');
      }
 


      // 3. SINKRONISASI TABEL PESAN CHAT (CHAT MESSAGES)
      final List<Map<String, dynamic>> pendingChats = await db.query(
        'chat_messages',
        where: 'is_synced = ?',
        whereArgs: [0],
      );
 
      if (pendingChats.isNotEmpty) {
        debugPrint('SyncService: Menemukan ${pendingChats.length} pesan obrolan tertunda.');
        final batch = _firestore.batch();
        final List<MapEntry<Object?, String>> chatDocIds = [];

        // Gunakan conversation_id yang tersimpan untuk setiap pesan tertunda.
        for (var msg in pendingChats) {
          final conversationId = msg['conversation_id'] as String? ??
              msg['conversationId'] as String? ??
              '1';

          final docRef = _firestore
              .collection('chats')
              .doc(conversationId)
              .collection('messages')
              .doc(msg['id']);

          batch.set(docRef, {
            'id': msg['id'],

            'sender_id': msg['sender_id'],

            'text': msg['text'],

            'timestamp': msg['timestamp'],

            'is_me': msg['is_me'],

            'image_url': msg['image_url'],
          });

          chatDocIds.add(MapEntry(msg['id'], docRef.id));
        }

        await batch.commit();
        // Perbarui flag lokal di SQLite pesan chat dengan firebase_id yang sebenarnya
        for (final entry in chatDocIds) {
          await db.update(
            'chat_messages',
            {'is_synced': 1, 'firebase_id': entry.value},
            where: 'id = ?',
            whereArgs: [entry.key],
          );
        }
        debugPrint('SyncService: Sinkronisasi data obrolan sukses.');
      }
 
      debugPrint('SyncService: Semua proses sinkronisasi selesai.');
    } catch (e) {
      debugPrint('SyncService: Proses sinkronisasi gagal karena: $e');
    }
  }
}