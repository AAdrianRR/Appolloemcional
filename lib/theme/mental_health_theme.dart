import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class MentalHealthTheme {
  static final Map<String, Color> _typeColors = {
    'publico': Colors.blue.shade400,
    'hospital': Colors.red.shade400,
    'asociacion': Colors.green.shade400,
  };

  static Color getTypeColor(String type) {
    return _typeColors[type] ?? Colors.grey;
  }

  static BoxDecoration cardDecoration = BoxDecoration(
    color: Colors.white.withOpacity(0.3),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(
      color: Colors.white.withOpacity(0.4),
      width: 2,
    ),
  );

  static BoxDecoration iconBoxDecoration(Color color) {
    return BoxDecoration(
      color: color.withOpacity(0.2),
      borderRadius: BorderRadius.circular(12),
    );
  }

  static BoxDecoration typeLabelDecoration(Color color) {
    return BoxDecoration(
      color: color.withOpacity(0.2),
      borderRadius: BorderRadius.circular(12),
    );
  }

  static BoxDecoration servicesDecoration = BoxDecoration(
    color: Colors.white.withOpacity(0.3),
    borderRadius: BorderRadius.circular(10),
  );

  static BoxDecoration filterChipDecoration(bool isSelected) {
    return BoxDecoration(
      gradient: isSelected ? AppTheme.cyanGradient : null,
      color: isSelected ? null : Colors.white.withOpacity(0.3),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: isSelected ? Colors.transparent : Colors.white.withOpacity(0.4),
        width: 2,
      ),
    );
  }

  // Estilo de texto para el Chip de Filtro
  static TextStyle filterChipTextStyle(bool isSelected, double s) {
    return TextStyle(
      fontSize: 14 * s,
      fontWeight: FontWeight.w600,
      color: isSelected ? Colors.white : AppTheme.foreground,
    );
  }

  // Estilo para botones de accion (Llamar/Mapa)
  static ButtonStyle actionButtonStyle(Color backgroundColor, double s) {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 12 * s),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
