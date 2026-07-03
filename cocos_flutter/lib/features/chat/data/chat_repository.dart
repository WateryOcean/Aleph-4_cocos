import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/database/sqlite_helper.dart';
import '../../../../core/network/connectivity_service.dart';
import '../models/chat_model.dart';

class ChatRepository {
  ChatRepository._();

  static final ChatRepository instance = ChatRepository._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ConnectivityService _connectivity = ConnectivityService.instance;

  // ─── SIMPAN PESAN ────────────────────────────────────────────────

  Future<void> saveMessage(ChatMessage msg, String conversationId) async {
    final db = await SqliteHelper.instance.database;
    final msgData = {
      'id': msg.id,
      'sender_id': msg.senderId,
      'text': msg.text,
      'timestamp': msg.timestamp.toIso8601String(),
      'is_me': msg.isMe ? 1 : 0,
      'image_url': msg.imageUrl,
      'conversation_id': conversationId,
    };

    if (_connectivity.isConnected) {
      try {
        // Simpan ke Firestore
        await _firestore
            .collection('chats')
            .doc(conversationId)
            .collection('messages')
            .doc(msg.id)
            .set(msgData);

        // Simpan cache lokal dengan flag synced = 1
        await db.insert(
          'chat_messages',
          {...msgData, 'is_synced': 1, 'firebase_id': msg.id},
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      } catch (e) {
        // Fallback: simpan secara lokal sebagai belum tersinkron
        await _saveLocal(db, msgData, 0);
      }
    } else {
      // Offline: simpan secara lokal sebagai belum tersinkron
      await _saveLocal(db, msgData, 0);
    }
  }

  Future<void> _saveLocal(Database db, Map<String, dynamic> data, int synced) async {
    await db.insert(
      'chat_messages',
      {...data, 'is_synced': synced, 'firebase_id': synced == 1 ? data['id'] : null},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ─── MEMUAT PESAN (Offline-First) ──────────────────────────────

  /// Mengembalikan daftar pesan untuk sebuah percakapan.
  /// Selalu membaca dari SQLite terlebih dahulu (akses offline instan),
  /// kemudian jika online, mengambil data dari Firestore dan memperbarui cache lokal.
  Future<List<ChatMessage>> loadMessages(String conversationId) async {
    final db = await SqliteHelper.instance.database;
    List<ChatMessage> messages = [];

    // 1. Baca dari SQLite (offline-first)
    try {
      final List<Map<String, dynamic>> rows = await db.query(
        'chat_messages',
        where: 'conversation_id = ?',
        whereArgs: [conversationId],
        orderBy: 'timestamp ASC',
      );
      messages = rows.map((map) => _mapToChatMessage(map)).toList();
    } catch (e) {
      debugPrint('Error loading messages from local DB: $e');
    }

    // 2. Jika online, ambil data dari Firestore lalu gabungkan/perbarui
    if (_connectivity.isConnected) {
      try {
        final snapshot = await _firestore
            .collection('chats')
            .doc(conversationId)
            .collection('messages')
            .orderBy('timestamp', descending: false)
            .get();

        final List<ChatMessage> firestoreMessages = snapshot.docs.map((doc) {
          final data = doc.data();
          return ChatMessage(
            id: doc.id,
            senderId: data['sender_id'] ?? '',
            text: data['text'] ?? '',
            timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
            isMe: data['is_me'] == true,
            imageUrl: data['image_url'],
          );
        }).toList();

        // Perbarui SQLite lokal dengan data Firestore (replace/insert)
        for (final msg in firestoreMessages) {
          await db.insert(
            'chat_messages',
            {
              'id': msg.id,
              'sender_id': msg.senderId,
              'text': msg.text,
              'timestamp': msg.timestamp.toIso8601String(),
              'is_me': msg.isMe ? 1 : 0,
              'image_url': msg.imageUrl,
              'conversation_id': conversationId,
              'is_synced': 1,
              'firebase_id': msg.id,
            },
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }

        // Jika Firestore mengembalikan data, gunakan data tersebut (paling up-to-date)
        // Namun kita ingin menggabungkan; Firestore punya data terbaru, jadi daftar lokal diganti dengan daftar dari Firestore.
        messages = firestoreMessages;
      } catch (e) {
        debugPrint('Error loading messages from Firestore: $e');
        // Pertahankan pesan lokal sebagai fallback
      }
    }

    return messages;
  }

  // ─── MEMUAT PERCAKAPAN ──────────────────────────────────────────

  /// Memuat daftar percakapan untuk pengguna tertentu dari Firestore.
  /// (Belum ada caching offline untuk percakapan – bisa ditambahkan nanti.)
  Future<List<ChatConversation>> loadConversations(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('conversations')
          .orderBy('last_message_timestamp', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return ChatConversation(
          id: doc.id,
          vendorName: data['vendor_name'] ?? 'Vendor',
          vendorImageUrl: data['vendor_image'] ?? 'https://i.pravatar.cc/150',
          lastMessage: data['last_message'] ?? 'Start chatting...',
          lastMessageTime: (data['last_message_timestamp'] as Timestamp?)?.toDate() ??
              DateTime.now(),
          unreadCount: data['unread_count'] ?? 0,
          isOnline: data['is_online'] ?? false,
          specialization: data['specialization'] ?? 'Cosplay Specialist',
          progress: (data['progress'] as num?)?.toDouble() ?? 0.0,
        );
      }).toList();
    } catch (e) {
      debugPrint('Error loading conversations from Firestore: $e');
      return [];
    }
  }

  // ─── TANDAI PERCAKAPAN SEBAGAI DIBACA ──────────────────────────────────

  /// Mereset jumlah pesan belum dibaca untuk sebuah percakapan.
  Future<void> markConversationAsRead(String userId, String conversationId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('conversations')
          .doc(conversationId)
          .update({'unread_count': 0});
    } catch (e) {
      debugPrint('Error marking conversation as read: $e');
    }
  }

  // ─── HELPER: Ubah baris DB menjadi ChatMessage ──────────────────────────

  ChatMessage _mapToChatMessage(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'] as String? ?? '',
      senderId: map['sender_id'] as String? ?? '',
      text: map['text'] as String? ?? '',
      timestamp: DateTime.tryParse(map['timestamp'] as String? ?? '') ?? DateTime.now(),
      isMe: (map['is_me'] as int? ?? 0) == 1,
      imageUrl: map['image_url'] as String?,
    );
  }
}