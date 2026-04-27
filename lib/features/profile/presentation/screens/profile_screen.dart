import 'package:flutter/material.dart';

import '../../../../features/auth/presentation/auth_session_controller.dart';
import '../../../../shared/data/app_data_source.dart';
import '../../../../shared/models/account_identity_models.dart';
import '../../../../shared/models/app_user.dart';
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
                child: Row(
                  children: [
                    Container(
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
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            account.ownerName,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            account.email,
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
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: AppColors.accentDeep,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
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

class _PreferencesAndPlanCard extends StatelessWidget {
  const _PreferencesAndPlanCard({
    required this.user,
    required this.isBusy,
    required this.onPlanChanged,
    required this.onNotificationsChanged,
    required this.onPrivacyChanged,
    required this.onSecurityChanged,
    required this.onStrategicNotificationsChanged,
    required this.onAccountSettingsRequested,
  });

  final AppUser user;
  final bool isBusy;
  final ValueChanged<String> onPlanChanged;
  final ValueChanged<bool> onNotificationsChanged;
  final ValueChanged<String> onPrivacyChanged;
  final ValueChanged<String> onSecurityChanged;
  final ValueChanged<bool> onStrategicNotificationsChanged;
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
                            onStrategicNotificationsChanged:
                                onStrategicNotificationsChanged,
                          ),
                          _ConfigurationTab(
                            user: user,
                            isBusy: isBusy,
                            onPrivacyChanged: onPrivacyChanged,
                            onSecurityChanged: onSecurityChanged,
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
    return Column(
      children: [
        _SettingsDropdown(
          title: 'Plan actual',
          subtitle: 'Ver o cambiar el plan asociado a esta cuenta.',
          icon: Icons.workspace_premium_outlined,
          value: user.planName,
          options: const ['Mascotify Free', 'Mascotify Plus', 'Mascotify Pro'],
          onChanged: isBusy ? null : onPlanChanged,
        ),
        const SizedBox(height: 14),
        _SettingsInfo(
          title: 'Gestión de suscripción',
          subtitle:
              'El plan se guarda en la cuenta local activa. Cuando conectes billing real, este cambio debe viajar al proveedor de pagos o backend.',
          icon: Icons.receipt_long_outlined,
        ),
      ],
    );
  }
}

class _NotificationsTab extends StatelessWidget {
  const _NotificationsTab({
    required this.user,
    required this.isBusy,
    required this.onNotificationsChanged,
    required this.onStrategicNotificationsChanged,
  });

  final AppUser user;
  final bool isBusy;
  final ValueChanged<bool> onNotificationsChanged;
  final ValueChanged<bool> onStrategicNotificationsChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SettingsSwitch(
          title: 'Notificaciones',
          subtitle: 'Activa o pausa las alertas generales de la cuenta.',
          icon: Icons.notifications_none_rounded,
          value: user.notificationsEnabled,
          onChanged: isBusy ? null : onNotificationsChanged,
        ),
        const SizedBox(height: 14),
        _SettingsSwitch(
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
    required this.onAccountSettingsRequested,
  });

  final AppUser user;
  final bool isBusy;
  final ValueChanged<String> onPrivacyChanged;
  final ValueChanged<String> onSecurityChanged;
  final VoidCallback onAccountSettingsRequested;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.options,
    required this.onChanged,
  });

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
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

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
