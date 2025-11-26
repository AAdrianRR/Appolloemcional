import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:animate_do/animate_do.dart';
import 'dart:ui';
import '../theme/app_theme.dart';
import 'main_dashboard_screen.dart';

class InitialSurveyScreen extends StatefulWidget {
  const InitialSurveyScreen({super.key});

  @override
  State<InitialSurveyScreen> createState() => _InitialSurveyScreenState();
}

class _InitialSurveyScreenState extends State<InitialSurveyScreen> {
  final PageController _pageController = PageController();
  final _formKey = GlobalKey<FormState>();
  var _currentPage = 0;
  var _isLoading = false;

  double scale(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width / 390;
  }

  final List<String> _moodOptions = [
    'Feliz',
    'Neutro',
    'Triste',
    'Ansioso',
    'Enojado'
  ];
  final List<String> _socialOptions = ['Alto', 'Medio', 'Bajo'];

  // Respuestas
  Map<String, dynamic> _surveyAnswers = {
    'moodToday': 'Neutro',
    'sleepHours': 7,
    'socialActivity': 'Alto',
  };

  Map<String, dynamic> _initialAnalysis = {};

  void _performInitialAnalysis() {
    // Inicializar probabilidades
    double ansiedadProb = 0.0;
    double depresionProb = 0.0;
    double estresProb = 0.0;
    double autoestimaProb = 100.0; // Empieza alta, se reduce si hay problemas

    List<String> insights = [];
    int score = 0;

    final mood = _surveyAnswers['moodToday'];
    if (mood == 'Ansioso') {
      ansiedadProb += 60.0;
      estresProb += 40.0;
      score += 5;
      insights.add("Alto nivel de ansiedad reportado");
    } else if (mood == 'Triste') {
      depresionProb += 60.0;
      autoestimaProb -= 40.0;
      score += 5;
      insights.add("Estado de ánimo bajo detectado");
    } else if (mood == 'Enojado') {
      estresProb += 50.0;
      ansiedadProb += 30.0;
      score += 4;
      insights.add("Irritabilidad presente");
    } else if (mood == 'Neutro') {
      ansiedadProb += 20.0;
      depresionProb += 20.0;
      score += 2;
    }

    // ANÁLISIS DE SUEÑO
    final sleepHours = _surveyAnswers['sleepHours'] as int;
    if (sleepHours < 5) {
      ansiedadProb += 40.0;
      estresProb += 40.0;
      depresionProb += 30.0;
      score += 4;
      insights.add("Privación severa de sueño");
    } else if (sleepHours < 7) {
      ansiedadProb += 25.0;
      estresProb += 25.0;
      score += 3;
      insights.add("Sueño insuficiente");
    } else if (sleepHours > 10) {
      depresionProb += 30.0;
      score += 2;
      insights.add("Exceso de sueño puede indicar bajo ánimo");
    }

    //  ANÁLISIS SOCIAL
    final social = _surveyAnswers['socialActivity'];
    if (social == 'Bajo') {
      depresionProb += 40.0;
      autoestimaProb -= 30.0;
      ansiedadProb += 20.0;
      score += 4;
      insights.add("Aislamiento social detectado");
    } else if (social == 'Medio') {
      depresionProb += 15.0;
      autoestimaProb -= 10.0;
      score += 1;
    }

    //  Normalizar probabilidades (máximo 100%)
    ansiedadProb = ansiedadProb.clamp(0, 100);
    depresionProb = depresionProb.clamp(0, 100);
    estresProb = estresProb.clamp(0, 100);
    autoestimaProb = autoestimaProb.clamp(0, 100);

    //  SEMÁFORO
    final semaforo = score >= 8 ? 'ROJO' : (score >= 5 ? 'AMARILLO' : 'VERDE');

    _initialAnalysis = {
      'initialScore': score,
      'initialSemaforo': semaforo,
      'initialInsights': insights.join(', '),
      'probabilidades': {
        'ansiedad': ansiedadProb.round(),
        'depresion': depresionProb.round(),
        'estres': estresProb.round(),
        'autoestima': autoestimaProb.round(),
      },
    };
  }

