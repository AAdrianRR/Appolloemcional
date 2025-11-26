import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_theme.dart';

class SocialTheme {
  static const Color primary = Color(0xFF880E4F); // Morado Oscuro (Texto)
  static const Color accent = Color(0xFFC2185B); // Rosa Intenso (Acento)
  static const Color muted = Color(0xFFF3E5F5); // Lavanda muy pálido

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFCE4EC), // Rosa muy pálido (Top)
      Color(0xFFE1BEE7), // Lavanda
      Color(0xFFFFFFFF), // Blanco
    ],
  );

  static Widget iconContainer({
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
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
    required BuildContext context,
  }) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(title, style: AppTheme.h3.copyWith(color: primary)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: primary,
        elevation: 0,
        automaticallyImplyLeading: true,
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
