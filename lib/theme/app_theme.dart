import 'package:flutter/material.dart';
import 'dart:ui';

class AppTheme {
  // Modo Claro (Light)
  static const Color background = Color(0xFFFFFFFF);
  static const Color foreground = Color(0xFF030213);
  static const Color card = Color(0xFFFFFFFF);
  static const Color cardForeground = Color(0xFF030213);

  static const Color primary = Color(0xFF030213);
  static const Color primaryForeground = Color(0xFFFFFFFF);

  static const Color secondary = Color(0xFFF3F3F5);
  static const Color secondaryForeground = Color(0xFF030213);

  static const Color muted = Color(0xFFECECF0);
  static const Color mutedForeground = Color(0xFF717182);

  static const Color accent = Color(0xFFE9EBEF);
  static const Color accentForeground = Color(0xFF030213);

  static const Color destructive = Color(0xFFD4183D);
  static const Color destructiveForeground = Color(0xFFFFFFFF);

  static const Color border = Color(0x1A000000); // rgba(0,0,0,0.1)
  static const Color inputBackground = Color(0xFFF3F3F5);
  static const Color switchBackground = Color(0xFFCBCED4);

  // Colores especiales para gráficos/charts
  static const Color chart1 = Color(0xFFFF8A65);
  static const Color chart2 = Color(0xFF4DD0E1);
  static const Color chart3 = Color(0xFF5C6BC0);
  static const Color chart4 = Color(0xFFFFD54F);
  static const Color chart5 = Color(0xFFFF7043);

  // Sidebar (para menús laterales)
  static const Color sidebar = Color(0xFFFBFBFB);
  static const Color sidebarForeground = Color(0xFF030213);
  static const Color sidebarPrimary = Color(0xFF030213);
  static const Color sidebarBorder = Color(0xFFEBEBEB);

  // ==================== GRADIENTES ====================

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFF0F5FD), // Azul muy claro
      Color(0xFFF9F0F5), // Rosado muy claro
    ],
  );

  static const LinearGradient cyanGradient = LinearGradient(
    colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient fabGradient = LinearGradient(
    colors: [Color(0xFF00C6FF), Color(0xFF32C7FF)],
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
  );

  static const double radiusBase = 10.0;
  static const double radiusSm = 6.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 10.0;
  static const double radiusXl = 14.0;

  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          offset: const Offset(0, 4),
          blurRadius: 15,
        ),
      ];

  static List<BoxShadow> glowShadow(Color color) => [
        BoxShadow(
          color: color.withOpacity(0.4),
          offset: const Offset(0, 4),
          blurRadius: 10,
        ),
      ];

  static const TextStyle h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w500,
    color: foreground,
    height: 1.5,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    color: foreground,
    height: 1.5,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: foreground,
    height: 1.5,
  );

  static const TextStyle h4 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: foreground,
    height: 1.5,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: foreground,
    height: 1.5,
  );

  static const TextStyle label = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: foreground,
    height: 1.5,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.5,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: mutedForeground,
    height: 1.5,
  );

  static Widget glassCard({
    required Widget child,
    VoidCallback? onTap,
    EdgeInsets padding = const EdgeInsets.all(16),
    double opacity = 0.4,
  }) {
    final cardWidget = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(opacity),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.4),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            offset: const Offset(0, 8),
            blurRadius: 24,
            spreadRadius: 0,
          ),
          // Brillo interno (arriba)
          BoxShadow(
            color: Colors.white.withOpacity(0.6),
            offset: const Offset(0, -1),
            blurRadius: 4,
            spreadRadius: -1,
          ),
        ],
      ),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        splashColor: Colors.white.withOpacity(0.2),
        highlightColor: Colors.white.withOpacity(0.1),
        child: cardWidget,
      );
    }
    return cardWidget;
  }

  static Widget iconContainer({
    required IconData icon,
    required Color color,
    double size = 24,
    double padding = 8,
  }) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: size, color: color),
    );
  }

  static Widget scaffoldWithGradient({
    PreferredSizeWidget? appBar,
    required Widget body,
    Widget? floatingActionButton,
    FloatingActionButtonLocation? floatingActionButtonLocation,
    Widget? drawer,
    Widget? bottomNavigationBar,
  }) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: appBar,
      drawer: drawer,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      body: Container(
        decoration: const BoxDecoration(gradient: backgroundGradient),
        child: body,
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: Color(0xFF4A90E2),
        surface: background,
        error: destructive,
      ),
      scaffoldBackgroundColor: Colors.transparent,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: foreground,
        elevation: 0,
        centerTitle: false,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: primaryForeground,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusLg),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusLg),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      cardTheme: const CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }
}
