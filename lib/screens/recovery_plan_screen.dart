import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:animate_do/animate_do.dart';
import '../theme/journey_theme.dart';

class RecoveryPlanScreen extends StatefulWidget {
  const RecoveryPlanScreen({super.key});

  @override
  State<RecoveryPlanScreen> createState() => _RecoveryPlanScreenState();
}

class _RecoveryPlanScreenState extends State<RecoveryPlanScreen> {
  final List<Map<String, String>> _plans = [
    {
      'id': 'ansiedad',
      'title': 'Control de Ansiedad',
      'description':
          'Aprende a identificar detonantes y utiliza técnicas de respiración para recuperar la calma.',
      'lottie': 'assets/lottie/anxiety.json',
      'duration': '3 Semanas'
    },
    {
      'id': 'autoestima',
      'title': 'Amor Propio',
      'description':
          'Ejercicios diarios de espejo y gratitud para reconectar con tu valor interior.',
      'lottie': 'assets/lottie/growth.json',
      'duration': '4 Semanas'
    },
    {
      'id': 'depresion',
      'title': 'Manejo de la Tristeza',
      'description':
          'Pequeños pasos diarios para reactivar tu energía y encontrar momentos de luz.',
      'lottie': 'assets/lottie/sun.json',
      'duration': '6 Semanas'
    },
    {
      'id': 'estres',
      'title': 'Reducción de Estrés',
      'description':
          'Técnicas de organización y mindfulness para aligerar tu carga mental.',
      'lottie': 'assets/lottie/calm.json',
      'duration': '3 Semanas'
    },
  ];

  int _selectedIndex = 0;

  void _activatePlan() {
    final plan = _plans[_selectedIndex];

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: JourneyTheme.primary,
        duration: const Duration(seconds: 3),
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                "¡Plan de ${plan['title']} ACTIVO!",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activePlan = _plans[_selectedIndex];

    return JourneyTheme.scaffold(
      title: "Diseña tu Senda",
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            FadeInDown(
              child: Text(
                "¿En qué quieres enfocarte hoy?",
                textAlign: TextAlign.center,
                style: JourneyTheme.h2,
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 50,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _plans.length,
                separatorBuilder: (ctx, i) => const SizedBox(width: 10),
                itemBuilder: (ctx, index) {
                  final isSelected = _selectedIndex == index;
                  return ChoiceChip(
                    label: Text(_plans[index]['title']!.split(' ')[0] +
                        (index == 1 ? ' Propio' : '')), // Título corto
                    selected: isSelected,
                    selectedColor: JourneyTheme.primary,
                    backgroundColor: Colors.white.withOpacity(0.5),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : JourneyTheme.textColor,
                      fontWeight: FontWeight.bold,
                    ),
                    onSelected: (bool selected) {
                      if (selected) {
                        setState(() => _selectedIndex = index);
                      }
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 30),

            ZoomIn(
              key: ValueKey<int>(_selectedIndex),
              duration: const Duration(milliseconds: 800),
              child: Column(
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Lottie.asset(
                      activePlan['lottie']!,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.self_improvement,
                          size: 80,
                          color: JourneyTheme.primary.withOpacity(0.5)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    activePlan['title']!,
                    style: JourneyTheme.h1.copyWith(fontSize: 26),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            FadeInUp(
              key: ValueKey<String>(
                  "card_${activePlan['id']}"), // Animación al cambiar
              duration: const Duration(milliseconds: 500),
              child: JourneyTheme.infoCard(
                child: Column(
                  children: [
                    Text(
                      activePlan['description']!,
                      textAlign: TextAlign.center,
                      style: JourneyTheme.body,
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildInfoBadge(
                            Icons.timer_outlined, activePlan['duration']!),
                        _buildInfoBadge(Icons.bolt_rounded, "Nivel Intermedio"),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            FadeInUp(
              delay: const Duration(milliseconds: 600),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD).withOpacity(0.9),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF90CAF9)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.health_and_safety_outlined,
                        size: 32, color: Color(0xFF1565C0)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Esto funcionará de lujo si se lleva de la mano con un terapeuta.",
                        style: TextStyle(
                          color: const Color(0xFF1565C0),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            //  BOTÓN DE ACCIÓN
            FadeInUp(
              delay: const Duration(milliseconds: 700),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _activatePlan,
                  style: JourneyTheme.primaryButtonStyle,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("INICIAR AHORA"),
                      SizedBox(width: 10),
                      Icon(Icons.rocket_launch_rounded),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBadge(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: JourneyTheme.primary, size: 28),
        const SizedBox(height: 5),
        Text(
          label,
          style: JourneyTheme.caption.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
