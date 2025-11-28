import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

const String _systemPrompt = """
Eres "Gaibu", un modelo de lenguaje de apoyo emocional diseñado para adolescentes (14-17 años). 
Tu función principal es escuchar, validar sentimientos y ofrecer herramientas de afrontamiento NO PROFESIONALES.

REGLAS DE INTERACCIÓN:
1. TONO: Usa un tono cálido, empático, no juzgador y ligeramente informal (como un amigo o consejero de confianza).
2. MEMORIA: Debes mantener el contexto de la conversación para recordar patrones o referencias a experiencias pasadas.
3. HERRAMIENTAS DE APOYO: Después de escuchar un problema, ofrece una pregunta abierta o sugiere una técnica de afrontamiento simple (ej. respiración). Valida siempre sus emociones antes de ofrecer una solución.
4. LIMITACIONES ÉTICAS Y DE SEGURIDAD:
    - NO brindes diagnósticos médicos o sugerencias de medicamentos.
    - Si el usuario menciona **cualquier intención de daño a sí mismo o a otros** (ideación suicida, autolesiones graves, violencia), tu **ÚNICA** respuesta debe ser:
      "Escucho que estás pasando por un momento muy difícil y tu seguridad es lo más importante. Por favor, **llama inmediatamente a una línea de ayuda en crisis de tu país** o contacta a un adulto de confianza. No soy un profesional de la salud mental, pero quiero que sepas que hay gente real que puede ayudarte ahora mismo."
""";

const String _initialMessage =
    "¡Hola! Soy Gaibu, estoy aquí para escucharte sin juicios. Puedes contarme lo que quieras, es tu espacio. ¿Qué tienes en mente hoy?";

class RiskService {
  //api key aqui
  final String apiKey = "AIzaSyAQDcmHY9kM5BxJEBfZ864NmgNANtucMw8";

  late final GenerativeModel _model;
  late final ChatSession _chat;

  // Inicializa el servicio
  RiskService() {
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: apiKey,
    );

