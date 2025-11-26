// lib/screens/therapist_screen.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/semaforo_widget.dart';

class TherapistScreen extends StatefulWidget {
  const TherapistScreen({super.key});

  @override
  State<TherapistScreen> createState() => _TherapistScreenState();
}

class _TherapistScreenState extends State<TherapistScreen> {
  final _tokenController = TextEditingController();
  String? _patientToken; // ID del paciente (el usuario.uid)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Seguimiento (Terapeuta)'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _tokenController,
              decoration: const InputDecoration(
                labelText: 'Ingresa ID del Paciente (Token)',
                hintText: 'Ej. I0ZolyGYIYYSJFAnXSyI85lFPJI1*',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _patientToken = _tokenController.text.trim();
                });
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              child: const Text('Monitorear',
                  style: TextStyle(color: Colors.white)),
            ),

            const Divider(height: 30),

            // --- 2. Vista de Seguimiento ---
            if (_patientToken == null || _patientToken!.isEmpty)
              const Text(
                  'Ingresa un ID de paciente para ver su estado de riesgo.'),

            if (_patientToken != null && _patientToken!.isNotEmpty)
              Expanded(
                child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('resumen_riesgo')
                      .doc(_patientToken!)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return const Center(
                          child: Text(
                              'Paciente no encontrado o sin datos de riesgo.'));
                    }

                    final data = snapshot.data!.data() as Map<String, dynamic>;

                    return SemaforoDisplay(data: data);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
