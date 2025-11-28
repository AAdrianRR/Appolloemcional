import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui';

class CrisisScreen extends StatefulWidget {
  const CrisisScreen({super.key});

  @override
  State<CrisisScreen> createState() => _CrisisScreenState();
}

class _CrisisScreenState extends State<CrisisScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  bool _showConfirmation = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  double scale(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width / 390;
  }

  //  LLAMAR AL 911
  Future<void> _callEmergency() async {
    final uri = Uri.parse('tel:911');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo realizar la llamada')),
        );
      }
    }
  }

  Future<void> _callPreventionLine() async {
    final uri = Uri.parse('tel:5552598121');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _openWhatsApp() async {
    final uri = Uri.parse('https://wa.me/5215512345678?text=Necesito%20ayuda');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _showConfirmDialog() {
    setState(() => _showConfirmation = true);
  }

  void _hideConfirmDialog() {
    setState(() => _showConfirmation = false);
  }

  @override
  Widget build(BuildContext context) {
    final s = scale(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A0E0E),
              Color(0xFF4A0E0E),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.all(20 * s),
                child: Column(
                  children: [
                    // Botón cerrar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FadeInLeft(
                          child: IconButton(
                            icon: Icon(Icons.arrow_back,
                                color: Colors.white, size: 28 * s),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        FadeInRight(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16 * s, vertical: 8 * s),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Colors.red.shade300, width: 2),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.emergency,
                                    color: Colors.red.shade300, size: 20 * s),
                                SizedBox(width: 8 * s),
                                Text('EMERGENCIA',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12 * s)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 30 * s),

                    FadeInDown(
                      delay: const Duration(milliseconds: 200),
                      child: Text(
                        'No estás solo',
                        style: TextStyle(
                          fontSize: 36 * s,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    SizedBox(height: 16 * s),

                    FadeIn(
                      delay: const Duration(milliseconds: 400),
                      child: Text(
                        'Estamos aquí para ayudarte. Tu vida es importante.',
                        style: TextStyle(
                          fontSize: 18 * s,
                          color: Colors.white70,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    SizedBox(height: 50 * s),

                    ZoomIn(
                      delay: const Duration(milliseconds: 600),
                      child: GestureDetector(
                        onTap: _showConfirmDialog,
                        child: AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: 1.0 + (_pulseController.value * 0.1),
                              child: Container(
                                width: 280 * s,
                                height: 280 * s,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.red.withOpacity(0.6),
                                      blurRadius: 40 * _pulseController.value,
                                      spreadRadius: 10 * _pulseController.value,
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: RadialGradient(
                                          colors: [
                                            Colors.red.shade700,
                                            Colors.red.shade900,
                                          ],
                                        ),
                                      ),
                                    ),
                                    Lottie.network(
                                      'https://lottie.host/d9c7d4e5-4c44-4c8e-9a2e-8e5c5c5c5c5c/x8ZpqY8vQK.json',
                                      width: 200 * s,
                                      height: 200 * s,
                                      fit: BoxFit.contain,
                                      errorBuilder: (context, error, stack) {
                                        return Icon(Icons.sos,
                                            size: 120 * s, color: Colors.white);
                                      },
                                    ),
                                    Positioned(
                                      bottom: 40 * s,
                                      child: Text(
                                        'SOS',
                                        style: TextStyle(
                                          fontSize: 48 * s,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                          shadows: [
                                            Shadow(
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              blurRadius: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    SizedBox(height: 30 * s),

                    FadeInUp(
                      delay: const Duration(milliseconds: 800),
                      child: Text(
                        'Presiona para llamar al linea amarilla no tiene costo alguno y puede salvar tu vida.',
                        style: TextStyle(
                          fontSize: 16 * s,
                          color: Colors.white70,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    SizedBox(height: 50 * s),

                    FadeInUp(
                      delay: const Duration(milliseconds: 1000),
                      child: Text(
                        'Otros recursos de ayuda',
                        style: TextStyle(
                          fontSize: 20 * s,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    SizedBox(height: 20 * s),

                    _buildResourceCard(
                      context,
                      icon: Icons.phone_in_talk,
                      title: 'Línea de Prevención del Suicidio',
                      subtitle: 'SAPTEL: 55 5259-8121',
                      color: Colors.blue.shade300,
                      onTap: _callPreventionLine,
                      delay: 1200,
                    ),

                    SizedBox(height: 12 * s),

                    _buildResourceCard(
                      context,
                      icon: Icons.chat_bubble_outline,
                      title: 'Chat de Apoyo',
                      subtitle: 'Habla con alguien ahora',
                      color: Colors.green.shade300,
                      onTap: _openWhatsApp,
                      delay: 1400,
                    ),

                    SizedBox(height: 12 * s),

                    _buildResourceCard(
                      context,
                      icon: Icons.air,
                      title: 'Ejercicio de Respiración',
                      subtitle: 'Calma inmediata',
                      color: Colors.purple.shade300,
                      onTap: () {
                        Navigator.pop(context);
                      },
                      delay: 1600,
                    ),

                    SizedBox(height: 100 * s),
                  ],
                ),
              ),
              if (_showConfirmation)
                AnimatedOpacity(
                  opacity: _showConfirmation ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    color: Colors.black87,
                    child: Center(
                      child: ZoomIn(
                        child: Container(
                          margin: EdgeInsets.all(20 * s),
                          padding: EdgeInsets.all(30 * s),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.warning_amber_rounded,
                                  size: 80 * s, color: Colors.red.shade600),
                              SizedBox(height: 20 * s),
                              Text(
                                '¿Llamar al 911?',
                                style: TextStyle(
                                  fontSize: 24 * s,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 12 * s),
                              Text(
                                'Se realizará una llamada de emergencia',
                                style: TextStyle(
                                  fontSize: 16 * s,
                                  color: Colors.grey.shade600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 30 * s),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: _hideConfirmDialog,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.grey.shade300,
                                        foregroundColor: Colors.black87,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 16 * s),
                                      ),
                                      child: Text('Cancelar',
                                          style: TextStyle(fontSize: 16 * s)),
                                    ),
                                  ),
                                  SizedBox(width: 12 * s),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        _hideConfirmDialog();
                                        _callEmergency();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red.shade600,
                                        foregroundColor: Colors.white,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 16 * s),
                                      ),
                                      child: Text('Llamar',
                                          style: TextStyle(fontSize: 16 * s)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResourceCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    required int delay,
  }) {
    final s = scale(context);

    return FadeInUp(
      delay: Duration(milliseconds: delay),
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: EdgeInsets.all(16 * s),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: color.withOpacity(0.5), width: 2),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12 * s),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color, size: 28 * s),
                  ),
                  SizedBox(width: 16 * s),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 16 * s,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4 * s),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 13 * s,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios,
                      color: Colors.white70, size: 16 * s),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
