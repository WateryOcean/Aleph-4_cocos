import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/chat_dummy.dart';
import 'chat_detail_page.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF13121B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1B23),
        title: Text('Messages', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold)),
        centerTitle: false,
      ),
      body: ListView.builder(
        itemCount: ChatDummyData.dummyConversations.length,
        itemBuilder: (context, index) {
          final conv = ChatDummyData.dummyConversations[index];
          return ListTile(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatDetailPage(conversation: conv)),
            ),
            leading: Stack(
              children: [
                CircleAvatar(backgroundImage: NetworkImage(conv.vendorImageUrl), radius: 25),
                if (conv.isOnline)
                  Positioned(
                    right: 0, bottom: 0,
                    child: Container(
                      width: 12, height: 12,
                      decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle, border: Border.all(color: const Color(0xFF13121B), width: 2)),
                    ),
                  ),
              ],
            ),
            title: Text(conv.vendorName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: Text(conv.lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white38)),
            trailing: conv.unreadCount > 0 
                ? CircleAvatar(radius: 10, backgroundColor: const Color(0xFF6C5CE7), child: Text('${conv.unreadCount}', style: const TextStyle(fontSize: 10, color: Colors.white)))
                : null,
          );
        },
      ),
    );
  }
}