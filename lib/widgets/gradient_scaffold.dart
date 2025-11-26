// lib/widgets/gradient_scaffold.dart

import 'package:flutter/material.dart';
import 'dart:ui'; // Necesario si queremos usar BackdropFilter (efecto glass)

// Definición de las constantes de diseño (puedes copiarlas desde AppTheme si quieres)
// Para simplicidad, las definiremos aquí temporalmente
const LinearGradient backgroundGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xFFF0F5FD), // Azul muy claro casi blanco
    Color(0xFFF9F0F5), // Rosado muy claro casi blanco
  ],
);

///  Widget base que aplica el fondo degradado a cualquier pantalla.
class GradientScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? drawer;
  final Widget? bottomNavigationBar;

  const GradientScaffold({
    super.key,
    this.appBar,
    this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.drawer,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  CRUCIAL: El Scaffold debe ser transparente
      backgroundColor: Colors.transparent,
      appBar: appBar,
      drawer: drawer,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,

      //  El cuerpo del Scaffold usa el Container con el degradado
      body: Container(
        decoration: const BoxDecoration(gradient: backgroundGradient),
        child: body,
      ),
    );
  }
}
