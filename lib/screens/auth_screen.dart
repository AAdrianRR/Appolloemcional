import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/auth_form.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_scaffold.dart';
import 'package:animate_do/animate_do.dart';
import 'dart:ui';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  void _submitAuthForm(
    String email,
    String password,
    bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential userCredential;
    try {
      setState(() {
        _isLoading = true;
      });

      if (isLogin) {
        userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      }
    } on FirebaseAuthException catch (err) {
      var message = 'Ocurrió un error. Revisa tus credenciales.';
      if (err.message != null) {
        message = err.message!;
      }
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).colorScheme.error,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeInDown(
                duration: const Duration(milliseconds: 700),
                child: Icon(
                  Icons.psychology_alt,
                  size: 100,
                  color: AppTheme.primary, // Color primario del tema
                ),
              ),
              const SizedBox(height: 20),

              FadeInDown(
                duration: const Duration(milliseconds: 800),
                child: Text(
                  'Bienvenido a Gaibu',
                  style: AppTheme.h1.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Formulario (Animado)
              FadeInUp(
                duration: const Duration(milliseconds: 900),
                child: AuthForm(
                  _submitAuthForm,
                  _isLoading,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
