import 'package:flutter/material.dart';
import 'dart:async';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/gradient_scaffold.dart';
import '../theme/app_theme.dart';

import 'auth_screen.dart';
import 'main_dashboard_screen.dart';
import 'therapist_home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (ctx) => const AuthScreen()),
      );
    } else {
      try {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          final String role = userDoc.data()?['role'] ?? 'paciente';

          if (!mounted) return;

          if (role == 'terapeuta') {
            // ---> ES TERAPEUTA
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (ctx) => const TherapistHomeScreen()),
            );
          } else {
            // ---> ES PACIENTE
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (ctx) => const MainDashboardScreen()),
            );
          }
        } else {
          if (!mounted) return;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (ctx) => const MainDashboardScreen()),
          );
        }
      } catch (e) {
        print("Error en Splash: $e");
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) => const AuthScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/splash.json',
              width: 250,
              height: 250,
              repeat: true,
              animate: true,
            ),
            const SizedBox(height: 30),
            Text(
              'Preparando tu espacio...',
              style: AppTheme.h3.copyWith(
                  color: AppTheme.primary, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
