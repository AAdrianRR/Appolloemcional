import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_theme.dart';

class StressTheme {
  static const LinearGradient stressGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFE6F0F8), // Azul muy claro
      Color(0xFFD8F2E8), // Menta claro
      Color(0xFFD2E8FF), // Azul Bebé
      Color(0xFFF0E6F8), // Lavanda muy claro
    ],
  );

  static Widget scaffoldWithStressGradient({
    PreferredSizeWidget? appBar,
    required Widget body,
    Widget? floatingActionButton,
    FloatingActionButtonLocation? floatingActionButtonLocation,
    Widget? drawer,
    Widget? bottomNavigationBar,
  }) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: appBar,
      drawer: drawer,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: stressGradient),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.only(top: 60.0),
            child: body,
          ),
        ),
      ),
    );
  }

  static AppBar stressAppBar({required String title}) {
    return AppBar(
      title: Text(title, style: AppTheme.h3),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      foregroundColor: AppTheme.foreground,
      elevation: 0,
      automaticallyImplyLeading: true,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
  }
}
