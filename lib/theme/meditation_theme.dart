// lib/theme/meditation_theme.dart

import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/services.dart';

class MeditationTheme {
  static const Color foreground = Color(0xFF311B92); // Índigo profundo
  static const Color mutedForeground = Color(0xFF5E35B1); // Púrpura medio
  static const Color accent = Color(0xFF7E57C2); // Lavanda intenso

  static const LinearGradient meditationGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFE1BEE7), // Lavanda claro
      Color(0xFFD1C4E9), // Púrpura suave
      Color(0xFFC5CAE9), // Índigo suave
      Color(0xFFFFFFFF), // Blanco
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
    double opacity = 0.5,
  }) {
    final cardWidget = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(opacity),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF673AB7).withOpacity(0.1), // Sombra púrpura
            offset: const Offset(0, 4),
            blurRadius: 15,
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.6), width: 1.0),
      ),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        splashColor: accent.withOpacity(0.2),
        child: cardWidget,
      );
    }
    return cardWidget;
  }

  static Widget iconContainer({
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 28, color: color),
    );
  }

  static Widget scaffold({
    required Widget body,
    required String title,
  }) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(title, style: h3),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: foreground,
        elevation: 0,
        automaticallyImplyLeading: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: meditationGradient),
        child: body,
      ),
    );
  }
}
