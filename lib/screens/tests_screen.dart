// lib/screens/tests_screen.dart

import 'package:flutter/material.dart';

class TestsScreen extends StatelessWidget {
  const TestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Rápido de Bienestar'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Escala PHQ-9 (Simplificada)',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Evalúa el nivel de depresión en las últimas dos semanas. (MVP: No funcional, solo visual)',
              style: TextStyle(color: Colors.grey),
            ),
            const Divider(height: 30),

            // ⚠️ Muestra las preguntas como tarjetas de acción ⚠️
            _buildTestQuestion(
              context,
              '1. ¿Te has sentido desanimado/a, deprimido/a o sin esperanza?',
              'Casi todos los días',
            ),
            _buildTestQuestion(
              context,
              '2. ¿Has tenido poco interés o placer en hacer las cosas?',
              'Varios días',
            ),
            _buildTestQuestion(
              context,
              '3. ¿Problemas para conciliar el sueño o has dormido demasiado?',
              'Más de la mitad de los días',
            ),

            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Test Enviado (MVP).')));
                  Navigator.of(context).pop();
                },
                child: const Text('Finalizar Test',
                    style: TextStyle(fontSize: 18, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade700,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Componente de Diseño Modular para la Pregunta
  Widget _buildTestQuestion(
      BuildContext context, String question, String sampleAnswer) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(question,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            const SizedBox(height: 10),
            // Simulación de la respuesta
            ListTile(
              leading:
                  const Icon(Icons.radio_button_checked, color: Colors.indigo),
              title: Text(sampleAnswer,
                  style: const TextStyle(fontWeight: FontWeight.w500)),
              dense: true,
            ),
          ],
        ),
      ),
    );
  }
}
