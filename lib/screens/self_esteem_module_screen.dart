import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lottie/lottie.dart';
import '../theme/self_esteem_theme.dart';

class AchievementsJournalScreen extends StatelessWidget {
  const AchievementsJournalScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return SelfEsteemTheme.scaffold(
      title: 'Diario de Logros',
      body: const Center(
          child: Text('Hoy logré... (Escribe 3 pequeñas victorias)')),
    );
  }
}

class TaskItem {
  final String title;
  final String description;
  bool isCompleted;

  TaskItem(this.title, this.description, {this.isCompleted = false});
}

class SelfEsteemModuleScreen extends StatefulWidget {
  const SelfEsteemModuleScreen({super.key});

  @override
  State<SelfEsteemModuleScreen> createState() => _SelfEsteemModuleScreenState();
}

class _SelfEsteemModuleScreenState extends State<SelfEsteemModuleScreen> {
  // 1. Acciones de Amor Propio (Cuidado)
  final List<TaskItem> _selfCareTasks = [
    TaskItem('Postura de Poder',
        'Ponte de pie como superhéroe (manos en la cintura) por 2 minutos.',
        isCompleted: false),
    TaskItem('Espejo Positivo',
        'Mírate al espejo y di en voz alta una cosa que te guste de ti.',
        isCompleted: false),
    TaskItem('Cuidado Personal',
        'Dedica 5 minutos a arreglarte o cuidar tu piel hoy.',
        isCompleted: false),
  ];

  // 2. Fortaleza Mental (Cognitivo)
  final List<TaskItem> _mentalStrengthTasks = [
    TaskItem('Desafía al Crítico',
        'Detecta un pensamiento negativo sobre ti y cámbialo por uno neutro.',
        isCompleted: false),
    TaskItem('Lista de Habilidades',
        'Escribe 3 cosas en las que eres bueno/a (no importa lo pequeñas que sean).',
        isCompleted: false),
    TaskItem('Aceptación',
        'Recuerda el último cumplido que recibiste y acéptalo mentalmente ("Gracias").',
        isCompleted: false),
  ];

  bool get _isSelfCareComplete =>
      _selfCareTasks.every((task) => task.isCompleted);
  bool get _isMentalStrengthComplete =>
      _mentalStrengthTasks.every((task) => task.isCompleted);

  Widget _buildTaskItem(TaskItem task, int index) {
    return FadeInLeft(
      delay: Duration(milliseconds: 100 * index),
      child: SelfEsteemTheme.glassCard(
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
              style: SelfEsteemTheme.body.copyWith(
                fontWeight: FontWeight.w600,
                decoration: task.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                color: task.isCompleted
                    ? SelfEsteemTheme.mutedForeground
                    : SelfEsteemTheme.foreground,
              )),
          subtitle: Text(task.description, style: SelfEsteemTheme.caption),
          activeColor: SelfEsteemTheme.accent, // Ámbar
          checkColor: Colors.white,
          controlAffinity: ListTileControlAffinity.leading,
        ),
      ),
    );
  }

  Widget _buildRewardStar(bool isComplete) {
    return FadeIn(
      animate: isComplete,
      duration: const Duration(milliseconds: 800),
      child: Visibility(
        visible: isComplete,
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child:
              Icon(Icons.star_rounded, color: SelfEsteemTheme.accent, size: 35),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SelfEsteemTheme.scaffold(
      title: 'Cultiva tu Autoestima',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInDown(
              child: Container(
                height: 160,
                alignment: Alignment.center,
                child: Lottie.asset(
                  'assets/autos.json',
                  repeat: true,
                  animate: true,
                ),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              'Fortalece tu Confianza',
              style: SelfEsteemTheme.h2,
            ),
            const SizedBox(height: 25),

            // --- Tarjeta de Navegación: Diario de Logros ---
            FadeInUp(
              delay: const Duration(milliseconds: 100),
              child: SelfEsteemTheme.glassCard(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => const AchievementsJournalScreen()));
                },
                child: ListTile(
                  leading: SelfEsteemTheme.iconContainer(
                      icon: Icons.emoji_events, color: Colors.amber.shade800),
                  title: const Text('Diario de Logros',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  subtitle: Text('Registra tus pequeñas victorias.',
                      style: SelfEsteemTheme.caption),
                  trailing: Icon(Icons.arrow_forward_ios,
                      size: 16, color: SelfEsteemTheme.mutedForeground),
                ),
              ),
            ),
            const SizedBox(height: 30),

            Row(
              children: [
                Text('Acciones de Amor Propio', style: SelfEsteemTheme.h3),
                _buildRewardStar(_isSelfCareComplete),
              ],
            ),
            const SizedBox(height: 10),

            ..._selfCareTasks
                .map((task) => Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: _buildTaskItem(task, _selfCareTasks.indexOf(task)),
                    ))
                .toList(),

            const SizedBox(height: 30),

            Row(
              children: [
                Text('Fortaleza Mental', style: SelfEsteemTheme.h3),
                _buildRewardStar(_isMentalStrengthComplete),
              ],
            ),
            const SizedBox(height: 10),

            ..._mentalStrengthTasks
                .map((task) => Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: _buildTaskItem(
                          task,
                          _mentalStrengthTasks.indexOf(task) +
                              _selfCareTasks.length),
                    ))
                .toList(),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
