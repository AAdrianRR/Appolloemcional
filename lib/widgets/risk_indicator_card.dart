import 'package:flutter/material.dart';

// Simulación de la enumeración para el nivel de riesgo (viene del backend)

// Pequeña implementación local de ProgressTheme para evitar dependencia externa.
// Ajusta los colores según la paleta de tu aplicación o restaura la importación original.
class ProgressTheme {
  static const Color riskGreen = Color(0xFF4CAF50);
  static const Color riskYellow = Color(0xFFFFC107);
  static const Color riskRed = Color(0xFFF44336);
  static const Color primaryColor = Color(0xFF212121);
}

enum RiskLevel { green, yellow, red }

// ----------------------------------------------------
// 2. WIDGET DE INDICADOR CIRCULAR DE RIESGO
// ----------------------------------------------------

class RiskIndicatorCard extends StatelessWidget {
  // Las propiedades requeridas del backend
  final double score;
  final RiskLevel riskLevel;

  const RiskIndicatorCard({
    required this.score,
    required this.riskLevel,
    Key? key,
  }) : super(key: key);

  // Mapea el nivel de riesgo a un color
  Color get _color {
    switch (riskLevel) {
      case RiskLevel.green:
        return ProgressTheme.riskGreen;
      case RiskLevel.yellow:
        return ProgressTheme.riskYellow;
      case RiskLevel.red:
        return ProgressTheme.riskRed;
    }
  }

  // Mapea el nivel de riesgo a un texto
  String get _levelText {
    switch (riskLevel) {
      case RiskLevel.green:
        return 'BAJO';
      case RiskLevel.yellow:
        return 'MEDIO';
      case RiskLevel.red:
        return 'ALTO';
    }
  }

  @override
  Widget build(BuildContext context) {
    // El Card principal que contiene el indicador
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Estado de Riesgo Actual',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ProgressTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 20),

            // Layout principal: Indicador circular y detalles
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // 1. Indicador Circular de Progreso (Simulación)
                SizedBox(
                  height: 120,
                  width: 120,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // El indicador animado (simulado con un CircularProgressIndicator)
                      TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0.0, end: score / 100),
                        duration: const Duration(seconds: 1),
                        builder: (context, value, child) {
                          return CircularProgressIndicator(
                            value: value,
                            strokeWidth: 12,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(_color),
                          );
                        },
                      ),

                      // Texto de la puntuación en el centro
                      Text(
                        score.toInt().toString(),
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: _color,
                        ),
                      ),
                    ],
                  ),
                ),

                // 2. Texto de Nivel de Riesgo
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Nivel Identificado:',
                        style: TextStyle(fontSize: 14, color: Colors.grey)),
                    const SizedBox(height: 8),

                    // Chip/Badge que indica el nivel (BAJO/MEDIO/ALTO)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _color, width: 1.5),
                      ),
                      child: Text(
                        _levelText,
                        style: TextStyle(
                          color: _color,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Puntuación de Riesgo: ${score.toStringAsFixed(1)}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Lógica de mapeo de Score a RiskLevel (para simular el backend)
RiskLevel getRiskLevel(double score) {
  if (score <= 30) return RiskLevel.green;
  if (score <= 70) return RiskLevel.yellow;
  return RiskLevel.red;
}
