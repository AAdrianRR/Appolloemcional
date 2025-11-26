// lib/widgets/semaforo_widget.dart

import 'package:flutter/material.dart';

class SemaforoDisplay extends StatelessWidget {
  final Map<String, dynamic> data;

  const SemaforoDisplay({required this.data, super.key});

  Color _getColor(String semaforo) {
    switch (semaforo.toUpperCase()) {
      case 'ROJO':
        return Colors.red.shade700;
      case 'AMARILLO':
        return Colors.amber.shade700;
      case 'VERDE':
      default:
        return Colors.green.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Lectura de datos del resumen_riesgo
    final semaforo = data['ultimoSemaforo'] as String? ?? 'VERDE';
    final score = data['ultimoRiesgoScore'] ?? 0;
    final patrones =
        data['ultimoAnalisisPatrones'] as String? ?? 'Ninguno detectado.';
    final recurrencia = data['recurrenciaDias'] ?? 0;

    final color = _getColor(semaforo);

    return Center(
      child: Card(
        elevation: 8,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'ESTADO DE RIESGO ACUMULADO',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 20),
              // Indicador Visual
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.5),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    semaforo,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Métrica y Patrones
              Text('Puntuación Acumulada: $score / 10',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),

              const Text('Patrones Recientes:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(patrones, textAlign: TextAlign.center),
              const SizedBox(height: 8),

              Text('Recurrencia (7 días): $recurrencia mensajes de riesgo.',
                  style: const TextStyle(fontStyle: FontStyle.italic)),
            ],
          ),
        ),
      ),
    );
  }
}
