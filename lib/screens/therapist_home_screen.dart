import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // <--- IMPORTANTE PARA CERRAR SESIÓN
import 'auth_screen.dart'; // <--- IMPORTANTE PARA VOLVER AL LOGIN

import 'therapist_screen.dart';
import 'therapist_progress_screen.dart';
import 'therapist_patient_achievements_screen.dart';
import 'therapist_create_habit_screen.dart';

class TherapistHomeScreen extends StatelessWidget {
  const TherapistHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color bgColor = const Color(0xFFF5F9FC);
    final Color primaryColor = const Color(0xFF4A90E2);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Panel del Especialista",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            Text(
              "Bienvenido, Doctor.",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          // --- BOTÓN DE CERRAR SESIÓN (REAL) ---
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.black54),
            onPressed: () async {
              // 1. Cerrar sesión en Firebase
              await FirebaseAuth.instance.signOut();

              // 2. Volver a la pantalla de Login y borrar historial de navegación
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const AuthScreen()),
                  (route) =>
                      false, // Esto evita que pueda volver atrás con el botón físico
                );
              }
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              _buildBigCard(
                context,
                title: "Monitorear Paciente",
                description:
                    "Ingresa el ID del paciente para ver su semáforo de riesgo en tiempo real.",
                icon: Icons.health_and_safety_outlined,
                color: Colors.teal,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TherapistScreen()),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildBigCard(
                context,
                title: "Ver Progresos",
                description:
                    "Gráficas de evolución, cumplimiento de la Senda y estadísticas generales.",
                icon: Icons.bar_chart_rounded,
                color: primaryColor,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TherapistProgressScreen()),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildBigCard(
                context,
                title: "Expediente de Logros",
                description:
                    "Visualizar medallas e insignias obtenidas por el paciente en su tratamiento.",
                icon: Icons.emoji_events_rounded,
                color: Colors.indigoAccent,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const TherapistPatientAchievementsScreen()),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildBigCard(
                context,
                title: "Crear Rutina / Hábito",
                description:
                    "Asignar nuevos ejercicios o tareas personalizadas a la Senda del paciente.",
                icon: Icons.edit_calendar_rounded,
                color: const Color(0xFFA29BFE),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const TherapistCreateHabitScreen()),
                  );
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBigCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 36),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3436),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded,
                    color: Colors.grey[400], size: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
