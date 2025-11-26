// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../services/risk_service.dart';
import '../theme/app_theme.dart'; // Importar AppTheme para colores base
import '../theme/chat_theme.dart'; // ⬅️ IMPORTAR NUEVO TEMA DE CHAT
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _riskService = RiskService();
  final _textController = TextEditingController();
  final List<Content> _history = [];
  bool _isLoading = false;

  // 🎤 Servicio de Voz (Solo TTS)
  final FlutterTts _flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _initTts();

    Future.delayed(Duration.zero, () {
      if (_history.isEmpty) {
        setState(() {
          _history.add(Content.model([TextPart(_riskService.initialMessage)]));
        });
      }
    });
  }

  // Lógica de Inicialización de TTS
  void _initTts() async {
    await _flutterTts.setLanguage("es-ES");
    await _flutterTts.setSpeechRate(0.5);
    setState(() {});
  }

  // Función TTS para hablar un texto
  Future<void> _speak(String text) async {
    await _flutterTts.stop();
    await _flutterTts.speak(text);
  }

  void _sendMessage() async {
    final text = _textController.text.trim();
    _textController.clear();
    final user = FirebaseAuth.instance.currentUser;

    if (text.isEmpty || _isLoading || user == null) return;

    final userMessage = Content.text(text);
    setState(() {
      _history.add(userMessage);
      _isLoading = true;
    });

    try {
      final iaResponseText =
          await _riskService.sendAndAnalyzeMessage(text, user.uid);

      await _speak(iaResponseText);

      setState(() {
        _history.add(Content.model([TextPart(iaResponseText)]));
        _isLoading = false;
      });
    } catch (e) {
      print("Error al usar el servicio: $e");
      final errorMessage = "Error en el servicio de IA. Intenta de nuevo.";

      try {
        await _speak(errorMessage);
      } catch (_) {}

      setState(() {
        _history.add(Content.model([TextPart(errorMessage)]));
        _isLoading = false;
      });
    }
  }

  // Widget auxiliar para la burbuja de chat
  Widget _buildMessageBubble(String message, bool isUser) {
    // Usamos el color del Theme (colorScheme) en lugar de ChatTheme.secondary
    final userColor = Theme.of(context).colorScheme.secondary;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isUser
              ? userColor.withOpacity(1.0)
              : AppTheme.card.withOpacity(0.9),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft:
                isUser ? const Radius.circular(12) : const Radius.circular(0),
            bottomRight:
                isUser ? const Radius.circular(0) : const Radius.circular(12),
          ),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: isUser ? Colors.white : AppTheme.foreground,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChatTheme.scaffold(
      title: 'Gaibu: Tu Diario de Conversación',
      actions: const [],
      body: Column(
        children: <Widget>[
          if (_isLoading) const TypingIndicator(),

          // Área de Conversación
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _history.length,
              itemBuilder: (ctx, i) {
                final message = _history[_history.length - 1 - i];
                final isUser = message.role == 'user';
                final messageText =
                    (message.parts.first as TextPart).text ?? '';

                return _buildMessageBubble(
                  messageText,
                  isUser,
                );
              },
            ),
          ),

          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: AppTheme.card,
              border: Border(top: BorderSide(color: AppTheme.border)),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration.collapsed(
                      hintText: 'Escribe tu mensaje...',
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                // Botón de Enviar
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