  // Guardar en Firestore
  Future<void> _submitSurvey() async {
    _performInitialAnalysis();

    setState(() => _isLoading = true);
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('user_data')
          .doc(user.uid)
          .set(
        {
          'firstSurveyCompleted': true,
          'surveyAnswers': _surveyAnswers,
          'surveyDate': Timestamp.now(),
          'probabilidadesIniciales': _initialAnalysis['probabilidades'],
        },
        SetOptions(merge: true),
      );

      await FirebaseFirestore.instance
          .collection('resumen_riesgo')
          .doc(user.uid)
          .set(
        {
          'ultimoRiesgoScore': _initialAnalysis['initialScore'],
          'ultimoSemaforo': _initialAnalysis['initialSemaforo'],
          'patronesRecientes': _initialAnalysis['initialInsights'],
          'probabilidades': _initialAnalysis['probabilidades'],
          'fechaActualizacion': Timestamp.now(),
          'usuarioID': user.uid,
        },
        SetOptions(merge: true),
      );

      if (mounted) {
        // 🎉 Mostrar resultados antes de ir al dashboard
        await _showResultsDialog();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
        setState(() => _isLoading = false);
      }
    }
  }

  //DIÁLOGO DE RESULTADOS
  Future<void> _showResultsDialog() async {
    final s = scale(context);
    final probs = _initialAnalysis['probabilidades'] as Map<String, dynamic>;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        content: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            gradient: AppTheme.backgroundGradient,
            borderRadius: BorderRadius.circular(24),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: EdgeInsets.all(24 * s),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                      color: Colors.white.withOpacity(0.3), width: 2),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.analytics_outlined,
                        size: 64 * s, color: AppTheme.foreground),
                    SizedBox(height: 16 * s),
                    Text('Análisis Completado',
                        style: AppTheme.h2.copyWith(fontSize: 24 * s)),
                    SizedBox(height: 8 * s),
                    Text('Basado en tus respuestas:', style: AppTheme.caption),
                    SizedBox(height: 20 * s),
                    _buildProbBar(
                        'Ansiedad', probs['ansiedad'], Colors.orange, s),
                    SizedBox(height: 12 * s),
                    _buildProbBar(
                        'Depresión', probs['depresion'], Colors.blue, s),
                    SizedBox(height: 12 * s),
                    _buildProbBar('Estrés', probs['estres'], Colors.red, s),
                    SizedBox(height: 12 * s),
                    _buildProbBar(
                        'Autoestima', probs['autoestima'], Colors.green, s,
                        isInverted: true),
                    SizedBox(height: 24 * s),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (c) => const MainDashboardScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        padding: EdgeInsets.symmetric(
                            horizontal: 32 * s, vertical: 16 * s),
                      ),
                      child:
                          Text('Comenzar', style: TextStyle(fontSize: 16 * s)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProbBar(String label, int value, Color color, double s,
      {bool isInverted = false}) {
    final displayValue = isInverted ? value : value;
    final barColor = isInverted
        ? (value > 70
            ? Colors.green
            : value > 40
                ? Colors.orange
                : Colors.red)
        : (value > 70
            ? Colors.red
            : value > 40
                ? Colors.orange
                : Colors.green);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style:
                    TextStyle(fontSize: 14 * s, fontWeight: FontWeight.w600)),
            Text('$displayValue%',
                style:
                    TextStyle(fontSize: 14 * s, fontWeight: FontWeight.bold)),
          ],
        ),
        SizedBox(height: 6 * s),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: displayValue / 100,
            minHeight: 12 * s,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: AlwaysStoppedAnimation<Color>(barColor),
          ),
        ),
      ],
    );
  }

  Widget _buildMoodQuestion(BuildContext context) {
    final s = scale(context);
    return _buildQuestionContainer(
      context,
      '1/3',
      '¿Cómo te sientes emocionalmente hoy?',
      DropdownButtonFormField<String>(
        value: _surveyAnswers['moodToday'] as String?,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white.withOpacity(0.7),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
        items: _moodOptions
            .map((mood) => DropdownMenuItem(value: mood, child: Text(mood)))
            .toList(),
        onChanged: (value) =>
            setState(() => _surveyAnswers['moodToday'] = value!),
        onSaved: (value) => _surveyAnswers['moodToday'] = value!,
        validator: (value) => value == null ? 'Selecciona una opción' : null,
      ),
    );
  }

  Widget _buildSleepQuestion(BuildContext context) {
    final s = scale(context);
    return _buildQuestionContainer(
      context,
      '2/3',
      '¿Cuántas horas dormiste anoche?',
      Column(
        children: [
          Container(
            padding: EdgeInsets.all(32 * s),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
              border:
                  Border.all(color: Colors.white.withOpacity(0.4), width: 2),
            ),
            child: Text(
              '${_surveyAnswers['sleepHours']} horas',
              style: TextStyle(
                  fontSize: 48 * s,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.foreground),
            ),
          ),
          SizedBox(height: 24 * s),
          Slider(
            value: (_surveyAnswers['sleepHours'] as int).toDouble(),
            min: 3,
            max: 12,
            divisions: 9,
            activeColor: AppTheme.primary,
            inactiveColor: Colors.white.withOpacity(0.3),
            onChanged: (value) =>
                setState(() => _surveyAnswers['sleepHours'] = value.round()),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialQuestion(BuildContext context) {
    final s = scale(context);
    return _buildQuestionContainer(
      context,
      '3/3',
      'En la última semana, ¿cuánta actividad social tuviste?',
      DropdownButtonFormField<String>(
        value: _surveyAnswers['socialActivity'] as String?,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white.withOpacity(0.7),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
        items: _socialOptions
            .map((option) =>
                DropdownMenuItem(value: option, child: Text(option)))
            .toList(),
        onChanged: (value) =>
            setState(() => _surveyAnswers['socialActivity'] = value!),
        onSaved: (value) => _surveyAnswers['socialActivity'] = value!,
        validator: (value) => value == null ? 'Selecciona una opción' : null,
      ),
    );
  }

  Widget _buildQuestionContainer(BuildContext context, String progress,
      String question, Widget inputWidget) {
    final s = scale(context);
    return Padding(
      padding: EdgeInsets.all(20 * s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeInDown(
            child: Container(
              padding:
                  EdgeInsets.symmetric(horizontal: 16 * s, vertical: 8 * s),
              decoration: BoxDecoration(
                gradient: AppTheme.cyanGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(progress,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14 * s)),
            ),
          ),
          SizedBox(height: 20 * s),
          FadeIn(
            delay: const Duration(milliseconds: 200),
            child:
                Text(question, style: AppTheme.h2.copyWith(fontSize: 22 * s)),
          ),
          SizedBox(height: 40 * s),
          SlideInUp(
            delay: const Duration(milliseconds: 400),
            child: inputWidget,
          ),
        ],
      ),
    );
  }

  void _nextPage() {
    _formKey.currentState!.save();
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      if (_currentPage < 2) {
        _pageController.nextPage(
            duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
      } else {
        _submitSurvey();
      }
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
          duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = scale(context);
    final pages = [
      _buildMoodQuestion(context),
      _buildSleepQuestion(context),
      _buildSocialQuestion(context),
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Header
                Padding(
                  padding: EdgeInsets.all(20 * s),
                  child: FadeInDown(
                    child: Text('Cuestionario de Bienvenida',
                        style: AppTheme.h1.copyWith(fontSize: 28 * s)),
                  ),
                ),

                // Indicador de progreso
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40 * s),
                  child: Row(
                    children: List.generate(
                        3,
                        (i) => Expanded(
                              child: Container(
                                height: 4,
                                margin: EdgeInsets.symmetric(horizontal: 4 * s),
                                decoration: BoxDecoration(
                                  color: i <= _currentPage
                                      ? AppTheme.primary
                                      : Colors.white.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            )),
                  ),
                ),

                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (i) => setState(() => _currentPage = i),
                    physics: const NeverScrollableScrollPhysics(),
                    children: pages,
                  ),
                ),

                // Botones
                Container(
                  padding: EdgeInsets.all(20 * s),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentPage > 0)
                        FadeInLeft(
                          child: ElevatedButton.icon(
                            onPressed: _prevPage,
                            icon: Icon(Icons.arrow_back, size: 20 * s),
                            label: Text('Volver',
                                style: TextStyle(fontSize: 14 * s)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.3),
                              foregroundColor: AppTheme.foreground,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20 * s, vertical: 12 * s),
                            ),
                          ),
                        )
                      else
                        const SizedBox(),
                      _isLoading
                          ? const CircularProgressIndicator()
                          : FadeInRight(
                              child: ElevatedButton.icon(
                                onPressed: _nextPage,
                                icon: Icon(
                                    _currentPage < 2
                                        ? Icons.arrow_forward
                                        : Icons.check,
                                    size: 20 * s),
                                label: Text(
                                  _currentPage < 2 ? 'Siguiente' : 'Finalizar',
                                  style: TextStyle(fontSize: 14 * s),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primary,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 24 * s, vertical: 12 * s),
                                ),
                              ),
                            ),
                    ],
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
