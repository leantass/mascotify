import 'package:flutter/material.dart';

import '../../../explore/presentation/screens/professional_public_profile_screen.dart';
import '../../../../shared/data/app_data_source.dart';
import '../../../../shared/models/account_identity_models.dart';
import '../../../../theme/app_colors.dart';

class ProfessionalWorkspaceScreen extends StatelessWidget {
  const ProfessionalWorkspaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = AppData.accountFor(
      AccountExperience.professional,
    ).professionalProfile!;
    final publicPresence = AppData.currentProfessionalProfile;

    return Scaffold(
      body: SafeArea(
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
                    AppColors.primarySoft,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Servicios y operación',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Esta vista ya puede leerse como base de operación profesional: qué ofrecés, cómo se percibe tu ficha y qué tipos de servicio ya quedan asociados a tu cuenta.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (publicPresence != null) ...[
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ProfessionalPublicProfileScreen(
                              professional: publicPresence,
                            ),
                          ),
                        ),
                        child: const Text('Abrir perfil público'),
                      ),
                    ),
                  ],
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
                      'Servicios contemplados',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      publicPresence?.serviceSummary ??
                          'La cuenta profesional ya sostiene servicios básicos, aunque la presencia pública todavía no se publicó.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    ...(publicPresence?.services ?? profile.services).map(
                      (service) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _ServiceCard(
                          service: service,
                          availability: publicPresence?.serviceAvailabilityLabel ??
                              profile.operationLabel,
                        ),
                      ),
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
                      'Contenido + confianza',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'La ficha profesional no vive aislada: contenido, reputación y servicios se alimentan entre sí para construir valor percibido y una base operativa más real.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    if (publicPresence != null)
                      ...publicPresence.trustSignals.map(
                        (signal) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _SignalTile(label: signal),
                        ),
                      ),
                    if (publicPresence == null)
                      const _SignalTile(
                        label:
                            'La cuenta profesional todavía no publicó una presencia pública más completa, pero la base local ya está lista para crecer.',
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

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.service, required this.availability});

  final String service;
  final String availability;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(service, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(
            availability,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 6),
          Text(
            'Base inicial para definir cómo este servicio se presenta, se ordena y puede evolucionar dentro de una presencia profesional más operativa.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _SignalTile extends StatelessWidget {
  const _SignalTile({required this.label});

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
