import 'package:flutter/material.dart';

import '../../../../shared/data/app_data_source.dart';
import '../../../../shared/models/account_identity_models.dart';
import '../../../../shared/widgets/profile_option_tile.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../theme/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, this.experience = AccountExperience.family});

  final AccountExperience experience;

  @override
  Widget build(BuildContext context) {
    final user = AppData.currentUser;
    final account = AppData.accountFor(experience);
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
                                ? 'Modo familia • ${account.city}'
                                : 'Modo profesional • ${account.city}',
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
                      label: 'Plan mock',
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
                      'Perfiles previstos por cuenta',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: account.availableExperiences
                          .map(
                            (item) => _ModeChip(
                              label: item == AccountExperience.family
                                  ? 'Familia'
                                  : 'Profesional',
                              isActive: item == experience,
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
                  'Controles listos para seguridad, suscripción y ajustes.',
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
                title: const Text('Notificaciones estratégicas'),
                subtitle: const Text(
                  'Simulación de preferencias para futuras alertas, seguridad y actividad.',
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
  const _ModeChip({required this.label, required this.isActive});

  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
