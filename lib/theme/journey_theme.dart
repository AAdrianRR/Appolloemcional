import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class JourneyTheme {
  static const Color primary =
      Color(0xFFFF8A65); // Naranja Coral (Energía suave)
  static const Color accent = Color(0xFFFFD180); // Dorado suave (Luz)
  static const Color backgroundStart = Color(0xFFFFF3E0); // Crema
  static const Color backgroundEnd = Color(0xFFFFE0B2); // Melocotón suave

  static const Color textColor =
      Color(0xFF5D4037); // Marrón Tierra (Texto cálido)
  static const Color mutedText = Color(0xFF8D6E63); // Marrón suave

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [backgroundStart, backgroundEnd],
  );

  // ==================== ESTILOS DE TEXTO ====================
  static const TextStyle h1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: textColor,
    letterSpacing: 0.5,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: textColor,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    color: textColor,
    height: 1.5, // Mejor legibilidad
  );

  static const TextStyle caption = TextStyle(
    fontSize: 14,
    color: mutedText,
    fontWeight: FontWeight.w500,
  );

  static Widget scaffold({
    required Widget body,
    String? title,
    Widget? floatingActionButton,
  }) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: title != null
            ? Text(title, style: h2.copyWith(color: textColor))
            : null,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: textColor),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: backgroundGradient),
        child: SafeArea(
          child: body,
        ),
      ),
      floatingActionButton: floatingActionButton,
    );
  }

  static Widget infoCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.8), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE65100).withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }

  static ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primary,
    foregroundColor: Colors.white,
    elevation: 8,
    shadowColor: primary.withOpacity(0.4),
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  );
}
