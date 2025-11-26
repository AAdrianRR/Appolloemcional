// lib/services/social_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart'; // Para debugPrint

class SocialService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String getChatRoomId(String currentUserId) {
    const baseRoom = 'anonymous_room_A';
    return baseRoom;
  }

  Future<void> sendMessage({
    required String roomId,
    required String senderId,
    required String messageText,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await _firestore
          .collection('chat_social') // Colección separada para el chat anónimo
          .doc(roomId) // Documento de la sala
          .collection('mensajes') // Mensajes dentro de la sala
          .add({
        'senderId': senderId,
        'message': messageText,
        'timestamp': Timestamp.now(),
        // Usamos un alias anónimo para el chat
        'alias': 'Usuario Anónimo ${senderId.substring(0, 4)}',
      });
      debugPrint('Éxito: Mensaje social guardado en sala $roomId.');
    } catch (e) {
      debugPrint(' ERROR DE FIREBASE (Chat Social): $e');
    }
  }

  Stream<QuerySnapshot> getMessages(String roomId) {
    return _firestore
        .collection('chat_social')
        .doc(roomId)
        .collection('mensajes')
        .orderBy('timestamp',
            descending: true) // Los mensajes más nuevos van primero
        .snapshots();
  }
}
