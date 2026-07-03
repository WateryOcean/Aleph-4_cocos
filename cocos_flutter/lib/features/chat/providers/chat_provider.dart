import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../data/chat_repository.dart';
import '../models/chat_model.dart';

class ChatProvider extends ChangeNotifier {
  final ChatRepository _chatRepository = ChatRepository.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<ChatConversation> _conversations = [];
  List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String? _currentConversationId;

  StreamSubscription<QuerySnapshot>? _messagesSubscription;

  List<ChatConversation> get conversations => _conversations;
  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;
  bool get hasMessages => _messages.isNotEmpty;

  // ─── MEMUAT PERCAKAPAN ──────────────────────────────────────────

  Future<void> loadConversations(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('conversations')
          .orderBy('last_message_timestamp', descending: true)
          .get();

      _conversations = snapshot.docs.map((doc) {
        final data = doc.data();
        return ChatConversation(
          id: doc.id,
          vendorName: data['vendor_name'] ?? 'Vendor',
          vendorImageUrl: data['vendor_image'] ?? 'https://i.pravatar.cc/150',
          lastMessage: data['last_message'] ?? 'Start chatting...',
          lastMessageTime: (data['last_message_timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
          unreadCount: data['unread_count'] ?? 0,
          isOnline: data['is_online'] ?? false,
          specialization: data['specialization'] ?? 'Cosplay Specialist',
          progress: (data['progress'] as num?)?.toDouble() ?? 0.0,
        );
      }).toList();
    } catch (e) {
      debugPrint('Failed to load conversations: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ─── MEMUAT PESAN (REAL‑TIME) ──────────────────────────────────

  Future<void> loadMessages(String conversationId) async {
    // Batalkan langganan yang ada terlebih dahulu
    await _cancelMessagesSubscription();

    _currentConversationId = conversationId;
    _isLoading = true;
    _messages = [];
    notifyListeners();

    try {
      final initialMessages = await _chatRepository.loadMessages(conversationId);
      if (_currentConversationId != conversationId) return;

      _messages = initialMessages;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to load messages from repository: $e');
      _isLoading = false;
      notifyListeners();
    }

    try {
      _messagesSubscription = _firestore
          .collection('chats')
          .doc(conversationId)
          .collection('messages')
          .orderBy('timestamp', descending: false)
          .snapshots()
          .listen(
        (snapshot) {
          final newMessages = snapshot.docs.map((doc) {
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

          if (_currentConversationId == conversationId) {
            _messages = newMessages;
            _isLoading = false;
            notifyListeners();
          }
        },
        onError: (error) {
          debugPrint('Error listening to messages: $error');
          _isLoading = false;
          notifyListeners();
        },
      );
    } catch (e) {
      debugPrint('Error subscribing to chat messages: $e');
    }
  }

  // ─── KIRIM PESAN ────────────────────────────────────────────────

  Future<void> sendMessage(String conversationId, String text, String userId) async {
    if (text.trim().isEmpty) return;

    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: userId,
      text: text.trim(),
      timestamp: DateTime.now(),
      isMe: true,
      imageUrl: null,
    );

    // 1. Simpan secara lokal melalui repository (SQLite + Firestore)
    await _chatRepository.saveMessage(message, conversationId);

    // 2. Perbarui pesan terakhir percakapan di Firestore
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('conversations')
          .doc(conversationId)
          .set(
            {
              'last_message': text.trim(),
              'last_message_timestamp': FieldValue.serverTimestamp(),
            },
            SetOptions(merge: true),
          );
    } catch (e) {
      debugPrint('Failed to update conversation last message: $e');
    }

    // 3. Tambahkan ke daftar lokal secara optimistis (stream juga akan memperbaruinya)
    _messages.add(message);
    notifyListeners();
  }

  // ─── BATALKAN LANGGANAN ────────────────────────────────────────

  Future<void> _cancelMessagesSubscription() async {
    if (_messagesSubscription != null) {
      await _messagesSubscription!.cancel();
      _messagesSubscription = null;
    }
  }

  // ─── DISPOSE ──────────────────────────────────────────────────────

  @override
  void dispose() {
    _cancelMessagesSubscription();
    super.dispose();
  }
}