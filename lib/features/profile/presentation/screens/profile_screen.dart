import 'package:flutter/material.dart';

import '../../../../features/auth/presentation/auth_session_controller.dart';
import '../../../../core/app_environment.dart';
import '../../../../core/localization/app_locale_controller.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../shared/data/app_data_source.dart';
import '../../../../shared/models/account_identity_models.dart';
import '../../../../shared/models/app_user.dart';
import '../../../../shared/models/plan_entitlements.dart';
import '../../../../shared/widgets/responsive_page_body.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../theme/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, this.experience = AccountExperience.family});

  final AccountExperience experience;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = AuthScope.of(context);
    final user = AppData.currentUser;
    final account = AppData.accountFor(widget.experience);
    final familyProfile = account.familyProfile;
    final professionalProfile = account.professionalProfile;
    final isFamily = widget.experience == AccountExperience.family;

    return Scaffold(
      body: SafeArea(
        child: ResponsivePageBody(
          child: ListView(
            cacheExtent: 5000,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isFamily
                        ? const [AppColors.surface, AppColors.primarySoft]
                        : const [
                            AppColors.accentSoft,
                            AppColors.surface,
                            Color(0xFFEAFBFF),
                          ],
                    begin: isFamily ? Alignment.topLeft : Alignment.centerLeft,
                    end: isFamily
                        ? Alignment.bottomRight
                        : Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: isFamily
                        ? AppColors.border
                        : const Color(0xFFCFEFF5),
                  ),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final avatar = Container(
                      width: 74,
                      height: 74,
                      decoration: BoxDecoration(
                        color: AppColors.dark,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Icon(
                        isFamily
                            ? Icons.person_rounded
                            : Icons.storefront_rounded,
                        size: 34,
                        color: Colors.white,
                      ),
                    );
                    final accountSummary = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          account.ownerName,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          account.email,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accentSoft,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            isFamily
                                ? 'Modo familia - ${account.city}'
                                : 'Modo profesional - ${account.city}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: AppColors.accentDeep,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                      ],
                    );

                    if (constraints.maxWidth < 340) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          avatar,
                          const SizedBox(height: 14),
                          accountSummary,
                        ],
                      );
                    }

                    return Row(
                      children: [
                        avatar,
                        const SizedBox(width: 16),
                        Expanded(child: accountSummary),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              const _RuntimeModeNotice(),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cuenta base',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        account.baseSummary,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      _AccountInfoTile(
                        label: 'Miembro desde',
                        value: account.memberSince,
                      ),
                      const SizedBox(height: 10),
                      _AccountInfoTile(
                        label: 'Escalabilidad futura',
                        value: account.linkedProfilesSummary,
                      ),
                      const SizedBox(height: 10),
                      _AccountInfoTile(
                        label: 'Plan activo',
                        value: account.planName,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Perfil activo',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      if (isFamily && familyProfile != null) ...[
                        _AccountInfoTile(
                          label: 'Hogar',
                          value: familyProfile.householdName,
                        ),
                        const SizedBox(height: 10),
                        _AccountInfoTile(
                          label: 'Mascotas',
                          value: familyProfile.petsSummaryLabel,
                        ),
                        const SizedBox(height: 10),
                        _AccountInfoTile(
                          label: 'Objetivo actual',
                          value: familyProfile.primaryGoal,
                        ),
                        const SizedBox(height: 10),
                        _AccountInfoTile(
                          label: 'Siguiente paso',
                          value: familyProfile.nextSetupStep,
                        ),
                      ],
                      if (!isFamily && professionalProfile != null) ...[
                        _AccountInfoTile(
                          label: 'Negocio',
                          value: professionalProfile.businessName,
                        ),
                        const SizedBox(height: 10),
                        _AccountInfoTile(
                          label: 'Categoría',
                          value: professionalProfile.category,
                        ),
                        const SizedBox(height: 10),
                        _AccountInfoTile(
                          label: 'Objetivo actual',
                          value: professionalProfile.primaryGoal,
                        ),
                        const SizedBox(height: 10),
                        _AccountInfoTile(
                          label: 'Siguiente paso',
                          value: professionalProfile.nextSetupStep,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Perfiles disponibles',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Si la cuenta ya soporta más de un rol, el perfil activo se guarda y se recupera en la próxima sesión.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: auth.availableExperiences
                            .map(
                              (item) => _ModeChip(
                                label: item == AccountExperience.family
                                    ? 'Familia'
                                    : 'Profesional',
                                isActive: item == widget.experience,
                                onTap: auth.isBusy
                                    ? null
                                    : () => auth.switchExperience(item),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SectionHeader(
                eyebrow: 'Cuenta Mascotify',
                title: 'Preferencias y plan',
                subtitle:
                    'La base local ya guarda sesión, mascotas y una preferencia mínima por cuenta.',
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.supportSoft,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    user.planName,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _PreferencesAndPlanCard(
                user: user,
                isBusy: auth.isBusy,
                onPlanChanged: (value) => _updatePreference(
                  AppData.setPlanName(value),
                  'Plan actualizado a $value.',
                ),
                onNotificationsChanged: (value) => _updatePreference(
                  AppData.setNotificationsEnabled(value),
                  value
                      ? 'Notificaciones activadas.'
                      : 'Notificaciones desactivadas.',
                ),
                onMessagesNotificationsChanged: (value) => _updatePreference(
                  AppData.setMessagesNotificationsEnabled(value),
                  value
                      ? 'Notificaciones de mensajes activadas.'
                      : 'Notificaciones de mensajes desactivadas.',
                ),
                onPetActivityNotificationsChanged: (value) => _updatePreference(
                  AppData.setPetActivityNotificationsEnabled(value),
                  value
                      ? 'Avisos de mascotas activados.'
                      : 'Avisos de mascotas desactivados.',
                ),
                onEcosystemUpdatesNotificationsChanged: (value) =>
                    _updatePreference(
                      AppData.setEcosystemUpdatesNotificationsEnabled(value),
                      value
                          ? 'Novedades del ecosistema activadas.'
                          : 'Novedades del ecosistema desactivadas.',
                    ),
                onPrivacyChanged: (value) => _updatePreference(
                  AppData.setPrivacyLevel(value),
                  'Privacidad actualizada a $value.',
                ),
                onSecurityChanged: (value) => _updatePreference(
                  AppData.setSecurityLevel(value),
                  'Seguridad actualizada a $value.',
                ),
                onStrategicNotificationsChanged: (value) => _updatePreference(
                  AppData.setStrategicNotificationsEnabled(value),
                  value
                      ? 'Notificaciones estratégicas activadas.'
                      : 'Notificaciones estratégicas desactivadas.',
                ),
                onPublicProfileChanged: (value) => _updatePreference(
                  AppData.setPublicProfileEnabled(value),
                  value
                      ? 'Presencia pública activada.'
                      : 'Presencia pública desactivada.',
                ),
                onShowBasicInfoChanged: (value) => _updatePreference(
                  AppData.setShowBasicInfoOnPublicProfile(value),
                  value ? 'Datos básicos visibles.' : 'Datos básicos ocultos.',
                ),
                onEcosystemSuggestionsChanged: (value) => _updatePreference(
                  AppData.setEcosystemSuggestionsEnabled(value),
                  value
                      ? 'Sugerencias del ecosistema activadas.'
                      : 'Sugerencias del ecosistema desactivadas.',
                ),
                onAccountSettingsRequested: _showAccountSettingsNotice,
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sesión',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tu autenticación actual se persiste localmente. Logout limpia la sesión activa pero mantiene las cuentas registradas en este dispositivo.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: auth.isBusy ? null : () => auth.logout(),
                          icon: const Icon(Icons.logout_rounded),
                          label: Text(
                            auth.isBusy
                                ? 'Cerrando sesión...'
                                : 'Cerrar sesión',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updatePreference(Future<void> update, String message) async {
    await update;
    if (!mounted) return;
    setState(() {});
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showAccountSettingsNotice() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'El cambio de email o contraseña debe conectarse al proveedor de autenticación final.',
        ),
      ),
    );
  }
}

class _RuntimeModeNotice extends StatelessWidget {
  const _RuntimeModeNotice();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final icon = Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.supportSoft,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.info_outline_rounded,
                color: AppColors.primaryDeep,
              ),
            );
            final text = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppEnvironment.runtimeLabel,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  '${AppEnvironment.runtimeShortDescription} ${AppEnvironment.productionReadinessLabel}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            );

            if (constraints.maxWidth < 320) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [icon, const SizedBox(height: 12), text],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                icon,
                const SizedBox(width: 14),
                Expanded(child: text),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PreferencesAndPlanCard extends StatelessWidget {
  const _PreferencesAndPlanCard({
    required this.user,
    required this.isBusy,
    required this.onPlanChanged,
    required this.onNotificationsChanged,
    required this.onMessagesNotificationsChanged,
    required this.onPetActivityNotificationsChanged,
    required this.onEcosystemUpdatesNotificationsChanged,
    required this.onPrivacyChanged,
    required this.onSecurityChanged,
    required this.onStrategicNotificationsChanged,
    required this.onPublicProfileChanged,
    required this.onShowBasicInfoChanged,
    required this.onEcosystemSuggestionsChanged,
    required this.onAccountSettingsRequested,
  });

  final AppUser user;
  final bool isBusy;
  final ValueChanged<String> onPlanChanged;
  final ValueChanged<bool> onNotificationsChanged;
  final ValueChanged<bool> onMessagesNotificationsChanged;
  final ValueChanged<bool> onPetActivityNotificationsChanged;
  final ValueChanged<bool> onEcosystemUpdatesNotificationsChanged;
  final ValueChanged<String> onPrivacyChanged;
  final ValueChanged<String> onSecurityChanged;
  final ValueChanged<bool> onStrategicNotificationsChanged;
  final ValueChanged<bool> onPublicProfileChanged;
  final ValueChanged<bool> onShowBasicInfoChanged;
  final ValueChanged<bool> onEcosystemSuggestionsChanged;
  final VoidCallback onAccountSettingsRequested;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Builder(
            builder: (context) {
              final tabController = DefaultTabController.of(context);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TabBar(
                    controller: tabController,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    labelColor: AppColors.primaryDeep,
                    unselectedLabelColor: AppColors.textSecondary,
                    indicatorColor: AppColors.primary,
                    tabs: const [
                      Tab(text: 'Suscripción'),
                      Tab(text: 'Notificaciones'),
                      Tab(text: 'Configuración'),
                    ],
                  ),
                  const SizedBox(height: 18),
                  AnimatedBuilder(
                    animation: tabController,
                    builder: (context, _) {
                      return IndexedStack(
                        index: tabController.index,
                        children: [
                          _SubscriptionTab(
                            user: user,
                            isBusy: isBusy,
                            onPlanChanged: onPlanChanged,
                          ),
                          _NotificationsTab(
                            user: user,
                            isBusy: isBusy,
                            onNotificationsChanged: onNotificationsChanged,
                            onMessagesNotificationsChanged:
                                onMessagesNotificationsChanged,
                            onPetActivityNotificationsChanged:
                                onPetActivityNotificationsChanged,
                            onEcosystemUpdatesNotificationsChanged:
                                onEcosystemUpdatesNotificationsChanged,
                            onStrategicNotificationsChanged:
                                onStrategicNotificationsChanged,
                          ),
                          _ConfigurationTab(
                            user: user,
                            isBusy: isBusy,
                            onPrivacyChanged: onPrivacyChanged,
                            onSecurityChanged: onSecurityChanged,
                            onPublicProfileChanged: onPublicProfileChanged,
                            onShowBasicInfoChanged: onShowBasicInfoChanged,
                            onEcosystemSuggestionsChanged:
                                onEcosystemSuggestionsChanged,
                            onAccountSettingsRequested:
                                onAccountSettingsRequested,
                          ),
                        ],
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SubscriptionTab extends StatelessWidget {
  const _SubscriptionTab({
    required this.user,
    required this.isBusy,
    required this.onPlanChanged,
  });

  final AppUser user;
  final bool isBusy;
  final ValueChanged<String> onPlanChanged;

  @override
  Widget build(BuildContext context) {
    final selectedEntitlement = planEntitlementFor(user.planName);

    return Column(
      children: [
        _SettingsDropdown(
          fieldKey: const ValueKey('subscription-plan-dropdown'),
          title: 'Plan actual',
          subtitle: 'Ver o cambiar el plan asociado a esta cuenta.',
          icon: Icons.workspace_premium_outlined,
          value: user.planName,
          options: planEntitlements
              .map((entitlement) => entitlement.planName)
              .toList(growable: false),
          onChanged: isBusy ? null : onPlanChanged,
        ),
        const SizedBox(height: 14),
        _PlanCatalog(currentPlanName: selectedEntitlement.planName),
        const SizedBox(height: 14),
        _SettingsInfo(
          title: 'Gestión de suscripción',
          subtitle:
              'El plan se guarda en la cuenta local activa. Las suscripciones reales todavia no estan activadas en esta build.',
          icon: Icons.receipt_long_outlined,
        ),
      ],
    );
  }
}

class _PlanCatalog extends StatelessWidget {
  const _PlanCatalog({required this.currentPlanName});

  final String currentPlanName;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cards = planEntitlements
            .map(
              (entitlement) => _PlanCatalogCard(
                entitlement: entitlement,
                isCurrent: entitlement.planName == currentPlanName,
              ),
            )
            .toList(growable: false);

        if (constraints.maxWidth < 720) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final card in cards) ...[card, const SizedBox(height: 10)],
            ],
          );
        }

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final card in cards) ...[
                Expanded(child: card),
                if (card != cards.last) const SizedBox(width: 10),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _PlanCatalogCard extends StatelessWidget {
  const _PlanCatalogCard({required this.entitlement, required this.isCurrent});

  final PlanEntitlement entitlement;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final borderColor = isCurrent ? AppColors.primary : AppColors.border;
    final backgroundColor = isCurrent
        ? AppColors.primarySoft
        : AppColors.surfaceAlt;

    return Container(
      key: ValueKey('plan-card-${entitlement.shortName.toLowerCase()}'),
      constraints: const BoxConstraints(minHeight: 176),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: isCurrent ? 1.4 : 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  entitlement.shortName,
                  style: theme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (isCurrent)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    'Actual',
                    style: theme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            entitlement.priceLabel,
            style: theme.titleMedium?.copyWith(
              color: AppColors.primaryDeep,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            entitlement.petLimitDisplayLabel,
            style: theme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            entitlement.positioningLabel,
            style: theme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            entitlement.adsLabel,
            style: theme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationsTab extends StatelessWidget {
  const _NotificationsTab({
    required this.user,
    required this.isBusy,
    required this.onNotificationsChanged,
    required this.onMessagesNotificationsChanged,
    required this.onPetActivityNotificationsChanged,
    required this.onEcosystemUpdatesNotificationsChanged,
    required this.onStrategicNotificationsChanged,
  });

  final AppUser user;
  final bool isBusy;
  final ValueChanged<bool> onNotificationsChanged;
  final ValueChanged<bool> onMessagesNotificationsChanged;
  final ValueChanged<bool> onPetActivityNotificationsChanged;
  final ValueChanged<bool> onEcosystemUpdatesNotificationsChanged;
  final ValueChanged<bool> onStrategicNotificationsChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SettingsSwitch(
          switchKey: const ValueKey('notifications-general-switch'),
          title: 'Notificaciones generales',
          subtitle: 'Activa o pausa la capa local de alertas de la cuenta.',
          icon: Icons.notifications_none_rounded,
          value: user.notificationsEnabled,
          onChanged: isBusy ? null : onNotificationsChanged,
        ),
        const SizedBox(height: 14),
        _SettingsSwitch(
          switchKey: const ValueKey('notifications-messages-switch'),
          title: 'Notificaciones de mensajes',
          subtitle: 'Recibe avisos locales cuando haya conversaciones nuevas.',
          icon: Icons.mark_chat_unread_outlined,
          value: user.messagesNotificationsEnabled,
          onChanged: isBusy ? null : onMessagesNotificationsChanged,
        ),
        const SizedBox(height: 14),
        _SettingsSwitch(
          switchKey: const ValueKey('notifications-pet-activity-switch'),
          title: 'Avisos de mascotas y QR',
          subtitle:
              'Mantiene visibles señales locales sobre actividad, QR y seguimiento.',
          icon: Icons.pets_outlined,
          value: user.petActivityNotificationsEnabled,
          onChanged: isBusy ? null : onPetActivityNotificationsChanged,
        ),
        const SizedBox(height: 14),
        _SettingsSwitch(
          switchKey: const ValueKey('notifications-ecosystem-updates-switch'),
          title: 'Recomendaciones y novedades',
          subtitle:
              'Habilita recomendaciones locales y novedades del ecosistema.',
          icon: Icons.auto_awesome_outlined,
          value: user.ecosystemUpdatesNotificationsEnabled,
          onChanged: isBusy ? null : onEcosystemUpdatesNotificationsChanged,
        ),
        const SizedBox(height: 14),
        _SettingsSwitch(
          switchKey: const ValueKey('notifications-strategic-switch'),
          title: 'Notificaciones estratégicas',
          subtitle:
              'Recibe señales recomendadas sobre actividad, QR y oportunidades relevantes.',
          icon: Icons.auto_awesome_outlined,
          value: user.strategicNotificationsEnabled,
          onChanged: isBusy ? null : onStrategicNotificationsChanged,
        ),
      ],
    );
  }
}

class _ConfigurationTab extends StatelessWidget {
  const _ConfigurationTab({
    required this.user,
    required this.isBusy,
    required this.onPrivacyChanged,
    required this.onSecurityChanged,
    required this.onPublicProfileChanged,
    required this.onShowBasicInfoChanged,
    required this.onEcosystemSuggestionsChanged,
    required this.onAccountSettingsRequested,
  });

  final AppUser user;
  final bool isBusy;
  final ValueChanged<String> onPrivacyChanged;
  final ValueChanged<String> onSecurityChanged;
  final ValueChanged<bool> onPublicProfileChanged;
  final ValueChanged<bool> onShowBasicInfoChanged;
  final ValueChanged<bool> onEcosystemSuggestionsChanged;
  final VoidCallback onAccountSettingsRequested;

  @override
  Widget build(BuildContext context) {
    final localeController = AppLocaleScope.maybeOf(context);
    final localizations = AppLocalizations.of(context);
    final languageOptions = <String>[
      localizations.automaticLanguage,
      AppLocalizations.languageName('es'),
      AppLocalizations.languageName('en'),
      AppLocalizations.languageName('pt'),
    ];
    final currentLanguageValue = localeController?.manualLanguageCode == null
        ? localizations.automaticLanguage
        : AppLocalizations.languageName(localeController!.manualLanguageCode);

    return Column(
      children: [
        _SettingsDropdown(
          fieldKey: const ValueKey('language-preference-dropdown'),
          title: localizations.languageSettingTitle,
          subtitle:
              '${localizations.languageSettingSubtitle} ${localizations.unsupportedLocaleFallback}',
          icon: Icons.language_rounded,
          value: currentLanguageValue,
          options: languageOptions,
          onChanged: isBusy || localeController == null
              ? null
              : (value) async {
                  final languageCode = switch (value) {
                    'English' => 'en',
                    'Português' => 'pt',
                    'Español' => 'es',
                    _ => null,
                  };
                  await localeController.setManualLanguageCode(languageCode);
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(localizations.languageUpdated)),
                  );
                },
        ),
        const SizedBox(height: 14),
        _SettingsInfo(
          title: localizations.currentLanguageLabel,
          subtitle:
              localeController?.labelFor(
                WidgetsBinding.instance.platformDispatcher.locale,
              ) ??
              localizations.automaticLanguage,
          icon: Icons.translate_rounded,
        ),
        const SizedBox(height: 14),
        _SettingsDropdown(
          title: 'Privacidad',
          subtitle: 'Define cuánta visibilidad tendrán tus perfiles.',
          icon: Icons.lock_outline_rounded,
          value: user.privacyLevel,
          options: const ['Privada', 'Equilibrada', 'Visible'],
          onChanged: isBusy ? null : onPrivacyChanged,
        ),
        const SizedBox(height: 14),
        _SettingsDropdown(
          title: 'Seguridad',
          subtitle: 'Ajusta el nivel de control para acciones sensibles.',
          icon: Icons.shield_outlined,
          value: user.securityLevel,
          options: const ['Básica', 'Estándar', 'Alta'],
          onChanged: isBusy ? null : onSecurityChanged,
        ),
        const SizedBox(height: 14),
        _SettingsSwitch(
          switchKey: const ValueKey('config-public-profile-switch'),
          title: 'Perfil visible',
          subtitle: 'Activa la presencia pública local de la cuenta.',
          icon: Icons.visibility_outlined,
          value: user.publicProfileEnabled,
          onChanged: isBusy ? null : onPublicProfileChanged,
        ),
        const SizedBox(height: 14),
        _SettingsSwitch(
          switchKey: const ValueKey('config-basic-info-switch'),
          title: 'Datos básicos en perfil público',
          subtitle: 'Permite mostrar nombre, ciudad y plan dentro del perfil.',
          icon: Icons.badge_outlined,
          value: user.showBasicInfoOnPublicProfile,
          onChanged: isBusy ? null : onShowBasicInfoChanged,
        ),
        const SizedBox(height: 14),
        _SettingsSwitch(
          switchKey: const ValueKey('config-ecosystem-suggestions-switch'),
          title: 'Sugerencias del ecosistema',
          subtitle:
              'Recibe sugerencias locales para completar o mejorar la experiencia.',
          icon: Icons.tips_and_updates_outlined,
          value: user.ecosystemSuggestionsEnabled,
          onChanged: isBusy ? null : onEcosystemSuggestionsChanged,
        ),
        const SizedBox(height: 14),
        _SettingsAction(
          title: 'Correo electrónico',
          subtitle: user.email,
          icon: Icons.alternate_email_rounded,
          label: 'Modificar',
          onPressed: isBusy ? null : onAccountSettingsRequested,
        ),
        const SizedBox(height: 14),
        _SettingsAction(
          title: 'Contraseña',
          subtitle: 'Gestioná el acceso seguro de la cuenta.',
          icon: Icons.password_rounded,
          label: 'Cambiar',
          onPressed: isBusy ? null : onAccountSettingsRequested,
        ),
      ],
    );
  }
}

class _SettingsDropdown extends StatelessWidget {
  const _SettingsDropdown({
    this.fieldKey,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final Key? fieldKey;
  final String title;
  final String subtitle;
  final IconData icon;
  final String value;
  final List<String> options;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return _SettingsShell(
      title: title,
      subtitle: subtitle,
      icon: icon,
      trailing: SizedBox(
        width: 210,
        child: DropdownButtonFormField<String>(
          key: fieldKey,
          initialValue: options.contains(value) ? value : options.first,
          isExpanded: true,
          decoration: _fieldDecoration(),
          items: options
              .map(
                (option) => DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                ),
              )
              .toList(),
          onChanged: onChanged == null
              ? null
              : (value) {
                  if (value != null) {
                    onChanged!(value);
                  }
                },
        ),
      ),
    );
  }
}

class _SettingsSwitch extends StatelessWidget {
  const _SettingsSwitch({
    this.switchKey,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  final Key? switchKey;
  final String title;
  final String subtitle;
  final IconData icon;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return _SettingsShell(
      title: title,
      subtitle: subtitle,
      icon: icon,
      trailing: Switch(
        key: switchKey,
        value: value,
        onChanged: onChanged,
        activeThumbColor: AppColors.accent,
        activeTrackColor: AppColors.accentSoft,
      ),
    );
  }
}

class _SettingsInfo extends StatelessWidget {
  const _SettingsInfo({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return _SettingsShell(
      title: title,
      subtitle: subtitle,
      icon: icon,
      trailing: const Icon(
        Icons.check_circle_outline_rounded,
        color: AppColors.primaryDeep,
      ),
    );
  }
}

class _SettingsAction extends StatelessWidget {
  const _SettingsAction({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return _SettingsShell(
      title: title,
      subtitle: subtitle,
      icon: icon,
      trailing: OutlinedButton(onPressed: onPressed, child: Text(label)),
    );
  }
}

class _SettingsShell extends StatelessWidget {
  const _SettingsShell({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.trailing,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final useStackedLayout = constraints.maxWidth < 560;
          final content = Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.surfaceTint,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: AppColors.primaryDeep),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );

          if (useStackedLayout) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                content,
                const SizedBox(height: 12),
                Align(alignment: Alignment.centerLeft, child: trailing),
              ],
            );
          }

          return Row(
            children: [
              Expanded(child: content),
              const SizedBox(width: 16),
              trailing,
            ],
          );
        },
      ),
    );
  }
}

InputDecoration _fieldDecoration() {
  return InputDecoration(
    filled: true,
    fillColor: AppColors.surface,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  );
}

class _AccountInfoTile extends StatelessWidget {
  const _AccountInfoTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeChip extends StatelessWidget {
  const _ModeChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? AppColors.accentSoft : AppColors.surfaceAlt,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.border),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
