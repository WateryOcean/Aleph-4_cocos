import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/chat_model.dart';
import '../data/chat_dummy.dart';

class ChatDetailPage extends StatefulWidget {
  final ChatConversation conversation;
  const ChatDetailPage({super.key, required this.conversation});

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  late List<ChatMessage> _messages;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _messages = ChatDummyData.getMessages(widget.conversation.id);
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      _messages.add(ChatMessage(
        id: DateTime.now().toString(),
        senderId: 'me',
        text: _controller.text,
        timestamp: DateTime.now(),
        isMe: true,
      ));
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF13121B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1B23),
        elevation: 0,
        centerTitle: false,
        // Tombol Undo untuk kembali ke halaman sebelumnya
        leading: IconButton(
          icon: const Icon(Icons.undo, color: Colors.white70),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.conversation.vendorImageUrl),
              radius: 16,
            ),
            const SizedBox(width: 12),
            // Menampilkan Nama Profil dan Status "Chat" di sampingnya
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${widget.conversation.vendorName} ',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '',
                      style: GoogleFonts.nunito(
                        color: const Color(0xFF6C5CE7), // Warna ungu untuk teks Chat
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.phone_outlined, color: Colors.white70, size: 20), onPressed: () {}),
          IconButton(icon: const Icon(Icons.videocam_outlined, color: Colors.white70, size: 20), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildChatBubbleWithProfile(msg);
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildChatBubbleWithProfile(ChatMessage msg) {
    // Identitas Pengirim (Sesuai User Summary & Referensi Gambar)
    final String senderName = msg.isMe ? "Bintang Kresno Hadi" : widget.conversation.vendorName;
    final String senderAvatar = msg.isMe 
        ? "https://i.pravatar.cc/150?u=bintang" 
        : widget.conversation.vendorImageUrl;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: msg.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!msg.isMe) ...[
            CircleAvatar(radius: 18, backgroundImage: NetworkImage(senderAvatar)),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: msg.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                // Header Pesan: Nama Pengirim
                Text(
                  senderName,
                  style: GoogleFonts.nunito(
                    color: Colors.white54,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                // Bubble Chat
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: msg.isMe ? const Color(0xFF6C5CE7).withValues(alpha: 0.15) : const Color(0xFF1C1B23),
                    borderRadius: BorderRadius.circular(10),
                    border: msg.isMe ? Border.all(color: const Color(0xFF6C5CE7).withValues(alpha: 0.3)) : null,
                  ),
                  child: Text(
                    msg.text,
                    style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          if (msg.isMe) ...[
            const SizedBox(width: 12),
            CircleAvatar(radius: 18, backgroundImage: NetworkImage(senderAvatar)),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF1C1B23),
        border: Border(top: BorderSide(color: Colors.white10)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: const TextStyle(color: Colors.white30),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: _sendMessage,
              icon: const Icon(Icons.send, color: Color(0xFF6C5CE7)),
            ),
          ],
        ),
      ),
    );
  }
}