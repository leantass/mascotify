import 'package:flutter/material.dart';

import '../../../../shared/data/app_data_source.dart';
import '../../../../shared/models/account_identity_models.dart';
import '../../../../shared/widgets/responsive_page_body.dart';
import '../../../../theme/app_colors.dart';
import '../../../explore/presentation/screens/professional_public_profile_screen.dart';

class ProfessionalDashboardScreen extends StatefulWidget {
  const ProfessionalDashboardScreen({super.key});

  @override
  State<ProfessionalDashboardScreen> createState() =>
      _ProfessionalDashboardScreenState();
}

class _ProfessionalDashboardScreenState
    extends State<ProfessionalDashboardScreen> {
  bool _isActivating = false;

  @override
  Widget build(BuildContext context) {
    final account = AppData.accountFor(AccountExperience.professional);
    final profile = account.professionalProfile!;
    final publicPresence = AppData.currentProfessionalProfile;
    final hasPublicPresence = publicPresence != null;

    return Scaffold(
      body: SafeArea(
        child: ResponsivePageBody(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.accentSoft,
                      AppColors.surface,
                      Color(0xFFEAFBFF),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: Color(0xFFCFEFF5)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accentDeep,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'Modo profesional',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      profile.businessName,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      hasPublicPresence
                          ? publicPresence.profileModeLabel
                          : 'Presencia profesional pendiente',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      hasPublicPresence
                          ? publicPresence.helpSummary
                          : 'Tu cuenta profesional ya tiene base local y servicios asociados, pero todavía no expone una presencia pública coherente dentro de Mascotify.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: _MetricTile(
                            label: 'Estado',
                            value: hasPublicPresence
                                ? publicPresence.presenceStatusLabel
                                : 'Pendiente de activar',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _MetricTile(
                            label: 'Servicios',
                            value: hasPublicPresence
                                ? publicPresence.serviceAvailabilityLabel
                                : '${profile.services.length} bases listas',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: hasPublicPresence
                          ? ElevatedButton(
                              style: _publicProfileButtonStyle(),
                              onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ProfessionalPublicProfileScreen(
                                        professional: publicPresence,
                                      ),
                                ),
                              ),
                              child: const Text('Ver perfil público'),
                            )
                          : ElevatedButton(
                              onPressed: _isActivating
                                  ? null
                                  : _activateProfessionalPresence,
                              child: Text(
                                _isActivating
                                    ? 'Activando presencia...'
                                    : 'Activar presencia profesional',
                              ),
                            ),
                    ),
                  ],
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
                        'Base operativa actual',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        account.baseSummary,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      _InfoTile(
                        label: 'Cuenta profesional',
                        value:
                            '${profile.category}. ${profile.operationLabel}. ${profile.primaryGoal}',
                      ),
                      const SizedBox(height: 10),
                      _InfoTile(
                        label: 'Próximo paso',
                        value: hasPublicPresence
                            ? profile.nextSetupStep
                            : 'Activar la presencia profesional para volver visible tu propuesta, tus servicios y una proyección pública coherente con la cuenta.',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (!hasPublicPresence)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Activá tu presencia pública',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'La activación usa la base ya persistida en la cuenta profesional. No crea otra arquitectura: solo vuelve visible tu ficha operativa dentro de la vertical profesional.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 16),
                        ...profile.services.map(
                          (service) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _CapabilityTile(label: service),
                          ),
                        ),
                        const SizedBox(height: 6),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isActivating
                                ? null
                                : _activateProfessionalPresence,
                            child: Text(
                              _isActivating
                                  ? 'Activando presencia...'
                                  : 'Publicar base profesional',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Señales de confianza',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        ...publicPresence.trustSignals.map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _CapabilityTile(label: item),
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

  Future<void> _activateProfessionalPresence() async {
    setState(() {
      _isActivating = true;
    });

    await AppData.activateCurrentProfessionalProfile();
    if (!mounted) return;

    setState(() {
      _isActivating = false;
    });
  }
}

ButtonStyle _publicProfileButtonStyle() {
  return ButtonStyle(
    backgroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        return AppColors.accent.withValues(alpha: 0.46);
      }
      if (states.contains(WidgetState.hovered) ||
          states.contains(WidgetState.focused)) {
        return AppColors.accentDeep;
      }
      return AppColors.accent;
    }),
    foregroundColor: WidgetStateProperty.all(Colors.white),
    overlayColor: WidgetStateProperty.all(Colors.white.withValues(alpha: 0.10)),
    side: WidgetStateProperty.all(const BorderSide(color: AppColors.accent)),
    elevation: WidgetStateProperty.all(0),
    padding: WidgetStateProperty.all(
      const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
    ),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    ),
    textStyle: WidgetStateProperty.all(
      const TextStyle(fontWeight: FontWeight.w700),
    ),
  );
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.22)),
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
          Text(value, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.label, required this.value});

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

class _CapabilityTile extends StatelessWidget {
  const _CapabilityTile({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
