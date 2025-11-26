// lib/widgets/meditation_timer.dart

import 'package:flutter/material.dart';
import 'dart:async';

class MeditationTimer extends StatefulWidget {
  const MeditationTimer({super.key});

  @override
  State<MeditationTimer> createState() => _MeditationTimerState();
}

class _MeditationTimerState extends State<MeditationTimer> {
  Timer? _timer;
  int _secondsElapsed = 0;
  bool _isActive = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _isActive = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsElapsed++;
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _isActive = false;
      _secondsElapsed = 0; // O puedes dejarlo pausado si prefieres
    });
  }

  String _formatTime(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isActive ? _stopTimer : _startTimer,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding:
            EdgeInsets.symmetric(horizontal: _isActive ? 30 : 20, vertical: 15),
        decoration: BoxDecoration(
          // Diseño Glasmorfismo Oscuro para contraste o Color Primario
          color: _isActive
              ? const Color.fromARGB(255, 82, 106, 218).withOpacity(0.9)
              : const Color.fromARGB(255, 82, 74, 201).withOpacity(0.9),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: _isActive
                  ? const Color.fromARGB(255, 67, 47, 241).withOpacity(0.3)
                  : const Color.fromARGB(255, 3, 109, 231).withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _isActive
                  ? Icons.stop_circle_outlined
                  : Icons.play_circle_outline,
              color: Colors.white,
              size: 28,
            ),
            const SizedBox(width: 10),
            // Texto animado (Cambia entre "Iniciar" y el Tiempo)
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: _isActive
                  ? Text(
                      _formatTime(_secondsElapsed),
                      key: ValueKey(
                          _secondsElapsed), // Key para animar cambio de números
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    )
                  : const Text(
                      "Iniciar Meditación",
                      key: ValueKey("start"),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
