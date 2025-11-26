// lib/screens/social_chat_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../services/social_service.dart';
// ⚠️ Importaciones CRÍTICAS para el diseño
import '../theme/app_theme.dart';
import '../theme/social_theme.dart'; // ⬅️ Tema Social Único

class SocialChatScreen extends StatefulWidget {
  const SocialChatScreen({super.key});

  @override
  State<SocialChatScreen> createState() => _SocialChatScreenState();
}

class _SocialChatScreenState extends State<SocialChatScreen> {
  final _socialService = SocialService();
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  late final String _roomId;
  late final String _currentUserId;

  @override
  void initState() {
    super.initState();
    _currentUserId = FirebaseAuth.instance.currentUser!.uid;
    _roomId = _socialService.getChatRoomId(_currentUserId);
  }

  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    await _socialService.sendMessage(
      roomId: _roomId,
      senderId: _currentUserId,
      messageText: text,
    );

    _messageController.clear();
    _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  // Widget auxiliar para la burbuja de chat anónimo
  Widget _buildMessageBubble(DocumentSnapshot document, String currentUserId) {
    final data = document.data()! as Map<String, dynamic>;
    final isCurrentUser = data['senderId'] == currentUserId;
    final alias = data['alias'] as String? ?? 'Anónimo';
    final message = data['message'] as String? ?? '';
    final timestamp = data['timestamp'] as Timestamp?;

    // ⚠️ Colores ajustados al SocialTheme
    final bubbleColor = isCurrentUser ? SocialTheme.accent : SocialTheme.muted;
    final textColor = isCurrentUser ? Colors.white : SocialTheme.primary;
    final aliasColor =
        isCurrentUser ? Colors.white70 : SocialTheme.primary.withOpacity(0.7);

    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: bubbleColor.withOpacity(1.0), // Opacidad sólida
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(15),
            topRight: const Radius.circular(15),
            bottomLeft: isCurrentUser
                ? const Radius.circular(15)
                : const Radius.circular(0),
            bottomRight: isCurrentUser
                ? const Radius.circular(0)
                : const Radius.circular(15),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              alias,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: aliasColor,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message,
              style: TextStyle(color: textColor, fontSize: 15),
            ),
            if (timestamp != null)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  DateFormat('h:mm a').format(timestamp.toDate()),
                  style: TextStyle(
                      color: textColor.withOpacity(0.6), fontSize: 10),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SocialTheme.scaffold(
      title: 'Chat de Conexión Anónima',
      context: context,
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _socialService.getMessages(_roomId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (ctx, i) {
                    return _buildMessageBubble(
                        snapshot.data!.docs[i], _currentUserId);
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color:
                  AppTheme.card, // Usamos el card base para el fondo del input
              border: Border(top: BorderSide(color: AppTheme.border)),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration.collapsed(
                      hintText: 'Chatea de forma anónima...',
                    ),
                  ),
                ),
                // Botón de Enviar
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                  color: SocialTheme.accent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
