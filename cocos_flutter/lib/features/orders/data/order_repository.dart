import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart' as firebase;
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/database/sqlite_helper.dart';
import '../../../../core/network/connectivity_service.dart';
import '../models/order_model.dart';

class OrderRepository {
  OrderRepository._();
  static final OrderRepository instance = OrderRepository._();
  final firebase.FirebaseFirestore _firestore = firebase.FirebaseFirestore.instance;
  final ConnectivityService _connectivity = ConnectivityService.instance;

  // ─── PEMBANTU ─────────────────────────────────────────────────────

  String _getStepLabel(int step) {
    if (step >= 0 && step < kOrderTimeline.length) {
      return kOrderTimeline[step].label;
    }
    return 'Unknown';
  }

  // SQLite tidak memiliki tipe map bawaan, sehingga shipping_address harus di-encode ke JSON untuk penyimpanan lokal.
  Map<String, dynamic> _toLocalRow(Order order) {
    return {
      'id': order.id,
      'order_number': order.orderNumber,
      'product_name': order.productName,
      'image_url': order.imageUrl,
      'price': order.price,
      'quantity': order.quantity,
      'selected_size': order.selectedSize,
      'selected_material': order.selectedMaterial,
      'category': order.category.name,
      'current_step': order.currentStep,
      'step_label': _getStepLabel(order.currentStep),
      'order_date': order.orderDate.toIso8601String(),
      'estimated_date': order.estimatedDate.toIso8601String(),
      'shipping_address': order.shippingAddress != null
          ? jsonEncode(order.shippingAddress!.toJson())
          : null,
      'payment_method': order.paymentMethod?.name,
    };
  }

  // ─── SIMPAN ORDER ──────────────────────────────────────────────────

  Future<void> saveOrder(Order order, String userId) async {
    final db = await SqliteHelper.instance.database;
    final Map<String, dynamic> orderData = {
      'id': order.id,
      'order_number': order.orderNumber,
      'product_name': order.productName,
      'image_url': order.imageUrl,
      'price': order.price,
      'quantity': order.quantity,
      'selected_size': order.selectedSize,
      'selected_material': order.selectedMaterial,
      'category': order.category.name,
      'current_step': order.currentStep,
      'step_label': _getStepLabel(order.currentStep),
      'order_date': order.orderDate.toIso8601String(),
      'estimated_date': order.estimatedDate.toIso8601String(),
      if (order.shippingAddress != null) 'shipping_address': order.shippingAddress!.toJson(),
      if (order.paymentMethod != null) 'payment_method': order.paymentMethod!.name,
    };

    final localRow = _toLocalRow(order);

    if (_connectivity.isConnected) {
      try {
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('orders')
            .doc(order.id)
            .set(orderData);

        await db.insert(
          'orders',
          {...localRow, 'is_synced': 1, 'firebase_id': order.id},
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      } catch (e) {
        await _saveLocal(db, localRow, 0);
      }
    } else {
      await _saveLocal(db, localRow, 0);
    }
  }

  Future<void> _saveLocal(Database db, Map<String, dynamic> data, int synced) async {
    await db.insert(
      'orders',
      {...data, 'is_synced': synced, 'firebase_id': synced == 1 ? data['id'] : null},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ─── MUAT ORDER ────────────────────────────────────────────────

  Future<List<Order>> loadOrders(String userId) async {
    final db = await SqliteHelper.instance.database;
    List<Order> localOrders = [];

    try {
      final rows = await db.query('orders');
      localOrders = rows.map((map) => Order.fromJson(map)).toList();
    } catch (e) {
      debugPrint('Error loading orders from local DB: $e');
    }

    if (_connectivity.isConnected) {
      try {
        final snapshot = await _firestore
            .collection('users')
            .doc(userId)
            .collection('orders')
            .get();

        final firestoreOrders = snapshot.docs.map((doc) {
          final data = doc.data();
          return Order.fromJson({...data, 'id': doc.id});
        }).toList();

        for (final order in firestoreOrders) {
          await db.insert(
            'orders',
            {..._toLocalRow(order), 'is_synced': 1, 'firebase_id': order.id},
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }

        return firestoreOrders;
      } catch (e) {
        debugPrint('Error loading orders from Firestore: $e');
        return localOrders;
      }
    }

    return localOrders;
  }

  // ─── PERBARUI LANGKAH ORDER ──────────────────────────────────────────

  Future<void> updateOrderStep(
    String userId,
    String orderId,
    int newStep,
    OrderCategory newCategory,
  ) async {
    final db = await SqliteHelper.instance.database;
    final newLabel = _getStepLabel(newStep);

    await db.update(
      'orders',
      {
        'current_step': newStep,
        'category': newCategory.name,
        'step_label': newLabel,
      },
      where: 'id = ?',
      whereArgs: [orderId],
    );

    if (_connectivity.isConnected) {
      try {
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('orders')
            .doc(orderId)
            .update({
          'current_step': newStep,
          'category': newCategory.name,
          'step_label': newLabel,
        });
      } catch (e) {
        await db.update(
          'orders',
          {'is_synced': 0},
          where: 'id = ?',
          whereArgs: [orderId],
        );
      }
    } else {
      await db.update(
        'orders',
        {'is_synced': 0},
        where: 'id = ?',
        whereArgs: [orderId],
      );
    }
  }
}