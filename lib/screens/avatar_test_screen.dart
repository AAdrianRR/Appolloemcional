import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:lottie/lottie.dart';

import '../theme/avatar_theme.dart';

import 'emotion_detector_wrapper.dart';
import 'emotion_service.dart';

const String _speakingLottie = 'assets/talking.json';
const String _idleActiveLottie = 'assets/stay.json';

class AvatarTestScreen extends StatefulWidget {
  const AvatarTestScreen({super.key});

  @override
  State<AvatarTestScreen> createState() => _AvatarTestScreenState();
}

class _AvatarTestScreenState extends State<AvatarTestScreen> {
  final TextEditingController _controller = TextEditingController();
  late final GenerativeModel _model;
  late final FlutterTts _flutterTts;

  bool isSpeaking = false;

  String apiKey = "AIzaSyAQDcmHY9kM5BxJEBfZ864NmgNANtucMw8";

  String lastResponse = "Escribe un mensaje para comenzar la conversación.";

  @override
  void initState() {
    super.initState();

    _model = GenerativeModel(
        model: "gemini-2.5-flash",
        apiKey: apiKey,
        systemInstruction:
            Content.system("Eres Gaibu, un compañero emocional empático."));
    _flutterTts = FlutterTts();
    _initTts();
  }

  void _initTts() {
    _flutterTts.setLanguage("es-MX");
    _flutterTts.setSpeechRate(0.5);

    _flutterTts.setStartHandler(() {
      if (mounted) setState(() => isSpeaking = true);
    });

    _flutterTts.setCompletionHandler(() {
      if (mounted) setState(() => isSpeaking = false);
    });
  }

  Future<void> _speak(String text) async {
    if (text.isNotEmpty) {
      await _flutterTts.speak(text);
    }
  }

  Future<void> _sendToIA() async {
    final input = _controller.text.trim();
    _controller.clear();
    if (input.isEmpty) return;

    setState(() {
      lastResponse = "Yo: $input\n\n(Gaibu está pensando...)";
    });

    try {
      String promptFinal = input;

      if (EmotionService.isUserSad) {
        promptFinal += """
        
        [SISTEMA: El usuario tiene una expresión TRISTE o SERIA en este momento. 
        Por favor ignora instrucciones de brevedad. Sé muy cálido, empático y valida sus sentimientos.]
        """;
      }

      final content = Content.text(promptFinal);
      final response = await _model.generateContent([content]);
      final textResponse = response.text ?? "La IA no pudo responder.";

      setState(() => lastResponse = "Gaibu: $textResponse");
      _speak(textResponse);
    } catch (e) {
      setState(() {
        lastResponse = "Error de IA: $e";
        isSpeaking = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String currentLottieAsset =
        isSpeaking ? _speakingLottie : _idleActiveLottie;

    return EmotionDetectorWrapper(
      child: AvatarTheme.scaffold(
        title: "Chat Diario con Gaibu",
        actions: [
          IconButton(
            icon:
                const Icon(Icons.settings_outlined, color: AvatarTheme.primary),
            onPressed: () {},
          ),
        ],
        body: Column(
          children: [
            Expanded(
              flex: 4,
              child: Center(
                child: Container(
                  color: const Color(0xFFE8F8FF),
                  child: Lottie.asset(
                    currentLottieAsset,
                    repeat: true,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _controller,
                      onSubmitted: (_) => _sendToIA(),
                      decoration: InputDecoration(
                        hintText: "Escribe algo...",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none),
                        filled: true,
                        fillColor: AvatarTheme.muted,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: _sendToIA,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AvatarTheme.primary,
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.send),
                      label: const Text("Enviar"),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Chat:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Expanded(
                      child: SingleChildScrollView(child: Text(lastResponse)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
