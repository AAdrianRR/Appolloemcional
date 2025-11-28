import 'package:flutter/material.dart';

class TherapistPatientAchievementsScreen extends StatelessWidget {
  final String patientName;

  const TherapistPatientAchievementsScreen({
    super.key,
    this.patientName = "Juan Pérez",
  });

  @override
  Widget build(BuildContext context) {
    final Color bgColor = const Color(0xFFF5F9FC);

    final List<Map<String, dynamic>> earnedBadges = [
      {
        "title": "Amanecer Dorado",
        "category": "Depresión",
        "date": "25 Nov 2025",
        "color": const Color(0xFFFDCB6E),
        "icon": Icons.wb_sunny_rounded,
      },
      {
        "title": "Vida Libre",
        "category": "Ansiedad",
        "date": "24 Nov 2025",
        "color": const Color(0xFF55EFC4),
        "icon": Icons.spa_rounded,
      },
      {
        "title": "Fuego Interior",
        "category": "Constancia",
        "date": "20 Nov 2025",
        "color": const Color(0xFFFF9F43),
        "icon": Icons.local_fire_department_rounded,
      },
      {
        "title": "Voz Valiente",
        "category": "Social",
        "date": "15 Nov 2025",
        "color": const Color(0xFF74B9FF),
        "icon": Icons.record_voice_over_rounded,
      },
    ];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text("Logros Terapéuticos",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TARJETA DE PERFIL
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.blueAccent.withOpacity(0.1),
                  child: Text(patientName.substring(0, 1),
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent)),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patientName,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                    const Text(
                      "Paciente Activo • Nivel Guerrero",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                )
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              "Historial de Insignias",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text(
              "Hitos alcanzados en el tratamiento digital.",
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // LISTA DE LOGROS
            ...earnedBadges.map((badge) => _buildTherapistBadgeItem(badge)),

            if (earnedBadges.isEmpty)
              const Center(child: Text("El paciente aún no tiene insignias.")),
          ],
        ),
      ),
    );
  }

  Widget _buildTherapistBadgeItem(Map<String, dynamic> badge) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
        border: Border(left: BorderSide(color: badge['color'], width: 4)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: badge['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(badge['icon'], color: badge['color'], size: 22),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  badge['title'],
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        badge['category'].toUpperCase(),
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600]),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "• ${badge['date']}",
                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(Icons.check_circle_rounded, color: Colors.green[300], size: 18),
        ],
      ),
    );
  }
}