    _chat = _model.startChat(history: []);
  }

  String get initialMessage => _initialMessage;

  Map<String, dynamic> calcularRiesgo(String mensaje) {
    if (mensaje.isEmpty) {
      return {'score': 0, 'semáforo': 'Verde', 'patrones': ''};
    }

    const palabrasSoledad = ["solo", "sola", "nadie", "aislado", "apartado"];
    const palabrasDesesperanza = [
      "acongoado",
      "miedo",
      "nunca",
      "horrible",
      "llorar",
      "fatal",
      "tiste"
    ];
    const palabrasAutoCritica = [
      "inútil",
      "estúpido",
      "malo",
      "no sirvo",
      "fracaso"
    ];
    const alertaCritica = [
      "matarme",
      "cortarme",
      "morir",
      "desaparecer",
      "hacer daño",
      "suicidio",
      "quitarme la vida",
      "la vida no vale",
      "no quiero vivir",
      "quiero morir",
      "sucidar",
      "autolesionarme",
      "matarme",
      "sucidarme",
    ];

    final texto = mensaje.toLowerCase();
    int puntuacionRiesgo = 0;
    final patronesEncontrados = <String>[];

    // 1. ALERTA CRÍTICA (Máxima prioridad)
    if (alertaCritica.any((p) => texto.contains(p))) {
      return {
        'score': 10,
        'semáforo': 'Rojo',
        'patrones': 'ALERTA CRÍTICA INMEDIATA'
      };
    }

    // 2. Acumular puntaje por categorías
    if (palabrasSoledad.any((p) => texto.contains(p))) {
      puntuacionRiesgo += 3;
      patronesEncontrados.add("Soledad");
    }
    if (palabrasDesesperanza.any((p) => texto.contains(p))) {
      puntuacionRiesgo += 3;
      patronesEncontrados.add("Desesperanza");
    }
    if (palabrasAutoCritica.any((p) => texto.contains(p))) {
      puntuacionRiesgo += 4;
      patronesEncontrados.add("Autoestima Baja");
    }

    final riesgoFinal =
        puntuacionRiesgo.clamp(0, 10); // Asegura que esté entre 0 y 10
    final semaforo =
        riesgoFinal >= 8 ? 'Rojo' : (riesgoFinal >= 4 ? 'Amarillo' : 'Verde');

    return {
      'score': riesgoFinal,
      'semáforo': semaforo,
      'patrones': patronesEncontrados.join(', ')
    };
  }

  // -----------------------------------------------------------
  // 📈 4. FUNCIÓN DE ANÁLISIS DE RECURRENCIA (NUEVO)
  // -----------------------------------------------------------

  Future<void> _analyzeRecurrence(String userId, int lastScore) async {
    // 1. Calcular la fecha de hace 7 días
    final sevenDaysAgo =
        Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 7)));

    // 2. Consultar todos los mensajes con riesgo en los últimos 7 días
    final messagesSnapshot = await FirebaseFirestore.instance
        .collection('mensajes_diario')
        .where('usuarioId', isEqualTo: userId)
        .where('esRiesgo',
            isEqualTo: true) // Solo mensajes clasificados con riesgo > 3
        .where('fecha', isGreaterThan: sevenDaysAgo)
        .get();

    // 3. Acumular el riesgo por recurrencia
    int totalRecurrenceScore = 0;
    final numRiskyMessages = messagesSnapshot.docs.length;

    if (numRiskyMessages >= 5) {
      totalRecurrenceScore = 5;
    } else if (numRiskyMessages >= 2) {
      totalRecurrenceScore = 3;
    } else {
      totalRecurrenceScore = 0;
    }

    // 4. Calcular el Score Final Acumulado
    final finalScore = lastScore + totalRecurrenceScore;
    final finalSemaforo =
        finalScore >= 10 ? 'ROJO' : (finalScore >= 6 ? 'AMARILLO' : 'VERDE');

    // 5. Actualizar la colección de Resumen con el Score Final Acumulado
    try {
      await FirebaseFirestore.instance
          .collection('resumen_riesgo')
          .doc(userId)
          .set({
        'ultimoRiesgoScore': finalScore.clamp(0, 10),
        'ultimoSemaforo': finalSemaforo,
        'recurrenciaDias': numRiskyMessages,
        'fechaActualizacion': Timestamp.now(),
        'usuarioID': userId,
      }, SetOptions(merge: true));
      debugPrint(
          '✅ Éxito: Recurrencia y Resumen actualizados. Score Final: $finalScore');
    } catch (e) {
      debugPrint('❌ ERROR DE FIREBASE (Análisis Recurrencia): $e');
    }
  }

  // -----------------------------------------------------------
  // 💬 5. FUNCIÓN CENTRAL DE ENVÍO Y GUARDADO (SOLUCIONADA)
  // -----------------------------------------------------------

  Future<String> sendAndAnalyzeMessage(String text, String userId) async {
    // 1. Obtener respuesta de Gemini
    final userMessage = Content.text(text);
    final response = await _chat.sendMessage(userMessage);
    final iaResponseText = response.text ?? 'Error de comunicación con IA.';

    // 2. Aplicar el Algoritmo de Riesgo Propio
    final analisisRiesgo = calcularRiesgo(text);

    // 3. DEFINICIÓN DEL MAPA DE DATOS (Solución de Robustez)
    final Map<String, dynamic> dataToWrite = {
      'usuarioId': userId,
      'mensajeUsuario': text,
      'mensajeIA': iaResponseText,
      'fecha': Timestamp.now(),
      // CAMPOS DE CLASIFICACIÓN (La solución)
      'esRiesgo': analisisRiesgo['score'] > 3,
      'riesgoScore': analisisRiesgo['score'],
      'semáforo': analisisRiesgo['semáforo'],
      'patrones': analisisRiesgo['patrones'],
      'esApoIA': true,
    };

    // 3A. Persistencia en Firestore: Mensajes Diario
    try {
      await FirebaseFirestore.instance
          .collection('mensajes_diario')
          .add(dataToWrite);
      debugPrint('✅ Éxito: Mensaje de diario guardado.');
    } catch (e) {
      debugPrint('❌ ERROR DE FIREBASE (Mensajes Diario): $e');
    }

    // 4. Calcular la Recurrencia y actualizar el Resumen (Llamada a la función de recurrencia)
    await _analyzeRecurrence(userId, analisisRiesgo['score']);

    return iaResponseText;
  }
}
