import 'package:flutter/material.dart';

import '../../../../features/auth/presentation/auth_session_controller.dart';
import '../../../../shared/models/account_identity_models.dart';
import '../../../../shared/widgets/profile_option_tile.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../theme/app_colors.dart';
import '../../../../shared/data/app_data_source.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, this.experience = AccountExperience.family});

  final AccountExperience experience;

  @override
  Widget build(BuildContext context) {
    final auth = AuthScope.of(context);
    final user = auth.currentUser!;
    final account = auth.accountFor(experience);
    final familyProfile = account.familyProfile;
    final professionalProfile = account.professionalProfile;
    final isFamily = experience == AccountExperience.family;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isFamily
                      ? const [AppColors.surface, AppColors.primarySoft]
                      : const [AppColors.surface, AppColors.accentSoft],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: AppColors.border),
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
                        label: 'Categoria',
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
                      'Si la cuenta ya soporta mas de un rol, el perfil activo se guarda y se recupera en la proxima sesion.',
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
                              isActive: item == experience,
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
                  'La base actual ya admite sesion persistida, roles y futuras capas de seguridad.',
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
            ...AppData.profileOptions.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ProfileOptionTile(item: item),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: SwitchListTile(
                value: user.notificationsEnabled,
                onChanged: (_) {},
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                activeThumbColor: AppColors.accent,
                activeTrackColor: AppColors.accentSoft,
                title: const Text('Notificaciones estrategicas'),
                subtitle: const Text(
                  'Placeholder de preferencias para una etapa posterior mas configurable.',
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
                      'Sesion',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tu autenticacion actual se persiste localmente. Logout limpia la sesion activa pero mantiene las cuentas registradas en este dispositivo.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: auth.isBusy ? null : () => auth.logout(),
                        icon: const Icon(Icons.logout_rounded),
                        label: Text(
                          auth.isBusy ? 'Cerrando sesion...' : 'Cerrar sesion',
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
    );
  }
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
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textMuted,
            ),
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
