// lib/screens/depression_module_screen.dart

import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lottie/lottie.dart';
import '../theme/depression_theme.dart'; // ⬅️ SOLO importa el tema de depresión

class GratitudeJournalScreen extends StatelessWidget {
  const GratitudeJournalScreen({super.key});
  @override
  Widget build(BuildContext context) {
    // Usa el scaffold del tema propio
    return DepressionTheme.scaffold(
      title: 'Diario de Gratitud',
      body: const Center(
          child: Text('Escribe 3 cosas por las que agradeces hoy. (MVP)')),
    );
  }
}

class TaskItem {
  final String title;
  final String description;
  bool isCompleted;

  TaskItem(this.title, this.description, {this.isCompleted = false});
}

class DepressionModuleScreen extends StatefulWidget {
  const DepressionModuleScreen({super.key});

  @override
  State<DepressionModuleScreen> createState() => _DepressionModuleScreenState();
}

class _DepressionModuleScreenState extends State<DepressionModuleScreen> {
  // --- MODELOS DE TAREAS ---
  final List<TaskItem> _activationTasks = [
    TaskItem('Levantarse y Estirar',
        'Sal de la cama y estira los brazos hacia arriba por 10 segundos.',
        isCompleted: false),
    TaskItem('Hidratación', 'Bebe un vaso completo de agua fresca.',
        isCompleted: false),
    TaskItem('Luz Natural',
        'Abre las cortinas o sal afuera por 2 minutos para recibir luz.',
        isCompleted: false),
  ];

  final List<TaskItem> _emotionalTasks = [
    TaskItem(
        'Contacto Mínimo', 'Envía un mensaje o un emoji a un amigo o familiar.',
        isCompleted: false),
    TaskItem('Higiene Básica',
        'Lávate la cara con agua fría o cepíllate los dientes.',
        isCompleted: false),
    TaskItem('Una Cosa Buena', 'Identifica una cosa pequeña que te guste hoy.',
        isCompleted: false),
  ];

  bool get _isActivationComplete =>
      _activationTasks.every((task) => task.isCompleted);
  bool get _isEmotionalComplete =>
      _emotionalTasks.every((task) => task.isCompleted);

  // --------------------------------------------------------------------------
  // 🎨 WIDGETS AUXILIARES (Usando DepressionTheme)
  // --------------------------------------------------------------------------

  Widget _buildTaskItem(TaskItem task, int index) {
    return FadeInLeft(
      delay: Duration(milliseconds: 100 * index),
      child: DepressionTheme.glassCard(
        // ⬅️ Usa el card del tema propio
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
              style: DepressionTheme.body.copyWith(
                fontWeight: FontWeight.w600,
                decoration: task.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                color: task.isCompleted
                    ? DepressionTheme.mutedForeground
                    : DepressionTheme.foreground,
              )),
          subtitle: Text(task.description, style: DepressionTheme.caption),
          activeColor: DepressionTheme.accentOrange,
          checkColor: Colors.white,
          controlAffinity: ListTileControlAffinity.leading,
        ),
      ),
    );
  }

  Widget _buildRewardHeart(bool isComplete) {
    return FadeIn(
      animate: isComplete,
      duration: const Duration(milliseconds: 800),
      child: Visibility(
        visible: isComplete,
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child:
              Icon(Icons.sunny, color: DepressionTheme.accentOrange, size: 30),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ⚠️ USO DEL Scaffold Autónomo
    return DepressionTheme.scaffold(
      title: 'Módulo de Ánimo',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🚀 ANIMACIÓN LOTTIE CENTRAL
            FadeInDown(
              child: Container(
                height: 160,
                alignment: Alignment.center,
                child: Lottie.asset(
                  'assets/depresion.json',
                  repeat: true,
                  animate: true,
                ),
              ),
            ),
            const SizedBox(height: 10),

            Text(
              'Pequeños Pasos para Sentirte Mejor',
              style: DepressionTheme.h2,
            ),
            const SizedBox(height: 25),

            // --- Tarea Especial: Diario de Gratitud ---
            FadeInUp(
              delay: const Duration(milliseconds: 100),
              child: DepressionTheme.glassCard(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => const GratitudeJournalScreen()));
                },
                child: ListTile(
                  leading: DepressionTheme.iconContainer(
                      icon: Icons.book, color: Colors.orange),
                  title: const Text('Diario de Gratitud',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Escribe 3 cosas positivas hoy.',
                      style: DepressionTheme.caption),
                  trailing: Icon(Icons.arrow_forward_ios,
                      size: 16, color: DepressionTheme.mutedForeground),
                ),
              ),
            ),
            const SizedBox(height: 15),

            // --- SECCIÓN 1: Activación Conductual ---
            Row(
              children: [
                Text('Pequeñas Victorias', style: DepressionTheme.h3),
                _buildRewardHeart(_isActivationComplete),
              ],
            ),
            const SizedBox(height: 10),

            ..._activationTasks
                .map((task) => Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child:
                          _buildTaskItem(task, _activationTasks.indexOf(task)),
                    ))
                .toList(),

            // ⚠️ SEPARADOR LIMPIO
            Container(
              height: 1,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 20),
              color: DepressionTheme.mutedForeground.withOpacity(0.2),
            ),

            // --- SECCIÓN 2: Autocuidado ---
            Row(
              children: [
                Text('Autocuidado Básico', style: DepressionTheme.h3),
                _buildRewardHeart(_isEmotionalComplete),
              ],
            ),
            const SizedBox(height: 10),

            ..._emotionalTasks
                .map((task) => Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: _buildTaskItem(
                          task,
                          _emotionalTasks.indexOf(task) +
                              _activationTasks.length),
                    ))
                .toList(),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
