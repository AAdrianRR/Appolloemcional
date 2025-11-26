import 'package:flutter/material.dart';
import 'app_theme.dart';

class AnxietyTheme {
  //  Degradado de Ansiedad/Calma (4 colores suaves y fríos)
  static const LinearGradient anxietyGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFE8F6FA), // Azul muy claro (Casi blanco)
      Color(0xFFD2E8FF), // Azul Bebé
      Color(0xFFC7E2E4), // Cian Menta muy claro
      Color(0xFFFFFFFF), // Blanco puro
    ],
  );

  static AppBar anxietyAppBar({required String title}) {
    return AppBar(
      title: Text(title, style: AppTheme.h3),
      backgroundColor: Colors.transparent,
      foregroundColor: AppTheme.foreground,
      elevation: 0,
      automaticallyImplyLeading: true,
    );
  }
}
