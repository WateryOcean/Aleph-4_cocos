import '../models/chat_model.dart';

class ChatDummyData {
  static final List<ChatConversation> dummyConversations = [
    ChatConversation(
      id: '1',
      vendorName: 'Cocos',
      vendorImageUrl: 'https://i.pravatar.cc/150?u=1',
      lastMessage: 'The dragon scale texture is coming along...',
      lastMessageTime: DateTime.now().subtract(const Duration(minutes: 5)),
      unreadCount: 2,
      isOnline: true,
      specialization: 'Armor Specialist & Prop Maker',
      progress: 0.65,
    )
  ];

  static List<ChatMessage> getMessages(String conversationId) {
    return [
      ChatMessage(
        id: '1',
        senderId: 'vendor1',
        text: 'Hey there! Just finished the primer layer.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        isMe: false,
      ),
      ChatMessage(
        id: '2',
        senderId: 'me',
        text: 'Yes, please! I\'m curious about the texture.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
        isMe: true,
      ),
    ];
  }
}