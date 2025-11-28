import 'package:apoyo_emocional_ia_app/screens/mental_health_centers_screen.dart';
import 'package:apoyo_emocional_ia_app/screens/privacy_policy_screen.dart';
import 'package:apoyo_emocional_ia_app/screens/profile_screen.dart';
import 'package:apoyo_emocional_ia_app/screens/recovery_plan_screen.dart';
import 'package:apoyo_emocional_ia_app/screens/rewards_screen.dart';
import 'package:apoyo_emocional_ia_app/screens/social_chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:animate_do/animate_do.dart';
import 'dart:ui';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'auth_screen.dart'; // <--- IMPORTANTE: Importamos la pantalla de Login

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  // Escala adaptativa para el drawer
  double scale(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width / 390; // Base: iPhone 12
  }

  // Cierre del drawer y navegación
  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.of(context).pop();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = scale(context);

    return Drawer(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFB3D9FF), // Azul celeste intenso
              Color(0xFFFFB3E6), // Rosado intenso
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              FadeInDown(
                duration: const Duration(milliseconds: 600),
                child: Container(
                  height: 140 * s,
                  width: double.infinity,
                  margin: EdgeInsets.all(12 * s),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20 * s),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: EdgeInsets.all(14 * s),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20 * s),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Icono de app
                            Container(
                              padding: EdgeInsets.all(8 * s),
                              decoration: BoxDecoration(
                                gradient: AppTheme.cyanGradient,
                                borderRadius: BorderRadius.circular(10 * s),
                                boxShadow: AppTheme.glowShadow(
                                    const Color(0xFF00C6FF)),
                              ),
                              child: Icon(Icons.psychology,
                                  color: Colors.white, size: 24 * s),
                            ),
                            SizedBox(height: 8 * s),
                            Text(
                              'Gaibu',
                              style: AppTheme.h2.copyWith(
                                fontSize: 22 * s,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(height: 2 * s),
                            Text(
                              'Tu espacio de bienestar',
                              style:
                                  AppTheme.caption.copyWith(fontSize: 11 * s),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10 * s),

              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 16 * s),
                  children: [
                    // 1. Conexión anónima
                    FadeInLeft(
                      delay: const Duration(milliseconds: 100),
                      child: _buildDrawerItem(
                        context,
                        icon: Icons.edit_outlined,
                        title: 'Conexion anonima',
                        color: const Color(0xFF00C6FF),
                        onTap: () =>
                            _navigateTo(context, const SocialChatScreen()),
                      ),
                    ),
                    SizedBox(height: 10 * s),

                    // 2. Plan de Mejoría
                    FadeInLeft(
                      delay: const Duration(milliseconds: 200),
                      child: _buildDrawerItem(
                        context,
                        icon: Icons.spa_outlined,
                        title: 'Plan de Mejoria Personal',
                        color: Colors.purple.shade400,
                        onTap: () =>
                            _navigateTo(context, const RecoveryPlanScreen()),
                      ),
                    ),
                    SizedBox(height: 10 * s),

                    // 3. Perfil
                    FadeInLeft(
                      delay: const Duration(milliseconds: 300),
                      child: _buildDrawerItem(
                        context,
                        icon: Icons.account_circle_outlined,
                        title: 'Mi Perfil y Riesgo Personal',
                        color: const Color(0xFF4A90E2),
                        onTap: () =>
                            _navigateTo(context, const ProfileScreen()),
                      ),
                    ),
                    SizedBox(height: 10 * s),

                    // 4. Centros de ayuda
                    FadeInLeft(
                      delay: const Duration(milliseconds: 400),
                      child: _buildDrawerItem(
                        context,
                        icon: Icons.local_hospital,
                        title: 'Centros de ayuda',
                        color: const Color.fromARGB(255, 228, 90, 193),
                        onTap: () => _navigateTo(
                            context, const MentalHealthCentersScreen()),
                      ),
                    ),

                    SizedBox(height: 30 * s),

                    // 5. Privacidad
                    FadeInLeft(
                      delay: const Duration(milliseconds: 500),
                      child: _buildDrawerItem(
                        context,
                        icon: Icons.shield_outlined,
                        title: 'Privacidad y Seguridad',
                        color: const Color.fromARGB(255, 135, 203, 138),
                        onTap: () =>
                            _navigateTo(context, const PrivacyPolicyScreen()),
                      ),
                    ),
                    SizedBox(height: 30 * s),

                    // 6. Jardín de Logros
                    FadeInLeft(
                      delay: const Duration(milliseconds: 500),
                      child: _buildDrawerItem(
                        context,
                        icon: Icons.emoji_events,
                        title: 'Jardin de logros',
                        color: const Color.fromARGB(255, 5, 185, 14),
                        onTap: () =>
                            _navigateTo(context, const RewardsScreen()),
                      ),
                    ),
                    SizedBox(height: 30 * s),

                    //  Cerrar Sesión
                    FadeInLeft(
                      delay: const Duration(milliseconds: 500),
                      child: _buildDrawerItem(
                        context,
                        icon: Icons.logout_rounded,
                        title: 'Cerrar Sesión',
                        color: Colors.red.shade400,
                        onTap: () async {
                          Navigator.of(context)
                              .pop(); // Cierra el drawer primero

                          // Muestra el diálogo de confirmación
                          final shouldLogout = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Cerrar Sesión'),
                              content: const Text(
                                  '¿Estás seguro que deseas cerrar sesión?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(false),
                                  child: const Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(true),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.red,
                                  ),
                                  child: const Text('Cerrar Sesión'),
                                ),
                              ],
                            ),
                          );

                          // LOGICA DE CIERRE DE SESIÓN REAL
                          if (shouldLogout == true) {
                            await FirebaseAuth.instance.signOut();
                            // Verifica que el contexto siga montado antes de navegar
                            if (context.mounted) {
                              // Navega al Login y borra toda la pila anterior
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => const AuthScreen()),
                                (route) => false,
                              );
                            }
                          }
                        },
                        isDestructive: true,
                      ),
                    ),
                  ],
                ),
              ),

              // FOOTER con versión
              Padding(
                padding: EdgeInsets.all(16 * s),
                child: FadeInUp(
                  delay: const Duration(milliseconds: 600),
                  child: Text(
                    'Gaibu v1.0.0',
                    style: AppTheme.caption.copyWith(fontSize: 11 * s),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final s = scale(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(16 * s),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.25),
            borderRadius: BorderRadius.circular(16 * s),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16 * s,
              vertical: 6 * s,
            ),
            leading: Container(
              padding: EdgeInsets.all(8 * s),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10 * s),
              ),
              child: Icon(icon, color: color, size: 22 * s),
            ),
            title: Text(
              title,
              style: TextStyle(
                fontSize: 14 * s,
                fontWeight: FontWeight.w600,
                color:
                    isDestructive ? Colors.red.shade700 : AppTheme.foreground,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 14 * s,
              color: AppTheme.mutedForeground,
            ),
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}
