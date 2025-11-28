import 'package:apoyo_emocional_ia_app/screens/avatar_test_screen.dart';
import 'package:apoyo_emocional_ia_app/screens/meditation_screen.dart'
    as meditation;
import 'package:apoyo_emocional_ia_app/screens/self_esteem_module_screen.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../theme/app_theme.dart';
import 'app_drawer.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'therapist_screen.dart';
import 'mindfulness_screen.dart';
import 'anxiety_module_screen.dart';
import 'depression_module_screen.dart';
import 'crisis_screen.dart';

class MainDashboardScreen extends StatelessWidget {
  const MainDashboardScreen({super.key});

  // Escala universal basada en ancho de pantalla
  double scale(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width / 390; // 390 = iPhone 12 base
  }

  // --- WIDGET CORREGIDO: CALENDARIO DE RACHAS ADAPTATIVO ---
  Widget _buildDailyStreakCard(BuildContext context) {
    final s = scale(context);

    final days = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];
    final activeDays = [true, true, false, true, false, true, false];
    const activeColor = Color(0xFF0072FF);
    const inactiveColor = Color(0xFFE0E0E5);

    return AppTheme.glassCard(
      onTap: () {},
      padding: EdgeInsets.all(16 * s),
      opacity: 0.25,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Tu Diario Semanal',
              style: AppTheme.h3.copyWith(fontSize: 18 * s)),
          SizedBox(height: 4 * s),
          Text('Mantén tu racha activa',
              style: AppTheme.caption.copyWith(fontSize: 13 * s)),
          SizedBox(height: 20 * s),

          // Fila principal: Calendario + Insignia de Fuego
          Row(
            children: [
              // 1. CALENDARIO (Usa Expanded para ocupar el espacio sobrante)
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(7, (index) {
                    final isActive = activeDays[index];

                    // --- AQUÍ ESTÁ EL CAMBIO CLAVE ---
                    // Usamos Expanded en cada hijo para dividir el ancho en 7 partes iguales
                    return Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Círculo del día
                          Container(
                            width: 32 *
                                s, // Tamaño ajustado para pantallas pequeñas
                            height: 32 * s,
                            decoration: BoxDecoration(
                              gradient: isActive ? AppTheme.cyanGradient : null,
                              color: isActive ? null : inactiveColor,
                              borderRadius:
                                  BorderRadius.circular(AppTheme.radiusLg * s),
                            ),
                            child: Center(
                              child: Text(
                                days[index],
                                style: TextStyle(
                                  color: isActive
                                      ? Colors.white
                                      : AppTheme.mutedForeground,
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      12 * s, // Fuente un poco más pequeña
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 6 * s),
                          // Puntito indicador
                          Container(
                            width: 4 * s,
                            height: 4 * s,
                            decoration: BoxDecoration(
                              color: isActive ? activeColor : inactiveColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),

              SizedBox(width: 8 * s), // Espacio entre calendario y fuego

              // 2. INSIGNIA DE FUEGO (Tamaño fijo a la derecha)
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 10 * s, vertical: 6 * s),
                decoration: BoxDecoration(
                  color: Colors.orange.shade600,
                  borderRadius: BorderRadius.circular(12 * s),
                  boxShadow: AppTheme.glowShadow(Colors.orange.shade400),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.local_fire_department,
                        size: 16 * s, color: Colors.white),
                    SizedBox(width: 4 * s),
                    Text('3 días',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11 * s)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResourceCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    final s = scale(context);

    return AppTheme.glassCard(
      onTap: onTap,
      padding: EdgeInsets.all(12 * s),
      opacity: 0.2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTheme.iconContainer(
                icon: icon,
                color: iconColor,
                size: 24 * s,
                padding: 8 * s,
              ),
              Padding(
                padding: EdgeInsets.only(top: 8 * s),
                child: Icon(Icons.arrow_forward_ios,
                    size: 14 * s, color: AppTheme.mutedForeground),
              ),
            ],
          ),
          SizedBox(height: 10 * s),
          Text(
            title,
            style: TextStyle(
                fontSize: 15 * s,
                fontWeight: FontWeight.bold,
                color: AppTheme.foreground),
          ),
          Expanded(
            child: Text(
              subtitle,
              style:
                  TextStyle(fontSize: 12 * s, color: AppTheme.mutedForeground),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonitoreoTerapeutaCard(
      {required BuildContext context, required VoidCallback onTap}) {
    final s = scale(context);

    return AppTheme.glassCard(
      onTap: onTap,
      padding: EdgeInsets.all(20 * s),
      opacity: 0.25,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12 * s),
            decoration: BoxDecoration(
              color: Colors.purple.shade100,
              borderRadius: BorderRadius.circular(15 * s),
            ),
            child: Icon(Icons.people_alt_outlined,
                size: 30 * s, color: Colors.purple.shade600),
          ),
          SizedBox(width: 15 * s),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Monitoreo del Terapeuta',
                    style: AppTheme.h3.copyWith(fontSize: 18 * s)),
                SizedBox(height: 4 * s),
                Text('Dr. María González - Psicología Clínica',
                    style: AppTheme.caption.copyWith(
                        fontWeight: FontWeight.w600, fontSize: 13 * s)),
                SizedBox(height: 4 * s),
                Text(
                  'Acceso para supervisar el progreso de tus clientes.',
                  style: AppTheme.caption.copyWith(fontSize: 12 * s),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios,
              size: 16 * s, color: AppTheme.mutedForeground),
        ],
      ),
    );
  }

  Widget _buildCrisisButton(BuildContext context, double s) {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (ctx) => const CrisisScreen()),
        );
      },
      heroTag: 'crisis_fab',
      backgroundColor: Colors.redAccent,
      elevation: 6,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.white, size: 20 * s),
          SizedBox(width: 8 * s),
          Text('Crisis',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14 * s)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = scale(context);
    const accentColor = Color(0xFF4A90E2);

