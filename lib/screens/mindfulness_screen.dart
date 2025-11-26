import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../theme/app_theme.dart';
import '../theme/stress_theme.dart';
import 'package:lottie/lottie.dart';

class RespirationScreen extends StatelessWidget {
  const RespirationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return StressTheme.scaffoldWithStressGradient(
      appBar: StressTheme.stressAppBar(title: 'Técnica de Respiración 4-7-8'),
      body: const Center(
          child: Text('Instrucciones para la respiración guiada (MVP)')),
    );
  }
}

class MeditationScreen extends StatelessWidget {
  const MeditationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return StressTheme.scaffoldWithStressGradient(
      appBar: StressTheme.stressAppBar(title: 'Meditación Guiada'),
      body: const Center(child: Text('Página de Meditación Guiada (MVP)')),
    );
  }
}

class OverthinkingScreen extends StatelessWidget {
  const OverthinkingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return StressTheme.scaffoldWithStressGradient(
      appBar:
          StressTheme.stressAppBar(title: 'Herramientas de Sobrepensamiento'),
      body: const Center(child: Text('Ejercicio de Grounding (MVP)')),
    );
  }
}

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return StressTheme.scaffoldWithStressGradient(
      appBar: StressTheme.stressAppBar(title: 'Juego de Concentración'),
      body: const Center(child: Text('Mini Juego de Enfoque (MVP)')),
    );
  }
}

class TaskItem {
  final String title;
  final String description;
  bool isCompleted;

  TaskItem(this.title, this.description, {this.isCompleted = false});
}

class MindfulnessScreen extends StatefulWidget {
  const MindfulnessScreen({super.key});

  @override
  State<MindfulnessScreen> createState() => _MindfulnessScreenState();
}

class _MindfulnessScreenState extends State<MindfulnessScreen> {
  final List<TaskItem> _physicalTasks = [
    TaskItem('Estiramiento de Cuello',
        'Inclina la cabeza suavemente hacia cada hombro, 5 segundos por lado.',
        isCompleted: false),
    TaskItem('Estiramiento de Brazos',
        'Estira ambos brazos hacia el cielo por 10 segundos, sintiendo la tensión.',
        isCompleted: false),
    TaskItem(
        'Rotación de Muñecas', 'Gira tus muñecas 10 veces en cada dirección.',
        isCompleted: false),
  ];
  final List<TaskItem> _mentalTasks = [
    TaskItem('Tararea tu canción favorita',
        'Hazlo en voz alta durante 30 segundos, concentrándote solo en la melodía.',
        isCompleted: false),
    TaskItem('Nombra 5 colores diferentes',
        'Mira a tu alrededor y nombra 5 objetos con colores distintos.',
        isCompleted: false),
    TaskItem('Cuenta hacia atrás',
        'Cuenta de 100 a 97, concentrándote en cada número.',
        isCompleted: false),
  ];

  bool get _isPhysicalSectionComplete =>
      _physicalTasks.every((task) => task.isCompleted);
  bool get _isMentalSectionComplete =>
      _mentalTasks.every((task) => task.isCompleted);

  Widget _buildTaskItem(TaskItem task, int index) {
    return FadeInLeft(
      delay: Duration(milliseconds: 100 * index),
      child: AppTheme.glassCard(
        opacity: 0.6,
        padding: EdgeInsets.zero,
        child: CheckboxListTile(
          value: task.isCompleted,
          onChanged: (bool? newValue) {
            setState(() {
              task.isCompleted = newValue ?? false;
            });
          },
          title: Text(task.title,
              style: AppTheme.body.copyWith(
                fontWeight: FontWeight.w600,
                decoration: task.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                color: task.isCompleted
                    ? AppTheme.mutedForeground
                    : AppTheme.foreground,
              )),
          subtitle: Text(task.description, style: AppTheme.caption),
          activeColor: Theme.of(context).primaryColor,
          controlAffinity: ListTileControlAffinity.leading,
        ),
      ),
    );
  }

  // Widget de Recompensa (Corazón Animado)
  Widget _buildRewardHeart(bool isComplete) {
    return FadeIn(
      animate: isComplete,
      duration: const Duration(milliseconds: 800),
      child: Visibility(
        visible: isComplete,
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Icon(Icons.favorite, color: Colors.pink.shade400, size: 30),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StressTheme.scaffoldWithStressGradient(
      appBar: StressTheme.stressAppBar(title: 'Controla el Estrés'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInDown(
              child: Container(
                height: 150,
                alignment: Alignment.center,
                child: Lottie.asset(
                  'assets/Meditation.json',
                  repeat: true,
                  animate: true,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Técnicas de Afrontamiento Rápido',
              style: AppTheme.h2.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 25),
            FadeInUp(
              delay: const Duration(milliseconds: 100),
              child: AppTheme.glassCard(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => const RespirationScreen()));
                },
                opacity: 0.5,
                padding: const EdgeInsets.all(12),
                child: ListTile(
                  leading: AppTheme.iconContainer(
                      icon: Icons.air, color: Colors.teal),
                  title: const Text('Técnica de Respiración 4-7-8',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text('Comienza con esto para centrarte.',
                      style: AppTheme.caption),
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Text('Ejercicios de Grounding',
                    style: AppTheme.h3.copyWith(fontWeight: FontWeight.bold)),
                _buildRewardHeart(_isPhysicalSectionComplete),
              ],
            ),
            const SizedBox(height: 10),
            ..._physicalTasks
                .map((task) => Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: _buildTaskItem(task, _physicalTasks.indexOf(task)),
                    ))
                .toList(),
            Container(
              height: 1,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 20),
              color: AppTheme.muted.withOpacity(0.5),
            ),
            Row(
              children: [
                Text('Bloqueo Mental Rápido',
                    style: AppTheme.h3.copyWith(fontWeight: FontWeight.bold)),
                _buildRewardHeart(_isMentalSectionComplete), // ⬅️ Recompensa
              ],
            ),
            const SizedBox(height: 10),
            ..._mentalTasks
                .map((task) => Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: _buildTaskItem(task,
                          _mentalTasks.indexOf(task) + _physicalTasks.length),
                    ))
                .toList(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
