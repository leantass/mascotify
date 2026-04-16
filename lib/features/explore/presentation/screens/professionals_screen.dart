import 'package:flutter/material.dart';

import '../../../../shared/data/app_data_source.dart';
import '../../../../shared/models/professional_models.dart';
import '../../../../theme/app_colors.dart';
import 'professional_content_detail_screen.dart';
import 'professional_public_profile_screen.dart';

class ProfessionalsScreen extends StatelessWidget {
  const ProfessionalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profiles = AppData.professionalProfiles;
    final contents = AppData.professionalLibraryContents;

    return Scaffold(
      appBar: AppBar(title: const Text('Profesionales y contenido')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: [
            _Hero(
              profileCount: profiles.length,
              serviceCount: AppData.professionalServiceSpotlights.length,
              contentCount: contents.length,
            ),
            const SizedBox(height: 16),
            const _DifferenceCard(),
            const SizedBox(height: 16),
            const _CategoriesCard(),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Servicios posibles dentro de Mascotify',
              subtitle:
                  'Una base mock para leer esta vertical también como red de servicios, no solo como feed de contenido.',
              children: AppData.professionalServiceSpotlights
                  .map((item) => _ServiceSpotlightCard(item: item))
                  .toList(),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Perfiles activos',
              subtitle:
                  'Voces expertas, perfiles híbridos y prestadores con señales de confianza y valor más claro.',
              children: profiles
                  .map((profile) => _ProfileCard(profile: profile))
                  .toList(),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Contenido profesional',
              subtitle:
                  'Piezas breves que nacen desde perfiles que también podrían ofrecer orientación o servicios.',
              children: contents
                  .map((content) => _ContentCard(content: content))
                  .toList(),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Recomendado para vos',
              subtitle:
                  'Señales mock que mezclan contenido, criterio profesional y futuras capas de servicio.',
              children: AppData.professionalRecommendations
                  .map(
                    (item) => _RecommendationTile(
                      title: item.title,
                      subtitle: item.subtitle,
                      accentColor: Color(item.accentColorHex),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({
    required this.profileCount,
    required this.serviceCount,
    required this.contentCount,
  });

  final int profileCount;
  final int serviceCount;
  final int contentCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.supportSoft,
            AppColors.surface,
            AppColors.accentSoft,
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.dark,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              'Vertical profesional',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'La comunidad experta ya puede sentirse como red y no solo como contenido.',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 10),
          Text(
            'Esta capa conecta voces expertas, servicios posibles, presencia comercial y señales de confianza para que Mascotify pueda crecer a una vertical profesional real.',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _Metric(
                  label: 'Perfiles',
                  value: '$profileCount activos',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _Metric(
                  label: 'Servicios',
                  value: '$serviceCount bases',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _Metric(
                  label: 'Contenido',
                  value: '$contentCount piezas',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DifferenceCard extends StatelessWidget {
  const _DifferenceCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Dos formas de leer esta comunidad',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 8),
            Text(
              'Mascotify empieza a distinguir entre presencia experta basada en contenido y presencia profesional orientada a servicios o negocio.',
            ),
            SizedBox(height: 16),
            _ModeTile(
              title: 'Experto en contenido',
              subtitle:
                  'Comparte criterio, piezas breves y acompañamiento para entender mejor decisiones de cuidado.',
              color: AppColors.primarySoft,
              icon: Icons.play_circle_outline_rounded,
            ),
            SizedBox(height: 10),
            _ModeTile(
              title: 'Profesional o prestador de servicios',
              subtitle:
                  'Suma presencia comercial, posibles servicios y señales de confianza para una futura capa operativa.',
              color: AppColors.accentSoft,
              icon: Icons.storefront_outlined,
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoriesCard extends StatelessWidget {
  const _CategoriesCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Categorías de entrada',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Etiquetas iniciales para navegar voces expertas, áreas de criterio y futuras capas de servicio.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: AppData.professionalSpecialties
                  .map(
                    (item) => _Pill(label: item, color: AppColors.surfaceAlt),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.children,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;

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
            ...children.map(
              (child) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceSpotlightCard extends StatelessWidget {
  const _ServiceSpotlightCard({required this.item});

  final ProfessionalServiceSpotlight item;

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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Color(item.accentColorHex),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.storefront_rounded, color: AppColors.dark),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Pill(label: item.availabilityLabel, color: Colors.white),
                const SizedBox(height: 10),
                Text(
                  item.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  item.subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
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

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.profile});

  final ProfessionalProfile profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: Color(profile.accentColorHex),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.verified_rounded,
                  color: AppColors.dark,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      profile.specialty,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _Pill(label: profile.profileModeLabel, color: Colors.white),
              _Pill(
                label: profile.presenceStatusLabel,
                color: AppColors.primarySoft,
              ),
              _Pill(
                label: profile.serviceAvailabilityLabel,
                color: Color(profile.accentColorHex),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            profile.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            profile.serviceSummary,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: profile.trustSignals
                .map((item) => _Pill(label: item, color: AppColors.surface))
                .toList(),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ProfessionalPublicProfileScreen(
                        professional: profile,
                      ),
                    ),
                  ),
                  child: const Text('Ver perfil'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ProfessionalContentDetailScreen(
                        professional: profile,
                        content: profile.featuredContent.first,
                      ),
                    ),
                  ),
                  child: Text(profile.secondaryActionLabel),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _showMockDialog(
                    context,
                    title: profile.primaryActionLabel,
                    message:
                        'Esta interacción mock representa cómo ${profile.name} podría evolucionar a una relación más útil dentro de Mascotify.',
                  ),
                  child: Text(profile.primaryActionLabel),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContentCard extends StatelessWidget {
  const _ContentCard({required this.content});

  final ProfessionalLibraryContent content;

  @override
  Widget build(BuildContext context) {
    final professional = AppData.findProfessionalByName(content.professional)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.surfaceAlt, AppColors.surface],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _Pill(label: content.category, color: AppColors.accentSoft),
              _Pill(label: content.duration, color: AppColors.primarySoft),
              _Pill(label: professional.profileModeLabel, color: Colors.white),
            ],
          ),
          const SizedBox(height: 12),
          Text(content.title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(
            content.professional,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 10),
          Text(
            content.summary,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            professional.serviceSummary,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ProfessionalContentDetailScreen(
                        professional: professional,
                        content: ProfessionalContentPreview(
                          title: content.title,
                          category: content.category,
                          duration: content.duration,
                          summary: content.summary,
                        ),
                      ),
                    ),
                  ),
                  child: const Text('Ver contenido'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ProfessionalPublicProfileScreen(
                        professional: professional,
                      ),
                    ),
                  ),
                  child: const Text('Ver perfil'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RecommendationTile extends StatelessWidget {
  const _RecommendationTile({
    required this.title,
    required this.subtitle,
    required this.accentColor,
  });

  final String title;
  final String subtitle;
  final Color accentColor;

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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: AppColors.dark,
            ),
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
                    color: AppColors.textPrimary,
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

Future<void> _showMockDialog(
  BuildContext context, {
  required String title,
  required String message,
}) async {
  await showDialog<void>(
    context: context,
    builder: (context) {
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: AppColors.accentSoft,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.storefront_rounded,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Text(title, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text(message, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceAlt,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  'Este flujo es mock y representa cómo la comunidad experta puede crecer a relaciones más útiles, orientación y servicios dentro de Mascotify.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Entendido'),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _ModeTile extends StatelessWidget {
  const _ModeTile({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;

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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppColors.textPrimary),
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
                    color: AppColors.textPrimary,
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

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(22),
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

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
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
