import '../models/pet.dart';
import '../models/social_models.dart';
import 'mock_data.dart';

List<MessageThread> buildMockMessageThreads() {
  final pets = MockData.pets;

  return [
    MessageThread(
      id: 'thread-nina',
      ownerName: 'Sofia, familia de Nina',
      pet: pets[1],
      relatedLabel: 'Conversacion sobre Nina',
      lastMessage:
          'Podemos seguir por aca y ver si tiene sentido un primer acercamiento tranquilo.',
      status: 'Nuevo',
      lastActivity: 'Hace 5 min',
      summary:
          'Una conversacion inicial enfocada en afinidad social, tiempos graduales y contexto seguro.',
      accentColorHex: 0xFFFFF2C6,
      autoReplies: const [
        'Perfecto, me gusta mantenerlo gradual y con buena lectura de energia.',
        'Si te sirve, podemos dejar asentado aca el tipo de encuentro que imaginamos.',
        'Me parece bien seguir por este canal antes de definir un siguiente paso.',
      ],
      messages: const [
        MessageEntry(
          text:
              'Hola, vimos el perfil de Nina y nos parecio muy compatible para una interaccion tranquila.',
          timestamp: '11:12',
          isMine: false,
        ),
        MessageEntry(
          text:
              'Gracias por escribir. Nosotros tambien buscamos algo gradual y bien cuidado.',
          timestamp: '11:18',
          isMine: true,
        ),
        MessageEntry(
          text:
              'Buenisimo. Nina se adapta mejor a entornos serenos, asi que este canal nos viene bien para ordenar expectativas.',
          timestamp: '11:21',
          isMine: false,
        ),
      ],
    ),
    MessageThread(
      id: 'thread-bruno',
      ownerName: 'Martin, familia de Bruno',
      pet: pets[2],
      relatedLabel: 'Seguimiento por Bruno',
      lastMessage:
          'Quedo pendiente revisar compatibilidad y ritmo antes de avanzar.',
      status: 'Pendiente',
      lastActivity: 'Ayer',
      summary:
          'Un hilo pensado para compatibilidad responsable, con tono claro y sin exponer datos privados.',
      accentColorHex: 0xFFDDF6F6,
      autoReplies: const [
        'Gracias, nos sirve dejarlo asi mientras seguimos evaluando compatibilidad.',
        'De acuerdo, podemos retomar mas adelante cuando tengamos mas contexto.',
        'Perfecto, lo importante es que la conversacion quede clara y cuidada.',
      ],
      messages: const [
        MessageEntry(
          text:
              'Hola, queriamos dejar abierta una consulta sobre compatibilidad a futuro.',
          timestamp: '18:04',
          isMine: false,
        ),
        MessageEntry(
          text:
              'Claro, podemos usar este canal para ordenar la conversacion sin apurarnos.',
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
          'Nos gusto la idea de seguir conversando antes de pensar un encuentro.',
      status: 'Visto',
      lastActivity: 'Hace 2 dias',
      summary:
          'Representa una relacion social en seguimiento, con mensajes breves y proximos pasos claros.',
      accentColorHex: 0xFFFFE1EA,
      autoReplies: const [
        'Totalmente, seguir conversando por aca nos parece la mejor forma.',
        'Dale, lo dejamos asentado y vemos despues si conviene avanzar.',
        'Gracias, por ahora esta bueno mantener el intercambio dentro de Mascotify.',
      ],
      messages: const [
        MessageEntry(
          text:
              'Hola, Milo nos dio muy buena impresion y queriamos conversar un poco mas.',
          timestamp: '09:06',
          isMine: false,
        ),
        MessageEntry(
          text:
              'Gracias. Nosotros tambien preferimos hablar primero para entender mejor el contexto.',
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
      interestType: 'Vinculo social',
      status: 'Pendiente',
      message:
          'Su perfil conecto bien con el de Nina para una interaccion gradual y tranquila.',
      accentColorHex: 0xFFFFF2C6,
    ),
    SocialInboxEntry(
      pet: pets[2],
      direction: 'Recibido',
      interestType: 'Posible cria',
      status: 'Posible afinidad',
      message:
          'Hay interes en explorar compatibilidad futura dentro de un marco seguro.',
      accentColorHex: 0xFFDDF6F6,
    ),
    SocialInboxEntry(
      pet: pets[0],
      direction: 'Enviado',
      interestType: 'Encuentro supervisado',
      status: 'Visto',
      message:
          'La propuesta quedo abierta para una futura conexion presencial con seguimiento.',
      accentColorHex: 0xFFFFE1EA,
    ),
  ];
}

List<SavedProfileEntry> buildMockSavedProfiles() {
  final pets = MockData.pets;

  return [
    SavedProfileEntry(
      pet: pets[0],
      savedAtLabel: 'Guardado hace 2 dias',
      reason: 'Compatibilidad social prometedora y energia equilibrada.',
    ),
    SavedProfileEntry(
      pet: pets[1],
      savedAtLabel: 'Guardado esta semana',
      reason: 'Perfil calmo para una futura conexion gradual.',
    ),
  ];
}
