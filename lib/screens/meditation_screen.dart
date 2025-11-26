import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lottie/lottie.dart';
import '../theme/meditation_theme.dart';
import '../widgets/meditation_timer.dart';

class TaskItem {
  final String title;
  final String description;
  bool isCompleted;
  TaskItem(this.title, this.description, {this.isCompleted = false});
}

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({super.key});

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  // --- MODELOS DE TAREAS ---
  final List<TaskItem> _meditationTasks = [
    TaskItem('Escaneo Corporal (Body Scan)',
        'Cierra los ojos y recorre mentalmente tu cuerpo de pies a cabeza, relajando cada músculo.',
        isCompleted: false),
    TaskItem('Visualización: Lugar Seguro',
        'Imagina un lugar donde te sientas completamente en paz. Nota los colores, sonidos y olores.',
        isCompleted: false),
    TaskItem('Respiración Consciente',
        'Siéntate en silencio 5 minutos. No intentes controlar tu respiración, solo obsérvala.',
        isCompleted: false),
    TaskItem('Meditación de la Vela',
        'Enciende una vela (o imagina una) y concentra toda tu atención en la llama por 3 minutos.',
        isCompleted: false),
  ];

  bool get _isSessionComplete =>
      _meditationTasks.every((task) => task.isCompleted);

  Widget _buildTaskItem(TaskItem task, int index) {
    return FadeInUp(
      delay: Duration(milliseconds: 150 * index),
      child: MeditationTheme.glassCard(
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
              style: MeditationTheme.body.copyWith(
                fontWeight: FontWeight.w600,
                decoration: task.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                color: task.isCompleted
                    ? MeditationTheme.mutedForeground
                    : MeditationTheme.foreground,
              )),
          subtitle: Text(task.description, style: MeditationTheme.caption),
          activeColor: MeditationTheme.accent,
          checkColor: Colors.white,
          controlAffinity: ListTileControlAffinity.leading,
        ),
      ),
    );
  }

  Widget _buildRewardLotus(bool isComplete) {
    return FadeIn(
      animate: isComplete,
      duration: const Duration(milliseconds: 800),
      child: Visibility(
        visible: isComplete,
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Icon(Icons.spa, color: Colors.purple.shade400, size: 30),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('Espacio Zen', style: MeditationTheme.h3),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: MeditationTheme.foreground,
        elevation: 0,
        automaticallyImplyLeading: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration:
            const BoxDecoration(gradient: MeditationTheme.meditationGradient),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // 1. Contenido Scrolleable (Atrás)
            SingleChildScrollView(
              // Padding extra abajo para que el temporizador no tape el último elemento
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInDown(
                    child: Container(
                      height: 180,
                      alignment: Alignment.center,
                      child: Lottie.asset(
                        'assets/Education.json',
                        repeat: true,
                        animate: true,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // TARJETA INFORMATIVA
                  FadeIn(
                    duration: const Duration(milliseconds: 800),
                    child: MeditationTheme.glassCard(
                      opacity: 0.4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              MeditationTheme.iconContainer(
                                  icon: Icons.lightbulb_outline,
                                  color: Colors.indigo),
                              const SizedBox(width: 10),
                              Text('¿Qué es la Meditación?',
                                  style: MeditationTheme.h3
                                      .copyWith(fontSize: 18)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'No es "dejar la mente en blanco". Es el entrenamiento de la atención para lograr claridad mental y calma emocional. Reduce el estrés, mejora el sueño y aumenta la autoconciencia.',
                            style: MeditationTheme.caption
                                .copyWith(fontSize: 14, height: 1.5),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ---  LISTA DE EJERCICIOS PROFUNDOS ---
                  Row(
                    children: [
                      Text('Prácticas Profundas', style: MeditationTheme.h2),
                      _buildRewardLotus(_isSessionComplete),
                    ],
                  ),
                  const SizedBox(height: 15),

                  ..._meditationTasks
                      .map((task) => Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: _buildTaskItem(
                                task, _meditationTasks.indexOf(task)),
                          ))
                      .toList(),
                ],
              ),
            ),

            //  BURBUJA FLOTANTE DEL TEMPORIZADOR (Enfrente)
            const Positioned(
              bottom: 30,
              child: MeditationTimer(),
            ),
          ],
        ),
      ),
    );
  }
}
