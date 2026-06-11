import 'package:flutter/material.dart';

import '../../../../shared/widgets/responsive_page_body.dart';
import '../../../../theme/app_colors.dart';

enum HelpTopic {
  gettingStarted,
  home,
  pets,
  petProfile,
  secureQr,
  health,
  reminders,
  lostPets,
  explore,
  clips,
  matching,
  community,
  activity,
  profileSettings,
  privacySecurity,
  professionals,
  plans,
  advertising,
  faq,
}

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key, this.initialTopic});

  final HelpTopic? initialTopic;

  static const List<HelpSection> sections = [
    HelpSection(
      topic: HelpTopic.gettingStarted,
      title: 'Primeros pasos',
      icon: Icons.flag_outlined,
      what: 'La forma rapida de empezar con una cuenta familiar o profesional.',
      how:
          'Carga una mascota, revisa Inicio y usa Mascotas para completar su perfil.',
      data:
          'Usa datos basicos de cuenta, mascotas, plan local y actividad demo.',
      note:
          'La build actual guarda datos local/demo y no publica informacion real.',
    ),
    HelpSection(
      topic: HelpTopic.home,
      title: 'Inicio',
      icon: Icons.home_outlined,
      what: 'Resume el estado principal de la cuenta.',
      how:
          'Mira alertas, accesos rapidos, mascotas activas y actividad reciente.',
      data: 'Muestra contadores, notificaciones y ultimos movimientos locales.',
      note:
          'Si no hay mascotas, Inicio queda simple hasta que cargues la primera.',
    ),
    HelpSection(
      topic: HelpTopic.pets,
      title: 'Mascotas',
      icon: Icons.pets_outlined,
      what: 'Centro para crear, editar y revisar los perfiles de mascotas.',
      how:
          'Usa Agregar para crear perfiles y entra al detalle para QR, salud e historial.',
      data: 'Muestra nombre, especie, raza, edad, plan y reportes asociados.',
      note: 'Los limites visibles dependen del plan local seleccionado.',
    ),
    HelpSection(
      topic: HelpTopic.petProfile,
      title: 'Perfil de mascota',
      icon: Icons.badge_outlined,
      what: 'Ficha operativa de cada mascota.',
      how:
          'Consulta identidad, datos sociales, matching, QR, salud y actividad.',
      data:
          'Usa la informacion que cargaste en Mascotas y eventos generados en la app.',
      note: 'La ubicacion se muestra como zona general; evita datos sensibles.',
    ),
    HelpSection(
      topic: HelpTopic.secureQr,
      title: 'QR seguro',
      icon: Icons.qr_code_rounded,
      what:
          'Una capa para identificar a la mascota y recibir senales de escaneo.',
      how:
          'Desde el perfil abre QR o Historial QR para ver estado, eventos y trazabilidad.',
      data:
          'Puede mostrar escaneos, zona aproximada, estado del contacto y actividad.',
      note:
          'No debe exponer telefono, email ni direccion exacta sin consentimiento.',
    ),
    HelpSection(
      topic: HelpTopic.health,
      title: 'Salud y vacunas',
      icon: Icons.vaccines_outlined,
      what: 'Libreta sanitaria digital para ordenar vacunas y seguimiento.',
      how:
          'Agrega vacunas aplicadas o pendientes y revisa sugerencias por especie.',
      data:
          'Usa especie, edad, vacunas cargadas, fechas y recordatorios locales.',
      note: 'No reemplaza la indicacion de un veterinario.',
    ),
    HelpSection(
      topic: HelpTopic.reminders,
      title: 'Calendario y recordatorios',
      icon: Icons.event_available_outlined,
      what: 'Vista de proximas acciones sanitarias o de cuidado.',
      how:
          'Revisa recordatorios sugeridos y registra acciones cuando correspondan.',
      data: 'Se alimenta de vacunas, fechas y reglas locales de cuidado.',
      note:
          'Las fechas son orientativas si no fueron confirmadas por un profesional.',
    ),
    HelpSection(
      topic: HelpTopic.lostPets,
      title: 'Mascotas perdidas',
      icon: Icons.travel_explore_rounded,
      what: 'Catalogo solidario para reportar y revisar mascotas perdidas.',
      how:
          'Publica zona general, descripcion y senas utiles; usa contacto seguro con cuidado.',
      data:
          'Muestra especie, zona, descripcion, estado y contacto visible si corresponde.',
      note:
          'No pagues rescates, verifica senas y reporta intentos de cobro o fraude.',
    ),
    HelpSection(
      topic: HelpTopic.explore,
      title: 'Explorar',
      icon: Icons.explore_outlined,
      what: 'Espacio para descubrir perfiles, comunidad y profesionales.',
      how:
          'Filtra perfiles, guarda los que te interesan y abre accesos a comunidad.',
      data:
          'Usa mascotas locales, guardados, filtros y entradas sociales demo.',
      note:
          'Los contactos reales y conexiones productivas dependen de funciones futuras.',
    ),
    HelpSection(
      topic: HelpTopic.clips,
      title: 'Clips',
      icon: Icons.play_circle_outline_rounded,
      what: 'Feed de videos cortos de Mascotify y contenido demo.',
      how:
          'Desliza verticalmente, silencia, guarda, da like o comparte dentro de la demo.',
      data:
          'Muestra autor/cuenta, descripcion breve, metricas y estado de interaccion.',
      note:
          'El player es local/demo; evita subir o usar contenido sin derechos.',
    ),
    HelpSection(
      topic: HelpTopic.matching,
      title: 'Matching',
      icon: Icons.favorite_border_rounded,
      what: 'Deck local para descubrir mascotas compatibles.',
      how:
          'Elige tu mascota y objetivo; desliza a la derecha para like o izquierda para pasar.',
      data:
          'Usa especie, raza, edad, zona general, energia y motivos de afinidad.',
      note:
          'El match mutuo es demo. El contacto real sera mediado por Mascotify.',
    ),
    HelpSection(
      topic: HelpTopic.community,
      title: 'Comunidad',
      icon: Icons.groups_outlined,
      what: 'Entradas sociales, intereses y conexiones alrededor de mascotas.',
      how: 'Revisa perfiles, guardados y movimientos sociales desde Explorar.',
      data: 'Usa actividad demo, perfiles guardados y relaciones locales.',
      note:
          'La mensajeria real y el contacto productivo son funciones futuras.',
    ),
    HelpSection(
      topic: HelpTopic.activity,
      title: 'Actividad',
      icon: Icons.notifications_active_outlined,
      what: 'Feed de eventos importantes de la cuenta.',
      how:
          'Filtra por tipo, busca movimientos y abre el destino asociado cuando exista.',
      data: 'Reune eventos de mascotas, QR, mensajes, social y notificaciones.',
      note:
          'Si un evento no tiene destino, se mantiene como registro informativo.',
    ),
    HelpSection(
      topic: HelpTopic.profileSettings,
      title: 'Perfil y configuracion',
      icon: Icons.settings_outlined,
      what: 'Lugar para revisar cuenta, preferencias, plan y seguridad.',
      how:
          'Cambia preferencias locales, abre ayuda o contactos y revisa el plan actual.',
      data: 'Usa email, ciudad, plan, notificaciones y opciones de privacidad.',
      note:
          'Cambios de cuenta sensibles siguen preparados para una etapa posterior.',
    ),
    HelpSection(
      topic: HelpTopic.privacySecurity,
      title: 'Privacidad y seguridad',
      icon: Icons.shield_outlined,
      what: 'Reglas simples para usar Mascotify sin exponer datos sensibles.',
      how: 'Comparte zona general, senas utiles y datos minimos para operar.',
      data:
          'La app evita mostrar telefono, email o direccion exacta en experiencias publicas.',
      note:
          'El contacto seguro debe tener consentimiento y mediacion de Mascotify.',
    ),
    HelpSection(
      topic: HelpTopic.professionals,
      title: 'Profesionales y servicios',
      icon: Icons.storefront_outlined,
      what: 'Area para perfiles profesionales, contenido y servicios.',
      how:
          'Explora profesionales o usa el modo profesional si esta disponible en la cuenta.',
      data:
          'Muestra perfil, ciudad, especialidad, presencia publica y contenido demo.',
      note: 'Reservas, pagos y contrataciones reales son funciones futuras.',
    ),
    HelpSection(
      topic: HelpTopic.plans,
      title: 'Planes Free / Plus / Pro',
      icon: Icons.workspace_premium_outlined,
      what: 'Resumen de limites y beneficios visibles en la app.',
      how:
          'Revisa el plan desde Perfil y cambia el selector local cuando corresponda.',
      data: 'Usa el plan asociado a la cuenta local activa.',
      note:
          'Las suscripciones reales todavia no estan activadas en esta build.',
    ),
    HelpSection(
      topic: HelpTopic.advertising,
      title: 'Publicidad',
      icon: Icons.campaign_outlined,
      what: 'Espacio reservado para explicar anuncios si la UI los muestra.',
      how: 'No requiere accion del usuario en esta build.',
      data:
          'No se modifica AdMob ni se agrega integracion publicitaria en esta tarea.',
      note:
          'La explicacion completa se mantendra aqui cuando la publicidad este activa.',
    ),
    HelpSection(
      topic: HelpTopic.faq,
      title: 'Preguntas frecuentes',
      icon: Icons.quiz_outlined,
      what: 'Respuestas cortas para dudas comunes.',
      how:
          'Busca el tema de la seccion donde estas o vuelve a Configuracion > Ayuda.',
      data:
          'Las funciones demo usan datos locales y no publican informacion real.',
      note:
          'Si algo no carga, vuelve a intentar y revisa que exista contenido para mostrar.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final orderedSections = _orderedSections();

    return Scaffold(
      appBar: AppBar(title: const Text('Ayuda')),
      body: SafeArea(
        child: ResponsivePageBody(
          maxWidth: 860,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            children: [
              _HelpHero(initialTopic: initialTopic),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final section in sections)
                    ChoiceChip(
                      key: ValueKey('help-topic-chip-${section.topic.name}'),
                      label: Text(section.title),
                      selected: section.topic == initialTopic,
                      onSelected: (_) => Navigator.of(context).pushReplacement(
                        MaterialPageRoute<void>(
                          builder: (_) =>
                              HelpScreen(initialTopic: section.topic),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 14),
              for (final section in orderedSections)
                Card(
                  child: ExpansionTile(
                    key: ValueKey('help-topic-${section.topic.name}'),
                    initiallyExpanded: section.topic == initialTopic,
                    leading: Icon(section.icon, color: AppColors.primaryDeep),
                    title: Text(section.title),
                    childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
                    children: [_HelpSectionBody(section: section)],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  List<HelpSection> _orderedSections() {
    final selected = initialTopic;
    if (selected == null) return sections;
    final selectedSection = sections
        .where((section) => section.topic == selected)
        .toList(growable: false);
    if (selectedSection.isEmpty) return sections;
    return [
      selectedSection.first,
      ...sections.where((section) => section.topic != selected),
    ];
  }
}

class _HelpHero extends StatelessWidget {
  const _HelpHero({required this.initialTopic});

  final HelpTopic? initialTopic;

  @override
  Widget build(BuildContext context) {
    String? selectedTitle;
    for (final section in HelpScreen.sections) {
      if (section.topic == initialTopic) {
        selectedTitle = section.title;
        break;
      }
    }

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.help_outline_rounded,
              color: AppColors.primaryDeep,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Centro de ayuda',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  selectedTitle == null
                      ? 'Guias cortas organizadas por seccion.'
                      : 'Tema abierto: $selectedTitle.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HelpSectionBody extends StatelessWidget {
  const _HelpSectionBody({required this.section});

  final HelpSection section;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _HelpLine(label: 'Que es', text: section.what),
        _HelpLine(label: 'Como se usa', text: section.how),
        _HelpLine(label: 'Datos que usa', text: section.data),
        _HelpLine(label: 'Tener en cuenta', text: section.note),
      ],
    );
  }
}

class _HelpLine extends StatelessWidget {
  const _HelpLine({required this.label, required this.text});

  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.primaryDeep,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class HelpSection {
  const HelpSection({
    required this.topic,
    required this.title,
    required this.icon,
    required this.what,
    required this.how,
    required this.data,
    required this.note,
  });

  final HelpTopic topic;
  final String title;
  final IconData icon;
  final String what;
  final String how;
  final String data;
  final String note;
}
