import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AvatarTheme {
  static const Color primary =
      Color.fromARGB(255, 124, 81, 163); // Azul Marino (Texto, Botón)
  static const Color accent =
      Color.fromARGB(255, 255, 255, 255); // Cian Claro (Acento)
  static const Color muted =
      Color(0xFFE0F7FA); // Fondo de campo de texto (Muy Claro)
  static const Color textColor = Color(0xFF1E3A8A); // Color de texto principal
  static const Color mutedForeground =
      Color(0xFF718096); // Texto secundario/Indicador de escritura

  // ☁️ Degradado de Chat (Fondo)
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color.fromARGB(255, 255, 255, 255), // Azul cielo muy pálido
      Color.fromARGB(255, 255, 255, 255), // Blanco azulado muy suave
    ],
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textColor,
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
        title: Text(title,
            style: AvatarTheme.h3.copyWith(color: primary)), // Usa h3 propio
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
                  color:
                      AvatarTheme.mutedForeground, // Usa mutedForeground propio
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
                        color: AvatarTheme
                            .mutedForeground, // Usa mutedForeground propio
                        fontWeight: FontWeight.bold));
              },
            ),
          ),
        ],
      ),
    );
  }
}
