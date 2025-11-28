// lib/screens/privacy_policy_screen.dart

import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'dart:ui';
import '../theme/app_theme.dart';
import '../constants/privacy_content.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  int _selectedTab = 0;

  double scale(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width / 390;
  }

  @override
  Widget build(BuildContext context) {
    final s = scale(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.all(20 * s),
                child: Column(
                  children: [
                    Row(
                      children: [
                        FadeInLeft(
                          child: IconButton(
                            icon: Icon(Icons.arrow_back,
                                color: AppTheme.foreground, size: 28 * s),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        Expanded(
                          child: FadeInDown(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Privacidad y Seguridad',
                                    style:
                                        AppTheme.h2.copyWith(fontSize: 22 * s)),
                                Text('Tu información está protegida',
                                    style: AppTheme.caption
                                        .copyWith(fontSize: 13 * s)),
                              ],
                            ),
                          ),
                        ),
                        FadeInRight(
                          child: Icon(Icons.verified_user,
                              color: Colors.green.shade400, size: 32 * s),
                        ),
                      ],
                    ),
                    SizedBox(height: 20 * s),

                    // Tabs
                    FadeIn(
                      delay: const Duration(milliseconds: 200),
                      child: Row(
                        children: [
                          _buildTab('Privacidad', 0, Icons.shield_outlined, s),
                          SizedBox(width: 8 * s),
                          _buildTab(
                              'Términos', 1, Icons.description_outlined, s),
                          SizedBox(width: 8 * s),
                          _buildTab('Seguridad', 2, Icons.lock_outline, s),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Contenido
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20 * s),
                  child: FadeInUp(
                    delay: const Duration(milliseconds: 400),
                    child: _buildContent(s),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String label, int index, IconData icon, double s) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12 * s),
          decoration: BoxDecoration(
            gradient: isSelected ? AppTheme.cyanGradient : null,
            color: isSelected ? null : Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : Colors.white.withOpacity(0.4),
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Icon(icon,
                  size: 20 * s,
                  color: isSelected ? Colors.white : AppTheme.foreground),
              SizedBox(height: 4 * s),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12 * s,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : AppTheme.foreground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(double s) {
    switch (_selectedTab) {
      case 0:
        return _buildPrivacyContent(s);
      case 1:
        return _buildTermsContent(s);
      case 2:
        return _buildSecurityContent(s);
      default:
        return const SizedBox();
    }
  }

  Widget _buildPrivacyContent(double s) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHighlightCard(
          s,
          icon: Icons.shield_moon,
          title: '🔒 Tu privacidad es sagrada',
          description: PrivacyContent.mainMessage,
          color: Colors.green.shade400,
        ),
        SizedBox(height: 20 * s),
        _buildSectionTitle('¿Qué información recopilamos?', s),
        ...PrivacyContent.dataCollection.map((item) => _buildListItem(item, s)),
        SizedBox(height: 20 * s),
        _buildSectionTitle('¿Cómo protegemos tus conversaciones?', s),
        ...PrivacyContent.conversationProtection
            .map((item) => _buildListItem(item, s)),
        SizedBox(height: 20 * s),
        _buildSectionTitle('¿Quién tiene acceso a tus datos?', s),
        ...PrivacyContent.dataAccess.map((item) => _buildListItem(item, s)),
        SizedBox(height: 20 * s),
        _buildSectionTitle('Tus derechos', s),
        ...PrivacyContent.userRights.map((item) => _buildListItem(item, s)),
        SizedBox(height: 40 * s),
      ],
    );
  }

  Widget _buildTermsContent(double s) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Términos y Condiciones de Uso', s),
        SizedBox(height: 12 * s),
        ...PrivacyContent.termsConditions
            .map((item) => _buildListItem(item, s)),
        SizedBox(height: 40 * s),
      ],
    );
  }

  Widget _buildSecurityContent(double s) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHighlightCard(
          s,
          icon: Icons.security,
          title: '🛡️ Seguridad de Nivel Empresarial',
          description: PrivacyContent.securityMessage,
          color: Colors.blue.shade400,
        ),
        SizedBox(height: 20 * s),
        _buildSectionTitle('Medidas de Seguridad', s),
        ...PrivacyContent.securityMeasures
            .map((item) => _buildListItem(item, s)),
        SizedBox(height: 20 * s),
        _buildSectionTitle('En caso de emergencia', s),
        ...PrivacyContent.emergencyProtocol
            .map((item) => _buildListItem(item, s)),
        SizedBox(height: 40 * s),
      ],
    );
  }

  Widget _buildHighlightCard(double s,
      {required IconData icon,
      required String title,
      required String description,
      required Color color}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.all(20 * s),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.5), width: 2),
          ),
          child: Column(
            children: [
              Icon(icon, size: 48 * s, color: color),
              SizedBox(height: 12 * s),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18 * s,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.foreground,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8 * s),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14 * s,
                  color: AppTheme.foreground,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, double s) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12 * s),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18 * s,
          fontWeight: FontWeight.bold,
          color: AppTheme.foreground,
        ),
      ),
    );
  }

  Widget _buildListItem(String text, double s) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12 * s),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            padding: EdgeInsets.all(14 * s),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.4),
                width: 1.5,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 4 * s, right: 10 * s),
                  width: 6 * s,
                  height: 6 * s,
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 14 * s,
                      color: AppTheme.foreground,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
