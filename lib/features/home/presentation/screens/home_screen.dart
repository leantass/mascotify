import 'package:flutter/material.dart';

import '../../../../features/explore/presentation/screens/connections_inbox_screen.dart';
import '../../../../features/explore/presentation/screens/messages_inbox_screen.dart';
import '../../../../features/explore/presentation/screens/professionals_screen.dart';
import '../../../../features/pets/presentation/screens/pet_detail_screen.dart';
import '../../../../features/pets/presentation/screens/qr_traceability_screen.dart';
import '../../../../shared/data/app_data_source.dart';
import '../../../../shared/models/account_identity_models.dart';
import '../../../../shared/models/notification_models.dart';
import '../../../../shared/models/pet.dart';
import '../../../../shared/models/report_models.dart';
import '../../../../shared/models/social_models.dart';
import '../../../../shared/widgets/responsive_page_body.dart';
import '../../../../shared/widgets/pet_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_theme.dart';
import '../../../profile/presentation/screens/help_screen.dart';
import '../../../profile/presentation/widgets/contextual_help_link.dart';
import 'notifications_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AppData.currentUser;
    final account = AppData.accountFor(AccountExperience.family);
    final familyProfile = account.familyProfile!;
    final pets = AppData.pets;
    final notifications = AppData.notifications;
    final notificationCount = notifications
        .where((item) => item.isUnread)
        .length;
    final prioritizedNotifications = [...notifications]
      ..sort(_compareNotificationsForHome);
    final latestNotification = prioritizedNotifications.isNotEmpty
        ? prioritizedNotifications.first
        : null;
    final threads = AppData.messageThreads;
    final unreadMessageCount = threads.where(
      (thread) => thread.unreadCount > 0,
    );
    final awaitingReplyCount = threads
        .where((thread) => thread.isAwaitingMyReply)
        .length;
    final replyThread = threads.isEmpty
        ? null
        : threads.firstWhere(
            (thread) => thread.isAwaitingMyReply,
            orElse: () => threads.first,
          );
    final socialInboxItems = AppData.socialInboxEntries;
    final socialPendingCount = socialInboxItems
        .where((item) => item.status != 'En seguimiento')
        .length;
    final savedProfiles = AppData.savedProfiles;
    final activeQrCount = pets.where((pet) => pet.qrEnabled).length;
    final pendingQrCount = pets.where((pet) => !pet.qrEnabled).length;
    final primaryPet = pets.isNotEmpty ? pets.first : null;
    final qrFocusPet = pets.length >= 3
        ? pets[2]
        : (pets.isNotEmpty ? pets.first : null);
    final qrFocusSnapshot = qrFocusPet == null
        ? null
        : AppData.qrStatusSnapshotForPet(qrFocusPet);
    final featuredContent = AppData.professionalLibraryContents.first;
    final activeAttentionCount =
        notificationCount +
        awaitingReplyCount +
        socialPendingCount +
        pendingQrCount;
    final hasPriorityContent =
        latestNotification != null ||
        replyThread != null ||
        qrFocusPet != null ||
        socialPendingCount > 0;

    return Scaffold(
      body: SafeArea(
        child: ResponsivePageBody(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            children: [
              _HomeHero(
                firstName: user.name.split(' ').first,
                city: user.city,
                planName: account.planName,
                roleLabel: 'Modo familia',
                householdName: familyProfile.householdName,
                petCount: pets.length,
                activeAttentionCount: activeAttentionCount,
                notificationCount: notificationCount,
                onOpenNotifications: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const NotificationsScreen(),
                  ),
                ),
                onOpenMessages: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const MessagesInboxScreen(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (hasPriorityContent)
                _PriorityCard(
                  latestNotification: latestNotification,
                  replyThread: replyThread,
                  qrFocusPet: qrFocusPet,
                  qrFocusSnapshot: qrFocusSnapshot,
                  socialPendingCount: socialPendingCount,
                  onOpenNotifications: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const NotificationsScreen(),
                    ),
                  ),
                  onOpenMessages: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const MessagesInboxScreen(),
                    ),
                  ),
                  onOpenSocial: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const ConnectionsInboxScreen(),
                    ),
                  ),
                  onOpenQr: qrFocusPet == null
                      ? null
                      : () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                QrTraceabilityScreen(pet: qrFocusPet),
                          ),
                        ),
                )
              else
                const _HomeEmptyStateCard(
                  title: 'Tu cuenta está lista para empezar',
                  description:
                      'Cuando sumes una mascota, aca vas a ver prioridades y actividad.',
                ),
              const SizedBox(height: 20),
              const SectionHeader(
                eyebrow: 'Pulso Mascotify',
                title: 'Qué está activo hoy',
                subtitle: 'Resumen operativo de tu cuenta.',
              ),
              const SizedBox(height: 16),
              _EcosystemOverview(
                activeQrCount: activeQrCount,
                pendingQrCount: pendingQrCount,
                unreadMessageCount: unreadMessageCount.length,
                awaitingReplyCount: awaitingReplyCount,
                socialPendingCount: socialPendingCount,
                savedProfilesCount: savedProfiles.length,
              ),
              const SizedBox(height: 20),
              const SectionHeader(
                eyebrow: 'Centro operativo',
                title: 'Accesos rápidos',
                subtitle: 'Atajos para actuar rapido.',
              ),
              const SizedBox(height: 16),
              _PrimaryAccessGrid(
                primaryPet: primaryPet,
                qrFocusPet: qrFocusPet,
                onOpenSocial: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const ConnectionsInboxScreen(),
                  ),
                ),
                onOpenQr: qrFocusPet == null
                    ? null
                    : () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => QrTraceabilityScreen(pet: qrFocusPet),
                        ),
                      ),
                onOpenProfessionals: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const ProfessionalsScreen(),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _SectionCard(
                title: 'Lo más vivo del ecosistema',
                subtitle: 'Ultimas senales relevantes.',
                child: Column(
                  children: [
                    if (latestNotification != null) ...[
                      _EcosystemFeedTile(
                        title: latestNotification.title,
                        subtitle: latestNotification.timeLabel,
                        description: latestNotification.description,
                        tone: Color(latestNotification.accentColorHex),
                        icon: Icons.notifications_active_outlined,
                      ),
                      const SizedBox(height: 10),
                    ],
                    if (replyThread != null) ...[
                      _EcosystemFeedTile(
                        title: 'Mensajería con contexto activo',
                        subtitle:
                            '${replyThread.ownerName} • ${replyThread.status}',
                        description:
                            '${replyThread.lastMessage} Próximo paso: ${replyThread.nextStepLabel}',
                        tone: Color(replyThread.accentColorHex),
                        icon: Icons.chat_bubble_outline_rounded,
                      ),
                      const SizedBox(height: 10),
                    ],
                    _EcosystemFeedTile(
                      title: featuredContent.title,
                      subtitle:
                          '${featuredContent.professional} • ${featuredContent.category}',
                      description: featuredContent.summary,
                      tone: Color(featuredContent.accentColorHex),
                      icon: Icons.workspace_premium_outlined,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SectionHeader(
                eyebrow: 'Base Mascotify',
                title: 'Mis mascotas',
                subtitle: 'Perfiles activos de la cuenta.',
                trailing: primaryPet == null
                    ? null
                    : TextButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => PetDetailScreen(pet: primaryPet),
                          ),
                        ),
                        child: const Text('Ver ficha'),
                      ),
              ),
              const SizedBox(height: 16),
              if (pets.isEmpty)
                const _HomeEmptyStateCard(
                  title: 'Todavía no hay mascotas cargadas',
                  description:
                      'Agrega una mascota para activar ficha, QR y seguimiento.',
                )
              else
                ...pets
                    .take(3)
                    .map(
                      (pet) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: PetCard(
                          pet: pet,
                          compact: true,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => PetDetailScreen(pet: pet),
                            ),
                          ),
                        ),
                      ),
                    ),
              const SizedBox(height: 24),
              _AccountStatusCard(
                account: account,
                familyProfile: familyProfile,
              ),
              const SizedBox(height: 16),
              const ContextualHelpLink(
                topic: HelpTopic.home,
                label: 'Ver ayuda sobre Inicio',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

int _compareNotificationsForHome(
  EcosystemNotification a,
  EcosystemNotification b,
) {
  final unreadComparison = (a.isUnread ? 0 : 1).compareTo(b.isUnread ? 0 : 1);
  if (unreadComparison != 0) return unreadComparison;

  final priorityComparison = _homeNotificationPriorityRank(
    a.priority,
  ).compareTo(_homeNotificationPriorityRank(b.priority));
  if (priorityComparison != 0) return priorityComparison;

  final actionComparison =
      (b.action != null ? 1 : 0) - (a.action != null ? 1 : 0);
  if (actionComparison != 0) return actionComparison;

  return 0;
}

int _homeNotificationPriorityRank(EcosystemNotificationPriority priority) {
  switch (priority) {
    case EcosystemNotificationPriority.attention:
      return 0;
    case EcosystemNotificationPriority.useful:
      return 1;
    case EcosystemNotificationPriority.info:
      return 2;
  }
}

class _HomeHero extends StatelessWidget {
  const _HomeHero({
    required this.firstName,
    required this.city,
    required this.planName,
    required this.roleLabel,
    required this.householdName,
    required this.petCount,
    required this.activeAttentionCount,
    required this.notificationCount,
    required this.onOpenNotifications,
    required this.onOpenMessages,
  });

  final String firstName;
  final String city;
  final String planName;
  final String roleLabel;
  final String householdName;
  final int petCount;
  final int activeAttentionCount;
  final int notificationCount;
  final VoidCallback onOpenNotifications;
  final VoidCallback onOpenMessages;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final palette = MascotifyPalette.of(context);
    final heroGradient = _isDarkMode(context)
        ? LinearGradient(
            colors: [
              palette.primarySoft,
              colorScheme.surface,
              palette.surfaceAlt,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : const LinearGradient(
            colors: [
              AppColors.primarySoft,
              AppColors.surface,
              AppColors.accentSoft,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: heroGradient,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: _homeBorder(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: _isDarkMode(context)
                      ? _homeSurfaceTint(context)
                      : AppColors.dark,
                  borderRadius: BorderRadius.circular(999),
                  border: _isDarkMode(context)
                      ? Border.all(color: _homeBorder(context))
                      : null,
                ),
                child: Text(
                  'Hola, $firstName',
                  style: textTheme.bodyMedium?.copyWith(
                    color: _isDarkMode(context)
                        ? _homeText(context)
                        : Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              _IconButtonBadge(
                icon: Icons.notifications_none_rounded,
                badgeCount: notificationCount,
                onTap: onOpenNotifications,
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            'La home ya puede sentirse como el centro operativo y emocional de Mascotify.',
            style: textTheme.headlineLarge,
          ),
          const SizedBox(height: 10),
          Text(
            '$householdName usa Mascotify como una base para mascotas, QR, social, mensajería y comunidad experta desde $city.',
            style: textTheme.bodyLarge?.copyWith(
              color: _homeSecondaryText(context),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _HeroPill(
                label: roleLabel,
                color: _isDarkMode(context)
                    ? _homeSurfaceTint(context)
                    : Colors.white,
              ),
              _HeroPill(
                label: planName,
                color: _darkAwareTone(context, AppColors.supportSoft),
              ),
              _HeroPill(
                label: '$activeAttentionCount focos activos',
                color: _darkAwareTone(context, AppColors.accentSoft),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _HeroMetric(
                  value: '$petCount',
                  label: 'Mascotas activas',
                  tone: _darkAwareTone(context, AppColors.surface),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _HeroMetric(
                  value: '$activeAttentionCount',
                  label: 'Puntos de atención',
                  tone: _darkAwareTone(context, AppColors.supportSoft),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onOpenNotifications,
                  child: const Text('Ver actividad'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: onOpenMessages,
                  child: const Text('Abrir mensajes'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EcosystemOverview extends StatelessWidget {
  const _EcosystemOverview({
    required this.activeQrCount,
    required this.pendingQrCount,
    required this.unreadMessageCount,
    required this.awaitingReplyCount,
    required this.socialPendingCount,
    required this.savedProfilesCount,
  });

  final int activeQrCount;
  final int pendingQrCount;
  final int unreadMessageCount;
  final int awaitingReplyCount;
  final int socialPendingCount;
  final int savedProfilesCount;

  @override
  Widget build(BuildContext context) {
    final metrics = [
      _OverviewTile(
        title: 'QR activo',
        value: '$activeQrCount listos',
        description: '$pendingQrCount perfiles todavía esperan activación.',
        color: _darkAwareTone(context, AppColors.supportSoft),
        icon: Icons.qr_code_2_rounded,
      ),
      _OverviewTile(
        title: 'Mensajes',
        value: '$unreadMessageCount chats',
        description: '$awaitingReplyCount conversaciones esperan tu lectura.',
        color: _darkAwareTone(context, AppColors.accentSoft),
        icon: Icons.chat_bubble_outline_rounded,
      ),
      _OverviewTile(
        title: 'Matching',
        value: '$socialPendingCount señales',
        description: 'Intereses, afinidades y conexiones con más contexto.',
        color: _darkAwareTone(context, AppColors.primarySoft),
        icon: Icons.favorite_border_rounded,
      ),
      _OverviewTile(
        title: 'Guardados',
        value: '$savedProfilesCount perfiles',
        description: 'Perfiles listos para retomar y comparar mejor.',
        color: _homeSurfaceAlt(context),
        icon: Icons.bookmark_outline_rounded,
      ),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _homeSurface(context),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: _homeBorder(context)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final useHorizontalLayout = constraints.maxWidth >= 760;

          if (!useHorizontalLayout) {
            return Column(
              children: [
                for (var index = 0; index < metrics.length; index++) ...[
                  if (index > 0)
                    Divider(height: 18, color: _homeBorder(context)),
                  metrics[index],
                ],
              ],
            );
          }

          return Row(
            children: [
              for (var index = 0; index < metrics.length; index++) ...[
                if (index > 0)
                  Container(
                    width: 1,
                    height: 70,
                    margin: const EdgeInsets.symmetric(horizontal: 14),
                    color: _homeBorder(context),
                  ),
                Expanded(child: metrics[index]),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _PrimaryAccessGrid extends StatelessWidget {
  const _PrimaryAccessGrid({
    required this.primaryPet,
    required this.qrFocusPet,
    required this.onOpenSocial,
    required this.onOpenQr,
    required this.onOpenProfessionals,
  });

  final Pet? primaryPet;
  final Pet? qrFocusPet;
  final VoidCallback onOpenSocial;
  final VoidCallback? onOpenQr;
  final VoidCallback onOpenProfessionals;

  @override
  Widget build(BuildContext context) {
    final items = [
      _PrimaryAccessCard(
        title: 'Mascotas',
        subtitle: primaryPet == null
            ? 'Agrega tu primera mascota desde la sección Mascotas para destrabar identidad, QR, matching y ficha completa.'
            : 'Entrá a identidad, salud, matching y ficha completa desde una sola base.',
        icon: Icons.pets_rounded,
        tone: _darkAwareTone(context, AppColors.primarySoft),
        onTap: primaryPet == null
            ? null
            : () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PetDetailScreen(pet: primaryPet!),
                ),
              ),
        highlight: primaryPet == null
            ? 'Todavía no hay perfiles cargados en esta cuenta.'
            : null,
      ),
      _PrimaryAccessCard(
        title: 'QR y seguridad',
        subtitle: qrFocusPet == null
            ? 'Se habilita cuando tengas al menos una mascota cargada en la base local.'
            : 'Historial, contacto protegido y trazabilidad ya visible dentro del producto.',
        icon: Icons.qr_code_2_rounded,
        tone: _darkAwareTone(context, AppColors.supportSoft),
        onTap: onOpenQr,
        highlight: qrFocusPet == null
            ? 'La cuenta nueva ya no hereda QR ajenos.'
            : null,
      ),
      _PrimaryAccessCard(
        title: 'Matching social',
        subtitle:
            'Intereses, perfiles guardados y afinidades mejor explicadas.',
        icon: Icons.favorite_border_rounded,
        tone: _darkAwareTone(context, AppColors.primarySoft),
        onTap: onOpenSocial,
      ),
      _PrimaryAccessCard(
        title: 'Profesionales y contenido',
        subtitle:
            'La comunidad experta ya suma voces, confianza y base para futuros servicios dentro del ecosistema.',
        icon: Icons.workspace_premium_outlined,
        tone: _darkAwareTone(context, AppColors.accentSoft),
        onTap: onOpenProfessionals,
        highlight:
            'Una entrada más rica para contenido, confianza y futuros servicios.',
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final useTwoColumns = constraints.maxWidth >= 700;
        final columnCount = useTwoColumns ? 2 : 1;
        final itemHeight = useTwoColumns ? 244.0 : 236.0;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columnCount,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            mainAxisExtent: itemHeight,
          ),
          itemBuilder: (context, index) => items[index],
        );
      },
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _PriorityCard extends StatelessWidget {
  const _PriorityCard({
    required this.latestNotification,
    required this.replyThread,
    required this.qrFocusPet,
    required this.qrFocusSnapshot,
    required this.socialPendingCount,
    required this.onOpenNotifications,
    required this.onOpenMessages,
    required this.onOpenSocial,
    required this.onOpenQr,
  });

  final EcosystemNotification? latestNotification;
  final MessageThread? replyThread;
  final Pet? qrFocusPet;
  final QrStatusSnapshot? qrFocusSnapshot;
  final int socialPendingCount;
  final VoidCallback onOpenNotifications;
  final VoidCallback onOpenMessages;
  final VoidCallback onOpenSocial;
  final VoidCallback? onOpenQr;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Qué requiere atención ahora',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Una capa breve para entender rápido qué mirar, qué resolver y hacia dónde entrar desde la home.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            if (latestNotification != null) ...[
              _PriorityRow(
                title: latestNotification!.title,
                description: latestNotification!.description,
                pill: latestNotification!.timeLabel,
                tone: Color(latestNotification!.accentColorHex),
                icon: Icons.notifications_active_outlined,
              ),
              const SizedBox(height: 10),
            ],
            if (replyThread != null) ...[
              _PriorityRow(
                title: 'Mensajería en seguimiento',
                description:
                    '${replyThread!.ownerName} espera respuesta. ${replyThread!.nextStepLabel}',
                pill:
                    '${replyThread!.unreadCount} nuevo${replyThread!.unreadCount == 1 ? '' : 's'}',
                tone: Color(replyThread!.accentColorHex),
                icon: Icons.chat_bubble_outline_rounded,
              ),
              const SizedBox(height: 10),
            ],
            if (qrFocusPet != null && qrFocusSnapshot != null) ...[
              _PriorityRow(
                title: 'QR y trazabilidad de ${qrFocusPet!.name}',
                description:
                    '${qrFocusSnapshot!.lastSignalLabel}. ${qrFocusSnapshot!.lastSignalDetail}',
                pill: qrFocusSnapshot!.activeWindowLabel,
                tone: Color(qrFocusPet!.colorHex),
                icon: Icons.qr_code_2_rounded,
              ),
              const SizedBox(height: 10),
            ],
            if (socialPendingCount > 0)
              _PriorityRow(
                title: 'Matching y social',
                description:
                    'Hay $socialPendingCount afinidades o intereses que conviene revisar dentro de la bandeja social.',
                pill: 'Social activo',
                tone: _darkAwareTone(context, AppColors.accentSoft),
                icon: Icons.favorite_border_rounded,
              ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                if (latestNotification != null)
                  _InlineActionChip(
                    label: 'Notificaciones',
                    onTap: onOpenNotifications,
                  ),
                if (replyThread != null)
                  _InlineActionChip(label: 'Mensajes', onTap: onOpenMessages),
                if (socialPendingCount > 0)
                  _InlineActionChip(label: 'Social', onTap: onOpenSocial),
                if (onOpenQr != null)
                  _InlineActionChip(label: 'Historial QR', onTap: onOpenQr!),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeEmptyStateCard extends StatelessWidget {
  const _HomeEmptyStateCard({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: _homeText(context),
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountStatusCard extends StatelessWidget {
  const _AccountStatusCard({
    required this.account,
    required this.familyProfile,
  });

  final MascotifyAccount account;
  final FamilyAccountProfile familyProfile;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Cuenta y rol activo',
      subtitle:
          'La home también resume la base de identidad que sostiene todo el ecosistema.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _homeSurfaceAlt(context),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              account.baseSummary,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: _homeText(context),
                height: 1.45,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: familyProfile.capabilities
                .map(
                  (item) => _HeroPill(
                    label: item,
                    color: _darkAwareTone(context, AppColors.primarySoft),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _darkAwareTone(context, AppColors.accentSoft),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              account.linkedProfilesSummary,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: _homeText(context),
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IconButtonBadge extends StatelessWidget {
  const _IconButtonBadge({
    required this.icon,
    required this.badgeCount,
    required this.onTap,
  });

  final IconData icon;
  final int badgeCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _homeSurface(context),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _homeBorder(context)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: SizedBox(
            width: 50,
            height: 50,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Center(child: Icon(icon, color: AppColors.accent)),
                if (badgeCount > 0)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: _homeSurface(context)),
                      ),
                      child: Text(
                        '$badgeCount',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
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

class _HeroPill extends StatelessWidget {
  const _HeroPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _darkAwareTone(context, color),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: _homeBorder(context)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: _homeText(context),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({
    required this.value,
    required this.label,
    required this.tone,
  });

  final String value;
  final String label;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _darkAwareTone(context, tone),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _homeBorder(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: _homeText(context)),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: _homeSecondaryText(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _PriorityRow extends StatelessWidget {
  const _PriorityRow({
    required this.title,
    required this.description,
    required this.pill,
    required this.tone,
    required this.icon,
  });

  final String title;
  final String description;
  final String pill;
  final Color tone;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final darkTone = _darkAwareTone(context, tone);

    Widget buildIcon() {
      return Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: darkTone,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _homeBorder(context)),
        ),
        child: Icon(icon, color: _homeText(context)),
      );
    }

    Widget buildText() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: _homeText(context),
              height: 1.45,
            ),
          ),
        ],
      );
    }

    Widget buildPill() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: _isDarkMode(context)
              ? _homeSurfaceTint(context)
              : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: _homeBorder(context)),
        ),
        child: Text(
          pill,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: _homeText(context),
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _homeSurfaceAlt(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _homeBorder(context)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 320) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildIcon(),
                    const SizedBox(width: 12),
                    Expanded(child: buildText()),
                  ],
                ),
                const SizedBox(height: 12),
                buildPill(),
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildIcon(),
              const SizedBox(width: 12),
              Expanded(child: buildText()),
              const SizedBox(width: 10),
              buildPill(),
            ],
          );
        },
      ),
    );
  }
}

class _InlineActionChip extends StatelessWidget {
  const _InlineActionChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: _homeSurfaceAlt(context),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: _homeBorder(context)),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: _homeText(context),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _EcosystemFeedTile extends StatelessWidget {
  const _EcosystemFeedTile({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.tone,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final String description;
  final Color tone;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final darkTone = _darkAwareTone(context, tone);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _homeSurfaceAlt(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _homeBorder(context)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: darkTone,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _homeBorder(context)),
            ),
            child: Icon(icon, color: _homeText(context)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: _homeSecondaryText(context),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: _homeText(context),
                    height: 1.45,
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

class _OverviewTile extends StatelessWidget {
  const _OverviewTile({
    required this.title,
    required this.value,
    required this.description,
    required this.color,
    required this.icon,
  });

  final String title;
  final String value;
  final String description;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: _homeBorder(context)),
            ),
            child: Icon(icon, size: 20, color: _homeText(context)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium?.copyWith(
                    color: _homeSecondaryText(context),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleMedium?.copyWith(
                    color: _homeText(context),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.copyWith(
                    color: MascotifyPalette.of(context).textMuted,
                    height: 1.25,
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

class _PrimaryAccessCard extends StatelessWidget {
  const _PrimaryAccessCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.tone,
    required this.onTap,
    this.highlight,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color tone;
  final VoidCallback? onTap;
  final String? highlight;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 2.5,
      shadowColor: _isDarkMode(context)
          ? Colors.black.withValues(alpha: 0.22)
          : AppColors.primary.withValues(alpha: 0.16),
      color: _homeSurface(context),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(color: _homeBorder(context)),
      ),
      child: InkWell(
        onTap: onTap,
        child: Opacity(
          opacity: onTap == null ? 0.82 : 1,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: tone,
                    borderRadius: BorderRadius.circular(16),
                    border: _isDarkMode(context)
                        ? Border.all(color: _homeBorder(context))
                        : null,
                  ),
                  child: Icon(icon, color: _homeText(context)),
                ),
                const SizedBox(height: 14),
                Text(title, style: textTheme.titleMedium),
                const SizedBox(height: 6),
                Expanded(
                  child: Text(
                    subtitle,
                    style: textTheme.bodyMedium?.copyWith(
                      color: _homeSecondaryText(context),
                      height: 1.4,
                    ),
                  ),
                ),
                if (highlight != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    highlight!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyMedium?.copyWith(
                      color: _homeText(context),
                      fontWeight: FontWeight.w600,
                      height: 1.35,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

bool _isDarkMode(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark;

Color _darkAwareTone(BuildContext context, Color lightTone) {
  return mascotifyTone(context, lightTone);
}

Color _homeSurface(BuildContext context) =>
    Theme.of(context).colorScheme.surface;

Color _homeSurfaceAlt(BuildContext context) =>
    MascotifyPalette.of(context).surfaceAlt;

Color _homeSurfaceTint(BuildContext context) =>
    MascotifyPalette.of(context).surfaceTint;

Color _homeBorder(BuildContext context) =>
    Theme.of(context).colorScheme.outlineVariant;

Color _homeText(BuildContext context) =>
    Theme.of(context).colorScheme.onSurface;

Color _homeSecondaryText(BuildContext context) =>
    Theme.of(context).colorScheme.onSurfaceVariant;
