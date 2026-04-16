import '../models/pet.dart';
import '../models/social_models.dart';
import 'mock_data.dart';

List<MessageThread> buildMockMessageThreads() {
  final pets = MockData.pets;

  return [
    MessageThread(
      id: 'thread-nina',
      ownerName: 'Sofía, familia de Nina',
      pet: pets[1],
      relatedLabel: 'Conversación sobre Nina',
      lastMessage:
          'Podemos seguir por acá y ver si tiene sentido un primer acercamiento tranquilo.',
      status: 'Nuevo',
      lastActivity: 'Hace 5 min',
      summary:
          'Una conversación inicial enfocada en afinidad social, tiempos graduales y contexto seguro.',
      accentColorHex: 0xFFFFF2C6,
      connectionType: 'Vínculo social',
      stageLabel: 'Primer contacto',
      entryPointLabel: 'Viene desde un interés recibido en la bandeja social',
      nextStepLabel:
          'Definir si conviene seguir conversando o proponer un primer acercamiento.',
      contextTags: const [
        'Interacción gradual',
        'Entorno sereno',
        'Expectativas claras',
      ],
      unreadCount: 2,
      isAwaitingMyReply: true,
      autoReplies: const [
        'Perfecto, me gusta mantenerlo gradual y con buena lectura de energía.',
        'Si te sirve, podemos dejar asentado acá el tipo de encuentro que imaginamos.',
        'Me parece bien seguir por este canal antes de definir un siguiente paso.',
      ],
      messages: const [
        MessageEntry(
          text:
              'Hola, vimos el perfil de Nina y nos pareció muy compatible para una interacción tranquila.',
          timestamp: '11:12',
          isMine: false,
        ),
        MessageEntry(
          text:
              'Gracias por escribir. Nosotros también buscamos algo gradual y bien cuidado.',
          timestamp: '11:18',
          isMine: true,
        ),
        MessageEntry(
          text:
              'Buenísimo. Nina se adapta mejor a entornos serenos, así que este canal nos viene bien para ordenar expectativas.',
          timestamp: '11:21',
          isMine: false,
        ),
      ],
    ),
    MessageThread(
      id: 'thread-bruno',
      ownerName: 'Martín, familia de Bruno',
      pet: pets[2],
      relatedLabel: 'Seguimiento por Bruno',
      lastMessage:
          'Quedó pendiente revisar compatibilidad y ritmo antes de avanzar.',
      status: 'Pendiente',
      lastActivity: 'Ayer',
      summary:
          'Un hilo pensado para compatibilidad responsable, con tono claro y sin exponer datos privados.',
      accentColorHex: 0xFFDDF6F6,
      connectionType: 'Posible cría',
      stageLabel: 'En evaluación',
      entryPointLabel:
          'Se abrió después de una afinidad detectada en el módulo social',
      nextStepLabel:
          'Revisar compatibilidad, bienestar y ritmo antes de abrir un encuentro.',
      contextTags: const [
        'Compatibilidad responsable',
        'Bienestar primero',
        'Seguimiento sin apuro',
      ],
      unreadCount: 0,
      isAwaitingMyReply: false,
      autoReplies: const [
        'Gracias, nos sirve dejarlo así mientras seguimos evaluando compatibilidad.',
        'De acuerdo, podemos retomar más adelante cuando tengamos más contexto.',
        'Perfecto, lo importante es que la conversación quede clara y cuidada.',
      ],
      messages: const [
        MessageEntry(
          text:
              'Hola, queríamos dejar abierta una consulta sobre compatibilidad a futuro.',
          timestamp: '18:04',
          isMine: false,
        ),
        MessageEntry(
          text:
              'Claro, podemos usar este canal para ordenar la conversación sin apurarnos.',
          timestamp: '18:11',
          isMine: true,
        ),
      ],
    ),
    MessageThread(
      id: 'thread-milo',
      ownerName: 'Agustina, familia de Milo',
      pet: pets[0],
      relatedLabel: 'Chat activo sobre Milo',
      lastMessage:
          'Nos gustó la idea de seguir conversando antes de pensar un encuentro.',
      status: 'En seguimiento',
      lastActivity: 'Hace 2 días',
      summary:
          'Representa una relación social en seguimiento, con mensajes breves y próximos pasos claros.',
      accentColorHex: 0xFFFFE1EA,
      connectionType: 'Encuentro supervisado',
      stageLabel: 'Interés compartido',
      entryPointLabel:
          'Nació desde una intención enviada y ya tiene conversación abierta',
      nextStepLabel:
          'Mantener el intercambio y evaluar si el contexto amerita pasar a un encuentro.',
      contextTags: const [
        'Seguimiento activo',
        'Buen tono social',
        'Próximo paso claro',
      ],
      unreadCount: 0,
      isAwaitingMyReply: true,
      autoReplies: const [
        'Totalmente, seguir conversando por acá nos parece la mejor forma.',
        'Dale, lo dejamos asentado y vemos después si conviene avanzar.',
        'Gracias, por ahora está bueno mantener el intercambio dentro de Mascotify.',
      ],
      messages: const [
        MessageEntry(
          text:
              'Hola, Milo nos dio muy buena impresión y queríamos conversar un poco más.',
          timestamp: '09:06',
          isMine: false,
        ),
        MessageEntry(
          text:
              'Gracias. Nosotros también preferimos hablar primero para entender mejor el contexto.',
          timestamp: '09:10',
          isMine: true,
        ),
        MessageEntry(
          text:
              'Perfecto. Nos gusta que exista este espacio antes de cualquier paso presencial.',
          timestamp: '09:13',
          isMine: false,
        ),
      ],
    ),
  ];
}

MessageThread? findMockThreadForPet(Pet pet) {
  final threads = buildMockMessageThreads();
  for (final thread in threads) {
    if (thread.pet.id == pet.id) {
      return thread;
    }
  }
  return null;
}

List<SocialInboxEntry> buildMockSocialInboxEntries() {
  final pets = MockData.pets;

  return [
    SocialInboxEntry(
      pet: pets[1],
      direction: 'Recibido',
      interestType: 'Vínculo social',
      status: 'Pendiente',
      message:
          'Su perfil conectó bien con el de Nina para una interacción gradual y tranquila.',
      accentColorHex: 0xFFFFF2C6,
    ),
    SocialInboxEntry(
      pet: pets[2],
      direction: 'Recibido',
      interestType: 'Posible cría',
      status: 'Posible afinidad',
      message:
          'Hay interés en explorar compatibilidad futura dentro de un marco seguro.',
      accentColorHex: 0xFFDDF6F6,
    ),
    SocialInboxEntry(
      pet: pets[0],
      direction: 'Enviado',
      interestType: 'Encuentro supervisado',
      status: 'En seguimiento',
      message:
          'La propuesta quedó abierta para una futura conexión presencial con seguimiento.',
      accentColorHex: 0xFFFFE1EA,
    ),
  ];
}

List<SavedProfileEntry> buildMockSavedProfiles() {
  final pets = MockData.pets;

  return [
    SavedProfileEntry(
      pet: pets[0],
      savedAtLabel: 'Guardado hace 2 días',
      reason: 'Compatibilidad social prometedora y energía equilibrada.',
    ),
    SavedProfileEntry(
      pet: pets[1],
      savedAtLabel: 'Guardado esta semana',
      reason: 'Perfil calmo para una futura conexión gradual.',
    ),
  ];
}
