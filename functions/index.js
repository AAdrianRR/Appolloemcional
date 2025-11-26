// functions/index.js

const functions = require("firebase-functions");
const admin = require("firebase-admin");

// Inicializa el SDK de Firebase Admin para acceder a Firestore
admin.initializeApp();
const db = admin.firestore();

// -------------------------------------------------------------
// 🧠 TAREA 6: ALGORITMO DE DETECCIÓN DE RIESGO (LÓGICA PROPIA)
// -------------------------------------------------------------

/**
 * Función que analiza el mensaje del diario para calcular una puntuación de riesgo.
 * Esta puntuación se basa en la presencia de palabras clave negativas y de aislamiento.
 * * Puntuación: 0 (Bajo) a 10 (Alto)
 * Semáforo: Verde (0-3), Amarillo (4-7), Rojo (8-10)
 */
const calcularRiesgo = (mensaje) => {
  if (!mensaje) return 0;

  // Convertir a minúsculas para un análisis sin distinción de mayúsculas/minúsculas
  const texto = mensaje.toLowerCase(); 
  let puntuacionRiesgo = 0;
  let patronesEncontrados = [];

  // 1. Detección de Soledad / Aislamiento
  const palabrasSoledad = ["solo", "sola", "nadie", "aislado", "aislada", "apartado"];
  const cuentaSoledad = palabrasSoledad.filter(p => texto.includes(p)).length;
  if (cuentaSoledad > 0) {
    puntuacionRiesgo += Math.min(cuentaSoledad * 2, 4); // Suma hasta 4 puntos
    patronesEncontrados.push("Soledad/Aislamiento");
  }

  // 2. Detección de Desesperanza / Tristeza Severa
  const palabrasDesesperanza = ["triste", "miedo", "nunca", "siempre", "fatal", "horrible", "llorar"];
  const cuentaDesesperanza = palabrasDesesperanza.filter(p => texto.includes(p)).length;
  if (cuentaDesesperanza > 0) {
    puntuacionRiesgo += Math.min(cuentaDesesperanza * 1.5, 3); // Suma hasta 3 puntos
    patronesEncontrados.push("Desesperanza/Tristeza");
  }

  // 3. Detección de Autocrítica / Baja Autoestima
  const palabrasAutoCritica = ["tonto", "estúpido", "inútil", "malo", "sirvo", "feo", "fea"];
  const cuentaAutoCritica = palabrasAutoCritica.filter(p => texto.includes(p)).length;
  if (cuentaAutoCritica > 0) {
    puntuacionRiesgo += Math.min(cuentaAutoCritica * 1.5, 3); // Suma hasta 3 puntos
    patronesEncontrados.push("Baja Autoestima");
  }
  
  // 4. Detección de ALERTA CRÍTICA (Ideación suicida o autolesión)
  // Nota: Esto es MUY sensible y requiere confirmación, pero el filtro es crucial.
  const alertaCritica = ["matarme", "cortarme", "morir", "desaparecer", "hacer daño"];
  if (alertaCritica.some(p => texto.includes(p))) {
    puntuacionRiesgo = 10; // Fija el riesgo en el máximo
    patronesEncontrados.push("ALERTA CRÍTICA INMEDIATA");
  }

  // Asegurar que la puntuación no exceda 10 y no sea negativa
  const riesgoFinal = Math.min(Math.round(puntuacionRiesgo), 10);
  
  return {
      score: riesgoFinal,
      semáforo: riesgoFinal >= 8 ? "Rojo" : (riesgoFinal >= 4 ? "Amarillo" : "Verde"),
      patrones: patronesEncontrados.join(", ")
  };
};

// -------------------------------------------------------------
// 🔄 FUNCIÓN DE CLOUD FUNCTIONS (TRIGGER)
// -------------------------------------------------------------

/**
 * Se activa automáticamente cuando se crea un nuevo documento
 * en la subcolección 'mensajes' de cualquier usuario.
 */
exports.analizarRiesgoDiario = functions.firestore
  .document("diarios/{userId}/mensajes/{mensajeId}")
  .onCreate(async (snapshot, context) => {
    // 1. Obtener los datos del mensaje recién creado
    const nuevoMensaje = snapshot.data();
    const mensajeTexto = nuevoMensaje.mensajeUsuario; // Solo analiza lo que escribió el adolescente
    const userId = context.params.userId;
    
    if (!mensajeTexto) {
      console.log("Mensaje vacío, saltando análisis.");
      return null;
    }

    // 2. Aplicar el Algoritmo de Detección de Riesgo
    const resultadoRiesgo = calcularRiesgo(mensajeTexto);
    
    console.log(`Análisis para ${userId}: Score ${resultadoRiesgo.score}, Patrones: ${resultadoRiesgo.patrones}`);

    // 3. Actualizar el documento del usuario en la base de datos
    // Esto es crucial para que Flutter (Panel de Padres) pueda leer el riesgo.
    try {
      await db.collection("usuarios_riesgo").doc(userId).set(
        {
          ultimoRiesgoScore: resultadoRiesgo.score,
          ultimoRiesgoFecha: admin.firestore.Timestamp.now(),
          semáforo: resultadoRiesgo.semáforo,
          patronesRecientes: resultadoRiesgo.patrones,
        },
        { merge: true } // Usar merge para no sobrescribir datos de usuario existentes
      );

      // Opcional: Actualizar el campo esRiesgo en el mensaje original (para fines de depuración)
      await snapshot.ref.update({
        esRiesgo: resultadoRiesgo.score > 3,
        riesgoScore: resultadoRiesgo.score,
      });

      return null;
    } catch (error) {
      console.error("Error al actualizar el riesgo del usuario:", error);
      return null;
    }
  });