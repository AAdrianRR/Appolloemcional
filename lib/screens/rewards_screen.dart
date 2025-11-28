import 'package:flutter/material.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color bgColor = const Color(0xFFF5F9FC);
    final Color primaryColor = const Color(0xFF4A90E2);

    final List<Map<String, dynamic>> badges = [
      {
        "title": "Vida Libre",
        "desc": "Redujiste tu nivel de ansiedad por 7 días consecutivos.",
        "icon": Icons.spa_rounded,
        "color": const Color(0xFF55EFC4),
        "category": "Ansiedad",
        "isUnlocked": true,
      },
      {
        "title": "Mente Serena",
        "desc":
            "Completaste el módulo de 'Respiración Profunda' durante una crisis.",
        "icon": Icons.air_rounded,
        "color": const Color(0xFF81ECEC),
        "category": "Ansiedad",
        "isUnlocked": true,
      },
      {
        "title": "Amanecer Dorado",
        "desc":
            "Te levantaste y registraste tu estado de ánimo antes de las 9 AM por 3 días.",
        "icon": Icons.wb_sunny_rounded,
        "color": const Color(0xFFFDCB6E),
        "category": "Depresión",
        "isUnlocked": true,
      },
      {
        "title": "Pasos Firmes",
        "desc":
            "Completaste 5 tareas pequeñas de tu Senda cuando no tenías ganas.",
        "icon": Icons.directions_walk_rounded,
        "color": const Color(0xFFFAB1A0),
        "category": "Depresión",
        "isUnlocked": false,
      },
      {
        "title": "Espejo Amigo",
        "desc": "Escribiste 3 cosas que amas de ti en el Diario de Gratitud.",
        "icon": Icons.favorite_rounded,
        "color": const Color(0xFFFF7675),
        "category": "Autoestima",
        "isUnlocked": false,
      },
      {
        "title": "Yo Valgo",
        "desc":
            "Completaste el ejercicio de 'Re-enmarcar pensamientos negativos'.",
        "icon": Icons.self_improvement_rounded,
        "color": const Color(0xFFA29BFE),
        "category": "Autoestima",
        "isUnlocked": false,
      },
      {
        "title": "Faro de Luz",
        "desc": "Enviaste un mensaje de apoyo en el Chat Anónimo.",
        "icon": Icons.lightbulb_circle_rounded,
        "color": const Color(0xFFFFEAA7),
        "category": "Social",
        "isUnlocked": false,
      },
      {
        "title": "Voz Valiente",
        "desc": "Interactuaste con Gaibu sobre un tema difícil para ti.",
        "icon": Icons.record_voice_over_rounded,
        "color": const Color(0xFF74B9FF),
        "category": "Social",
        "isUnlocked": true,
      },
      {
        "title": "Fuego Interior",
        "desc": "Mantuviste tu racha de la Senda por 10 días seguidos.",
        "icon": Icons.local_fire_department_rounded,
        "color": const Color(0xFFFF9F43),
        "category": "Constancia",
        "isUnlocked": true,
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        // 🔥 Determinar columnas automáticamente según ancho
        int crossAxisCount = width < 400
            ? 2
            : width < 700
                ? 3
                : 4;

        // 🔥 Escalar tamaños según tamaño de pantalla
        double sizeFactor = (width / 400).clamp(0.8, 1.4);

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            title: Text(
              "Tu Jardín de Logros",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 18 * sizeFactor,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black54),
          ),
          body: Column(
            children: [
              // --- ENCABEZADO ---
              Container(
                margin: const EdgeInsets.all(20),
                padding: EdgeInsets.all(20 * sizeFactor),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, primaryColor.withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12 * sizeFactor),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.emoji_events_rounded,
                          color: Colors.white, size: 36 * sizeFactor),
                    ),
                    SizedBox(width: 20 * sizeFactor),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Nivel: Guerrero de Luz",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20 * sizeFactor),
                          ),
                          SizedBox(height: 5 * sizeFactor),
                          Text(
                            "Has desbloqueado 5 de 9 insignias.",
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13 * sizeFactor),
                          ),
                          SizedBox(height: 12 * sizeFactor),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: 5 / 9,
                              backgroundColor: Colors.black12,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.white),
                              minHeight: 8 * sizeFactor,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),

              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: badges.length,
                  itemBuilder: (context, index) {
                    final badge = badges[index];
                    return _buildBadgeCard(badge, sizeFactor);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  //Ahora recibe sizeFactor para adaptar la tarjeta
  Widget _buildBadgeCard(Map<String, dynamic> badge, double sizeFactor) {
    bool unlocked = badge['isUnlocked'];

    return Container(
      padding: EdgeInsets.all(16 * sizeFactor),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: unlocked
            ? Border.all(color: badge['color'].withOpacity(0.3), width: 1.5)
            : null,
      ),
      child: Column(
        children: [
          // Categoría
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: 8 * sizeFactor, vertical: 2 * sizeFactor),
            decoration: BoxDecoration(
              color:
                  unlocked ? badge['color'].withOpacity(0.1) : Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              badge['category'].toUpperCase(),
              style: TextStyle(
                  fontSize: 9 * sizeFactor,
                  fontWeight: FontWeight.bold,
                  color: unlocked ? badge['color'] : Colors.grey[400]),
            ),
          ),
          const Spacer(),

          // Icono
          Container(
            padding: EdgeInsets.all(15 * sizeFactor),
            decoration: BoxDecoration(
              color:
                  unlocked ? badge['color'].withOpacity(0.15) : Colors.grey[50],
              shape: BoxShape.circle,
            ),
            child: Icon(
              badge['icon'],
              size: 34 * sizeFactor,
              color: unlocked ? badge['color'] : Colors.grey[300],
            ),
          ),
          SizedBox(height: 12 * sizeFactor),

          // Título
          Text(
            badge['title'],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15 * sizeFactor,
              color: unlocked ? Colors.black87 : Colors.grey[400],
            ),
          ),
          SizedBox(height: 6 * sizeFactor),

          // Descripción
          Text(
            unlocked
                ? badge['desc']
                : "Completa el reto para descubrir esta insignia.",
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11 * sizeFactor,
              color: unlocked ? Colors.grey[600] : Colors.grey[400],
              height: 1.2,
            ),
          ),
          const Spacer(),

          if (!unlocked)
            Icon(Icons.lock_outline_rounded,
                size: 16 * sizeFactor, color: Colors.grey[300]),
        ],
      ),
    );
  }
}
