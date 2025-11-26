// lib/screens/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/semaforo_widget.dart';
import 'therapist_screen.dart';
import '../theme/profile_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'no_id';

    return ProfileTheme.scaffold(
      title: 'Mi Progreso y Datos',
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 10),
            Text('Mi Cuenta', style: ProfileTheme.h2),
            const SizedBox(height: 10),
            ProfileTheme.glassCard(
              opacity: 0.9,
              padding: const EdgeInsets.all(12),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.badge_outlined,
                    color: ProfileTheme.foreground, size: 30),
                title: Text('Mi ID de Paciente (Token)',
                    style: ProfileTheme.body
                        .copyWith(fontWeight: FontWeight.bold)),
                subtitle: Text(userId,
                    style: ProfileTheme.caption.copyWith(fontSize: 12)),
                trailing: IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('ID copiado.')));
                  },
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text('Estado de Riesgo Acumulado', style: ProfileTheme.h2),
            const SizedBox(height: 15),
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('resumen_riesgo')
                  .doc(userId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final data = snapshot.hasData && snapshot.data!.exists
                    ? snapshot.data!.data() as Map<String, dynamic>
                    : {'ultimoSemaforo': 'VERDE', 'ultimoRiesgoScore': 0};

                return SemaforoDisplay(data: data);
              },
            ),
            const SizedBox(height: 40),
            Text('Acceso Exclusivo', style: ProfileTheme.h2),
            const SizedBox(height: 15),
            ProfileTheme.glassCard(
              opacity: 0.9,
              padding: const EdgeInsets.all(8),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => const TherapistScreen()));
              },
              child: ListTile(
                leading: ProfileTheme.iconContainer(
                    icon: Icons.psychology, color: Colors.teal),
                title: Text('Ingresar como Terapeuta',
                    style: ProfileTheme.body
                        .copyWith(fontWeight: FontWeight.bold)),
                subtitle:
                    const Text('Monitoreo del estado de riesgo por Token.'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
