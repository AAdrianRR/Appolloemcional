class PrivacyContent {
  static const String mainMessage =
      'Nadie puede leer tus conversaciones con la IA. Ni terapeutas, ni administradores, '
      'ni nosotros. Tus mensajes son completamente privados y confidenciales. '
      'Solo se analizan patrones de palabras para mejorar tu experiencia, '
      'pero tu identidad y contenido específico permanecen protegidos.';

  static const List<String> dataCollection = [
    'Información de cuenta: Email y nombre (solo para autenticación)',
    'Datos del cuestionario inicial: Respuestas anónimas para personalizar tu experiencia',
    'Patrones de uso: Frecuencia de uso y módulos visitados (sin contenido específico)',
    'Análisis de sentimiento: Patrones de palabras para detectar emociones (sin almacenar mensajes completos)',
    'Datos de emergencia: Solo si activas el botón SOS, se registra la fecha y hora (no el contenido)',
  ];

  static const List<String> conversationProtection = [
    'Encriptación end-to-end: Tus mensajes viajan cifrados desde tu dispositivo hasta la IA',
    'No almacenamiento: Las conversaciones NO se guardan en nuestros servidores de forma permanente',
    'Procesamiento temporal: La IA analiza tu mensaje, responde y lo descarta inmediatamente',
    'Sin acceso humano: Ningún terapeuta, administrador o empleado puede leer tus conversaciones',
    'Análisis anónimo: Solo se extraen patrones estadísticos (ej: "detectó ansiedad alta") sin contenido textual',
    'Aislamiento de datos: Tu información está separada de otros usuarios por completo',
  ];

  static const List<String> dataAccess = [
    ' Terapeutas: NO tienen acceso a tus conversaciones individuales',
    ' Administradores: NO pueden leer el contenido de tus mensajes',
    ' Soporte técnico: NO puede ver tus interacciones con la IA',
    ' Tú: Solo tú puedes ver tu historial (si decides guardarlo localmente)',
    ' Sistema automático: Solo analiza patrones para generar alertas de riesgo (ej: "usuario con semáforo rojo")',
    ' Panel de terapeuta: Solo muestra indicadores de riesgo agregados (verde/amarillo/rojo) sin detalles de contenido',
  ];

  static const List<String> userRights = [
    'Derecho de acceso: Puedes solicitar una copia de tus datos almacenados',
    'Derecho de rectificación: Puedes corregir información incorrecta en tu perfil',
    'Derecho de supresión: Puedes eliminar tu cuenta y todos tus datos en cualquier momento',
    'Derecho de portabilidad: Puedes exportar tus datos en formato legible',
    'Derecho de oposición: Puedes desactivar el análisis de patrones (desactivará alertas de riesgo)',
    'Derecho a no ser perfilado: Puedes rechazar decisiones automatizadas basadas en análisis',
  ];

  static const List<String> termsConditions = [
    'Uso apropiado: Esta aplicación es una herramienta de apoyo emocional complementaria, NO reemplaza atención psicológica profesional',
    'Emergencias: En situaciones de emergencia (ideación suicida, violencia), debes contactar servicios de emergencia (911) o centros de crisis',
    'Edad mínima: Debes tener al menos 13 años para usar esta aplicación. Menores de 18 requieren consentimiento de padres/tutores',
    'Responsabilidad del usuario: Eres responsable de mantener la confidencialidad de tu cuenta',
    'Limitación de responsabilidad: La aplicación proporciona apoyo, pero no garantiza resultados terapéuticos específicos',
    'Contenido prohibido: No está permitido compartir contenido ilegal, violento, o que promueva autolesiones graves',
    'Modificaciones: Nos reservamos el derecho de actualizar estos términos con previo aviso de 30 días',
    'Jurisdicción: Estos términos se rigen por las leyes de México, específicamente el estado de Durango',
  ];

  static const List<String> securityMeasures = [
    'Encriptación SSL/TLS: Todas las comunicaciones están cifradas en tránsito',
    'Autenticación segura: Usamos Firebase Authentication con protocolos OAuth 2.0',
    'Bases de datos seguras: Firestore con reglas de seguridad estrictas y auditorías regulares',
    'Separación de datos: Información sensible separada de datos de identificación',
    'Contraseñas protegidas: Nunca almacenamos contraseñas en texto plano (solo hashes bcrypt)',
    'Auditorías de seguridad: Revisiones trimestrales de vulnerabilidades',
    'Respaldo seguro: Backups encriptados con acceso restringido',
    'Detección de intrusiones: Monitoreo 24/7 de actividad sospechosa',
  ];

  static const List<String> emergencyProtocol = [
    'Detección automática: Si la IA detecta riesgo severo, se genera una alerta automática (sin contenido del mensaje)',
    'Notificación al usuario: Recibes sugerencias para contactar ayuda profesional',
    'Sin violación de privacidad: Incluso en emergencias, NO se comparten tus conversaciones',
    'Recursos disponibles: Se muestran centros de ayuda y líneas de crisis disponibles',
    'Registro mínimo: Solo se guarda que hubo una alerta de riesgo alto, no el contenido específico',
    'Autonomía del usuario: Tú decides si contactar servicios de emergencia',
  ];

  static const String securityMessage =
      'Implementamos las mejores prácticas de seguridad de la industria. '
      'Tus datos están protegidos con encriptación de nivel bancario. '
      'Nuestros servidores están certificados y auditados regularmente.';

  static const String contactEmail = 'privacidad@apoia.com.mx';
  static const String supportEmail = 'soporte@apoia.com.mx';
  static const String dataProtectionOfficer = 'dpo@apoia.com.mx';

  static const String companyName = 'ApoIA - Apoyo Emocional Inteligente';
  static const String companyAddress = 'Durango, México';
  static const String lastUpdate = 'Noviembre 2024';

  static const String legalNotice =
      'Este aviso de privacidad cumple con la Ley Federal de Protección de Datos Personales '
      'en Posesión de los Particulares (LFPDPPP) de México y su Reglamento. '
      'Responsable: $companyName. '
      'Para ejercer tus derechos ARCO (Acceso, Rectificación, Cancelación, Oposición) '
      'contacta a: $dataProtectionOfficer';
}