    return Scaffold(
      backgroundColor: Colors.transparent,
      drawer: const AppDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFB3D9FF), Color(0xFFFFB3E6)],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              floating: true,
              pinned: true,
              automaticallyImplyLeading: true,
              title: FadeInDown(
                child: Text('Tu diario semanal',
                    style: AppTheme.h3.copyWith(fontSize: 22 * s)),
              ),
              centerTitle: false,
              iconTheme: IconThemeData(
                color: AppTheme.foreground,
                size: 28 * s,
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16 * s),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SlideInUp(
                        duration: const Duration(milliseconds: 700),
                        child: _buildDailyStreakCard(context),
                      ),
                      SizedBox(height: 30 * s),
                      FadeIn(
                        duration: const Duration(milliseconds: 900),
                        child: Row(
                          children: [
                            Text('Explora tus recursos',
                                style: AppTheme.h2.copyWith(fontSize: 22 * s)),
                            SizedBox(width: 8 * s),
                            Icon(Icons.sunny,
                                size: 20 * s, color: Colors.orange),
                          ],
                        ),
                      ),
                      SizedBox(height: 20 * s),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final crossAxis = constraints.maxWidth < 360 ? 2 : 3;

                          return SlideInUp(
                            duration: const Duration(milliseconds: 800),
                            child: GridView.count(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: crossAxis,
                              crossAxisSpacing: 10 * s,
                              mainAxisSpacing: 10 * s,
                              childAspectRatio: 0.75,
                              children: [
                                _buildResourceCard(context,
                                    title: 'Controla el estrés',
                                    subtitle:
                                        'Técnicas y ejercicios para manejar el estrés diario',
                                    icon: Icons.favorite_border,
                                    iconColor: Colors.pink.shade400,
                                    onTap: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (ctx) =>
                                                const MindfulnessScreen()))),
                                _buildResourceCard(context,
                                    title: 'Controla la ansiedad',
                                    subtitle:
                                        'Herramientas para reducir la ansiedad',
                                    icon: Icons.shield_outlined,
                                    iconColor: const Color(0xFF0072FF),
                                    onTap: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (ctx) =>
                                                const AnxietyModuleScreen()))),
                                _buildResourceCard(context,
                                    title: 'Controla la depresión',
                                    subtitle:
                                        'Apoyo y recursos para el bienestar emocional',
                                    icon: Icons.wb_sunny_outlined,
                                    iconColor: const Color(0xFF32C7FF),
                                    onTap: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (ctx) =>
                                                const DepressionModuleScreen()))),
                                _buildResourceCard(context,
                                    title: 'Cultiva tu autoestima',
                                    subtitle:
                                        'Fortalece tu confianza y amor propio',
                                    icon: Icons.star_border,
                                    iconColor: Colors.amber.shade600,
                                    onTap: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (ctx) =>
                                                const SelfEsteemModuleScreen()))),
                                _buildResourceCard(context,
                                    title: 'Progreso',
                                    subtitle: 'Visualiza tu evolución y logros',
                                    icon: Icons.bar_chart_outlined,
                                    iconColor: accentColor,
                                    onTap: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (ctx) =>
                                                const ProfileScreen()))),
                                _buildResourceCard(context,
                                    title: 'Meditacion Guiada',
                                    subtitle:
                                        'Prácticas profundas para la calma interior',
                                    icon: Icons.spa,
                                    iconColor: Colors.purple.shade400,
                                    onTap: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (ctx) => const meditation
                                                .MeditationScreen()))),
                                _buildResourceCard(
                                  context,
                                  title: 'Avatar Interactivo',
                                  subtitle: 'Habla con un personaje animado',
                                  icon: Icons.person_3_rounded,
                                  iconColor: Colors.orange,
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (ctx) =>
                                          const AvatarTestScreen(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 30 * s),
                      FadeInUp(
                        duration: const Duration(milliseconds: 900),
                        child: _buildMonitoreoTerapeutaCard(
                          context: context,
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (ctx) => const TherapistScreen())),
                        ),
                      ),
                      SizedBox(height: 100 * s),
                    ],
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            left: 30 * s,
            bottom: 0,
            child: FadeInLeft(
              duration: const Duration(milliseconds: 1000),
              child: _buildCrisisButton(context, s),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: FadeInRight(
              duration: const Duration(milliseconds: 1000),
              child: FloatingActionButton.extended(
                onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => const HomeScreen())),
                heroTag: 'diary_fab',
                label: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10 * s, vertical: 8 * s),
                  decoration: BoxDecoration(
                    gradient: AppTheme.fabGradient,
                    borderRadius: BorderRadius.circular(30 * s),
                    boxShadow: AppTheme.glowShadow(const Color(0xFF00C6FF)),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Icon(Icons.edit_outlined,
                          color: AppTheme.foreground, size: 22 * s),
                      SizedBox(width: 8 * s),
                      Text('IA Diario',
                          style: TextStyle(
                              color: AppTheme.foreground,
                              fontWeight: FontWeight.bold,
                              fontSize: 14 * s)),
                    ],
                  ),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                extendedPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
