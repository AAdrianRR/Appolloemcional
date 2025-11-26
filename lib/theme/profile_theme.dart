import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';

class ProfileTheme {
  static const Color background = Color(0xFFF0F2F5); // Plata muy claro
  static const Color foreground =
      Color(0xFF0D47A1); // Azul Marino (Foco principal)
  static const Color mutedForeground = Color(0xFF546E7A); // Gris Azulado
  static const Color accent = Color(0xFF00BCD4); // Cian (Acento/Progreso)
  static const Color cardColor = Colors.white;

  // ☁️ Degradado Principal de Datos (Silver/Navy)
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFF7F9FA), // Plata
      Color(0xFFE3F2FD), // Azul muy pálido
    ],
  );

  static TextStyle get h2 => const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: foreground,
      height: 1.2);
  static TextStyle get h3 => const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: foreground,
      height: 1.2);
  static TextStyle get body => const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: foreground,
      height: 1.5);
  static TextStyle get caption => const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: mutedForeground,
      height: 1.4);

  static Widget glassCard({
    required Widget child,
    VoidCallback? onTap,
    EdgeInsets padding = const EdgeInsets.all(16),
    double opacity = 0.9,
  }) {
    final cardWidget = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(opacity),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
        border: Border.all(color: Colors.grey.shade100, width: 1.0),
      ),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: accent.withOpacity(0.2),
        child: cardWidget,
      );
    }
    return cardWidget;
  }

  static Widget scaffold({
    required Widget body,
    required String title,
    List<Widget>? actions,
    bool showLeading = true,
  }) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(title, style: h3.copyWith(color: foreground)),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: foreground,
        elevation: 0,
        automaticallyImplyLeading: showLeading,
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

  static Widget? iconContainer(
      {required IconData icon, required MaterialColor color}) {
    return null;
  }
}
