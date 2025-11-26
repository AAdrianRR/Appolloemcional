// lib/theme/chat_theme.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_theme.dart';

class ChatTheme {
  static const Color primary = Color(0xFF1E3A8A); // Azul Marino (Texto)
  static const Color accent = Color(0xFF4FC3F7); // Cian Claro (Burbuja Usuario)
  static const Color muted = Color(0xFFE0F7FA); // Fondo de campo de texto

  // ☁️ Degradado de Chat (Sutil)
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFE1F5FE), // Azul cielo muy pálido
      Color(0xFFE8F8FF), // Blanco azulado muy suave
    ],
  );

  static Widget scaffold({
    required Widget body,
    required String title,
    required List<Widget> actions,
  }) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(title, style: AppTheme.h3.copyWith(color: primary)),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: primary,
        elevation: 0,
        automaticallyImplyLeading: true,
        actions: actions,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: backgroundGradient),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.only(top: 60.0),
            child: body,
          ),
        ),
      ),
    );
  }
}

class TypingIndicator extends StatelessWidget {
  const TypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('ApoIA está escribiendo',
              style: TextStyle(
                  color: AppTheme.mutedForeground,
                  fontStyle: FontStyle.italic)),
          const SizedBox(width: 8),
          SizedBox(
            width: 15,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 1500),
              curve: Curves.easeInOut,
              builder: (context, value, child) {
                final dotCount = (value * 3).ceil();
                return Text(List.filled(dotCount, '.').join(),
                    style: const TextStyle(
                        color: AppTheme.mutedForeground,
                        fontWeight: FontWeight.bold));
              },
              onEnd: () {},
            ),
          ),
        ],
      ),
    );
  }
}
