import 'package:flutter/material.dart';

import '../../../../shared/data/app_data_source.dart';
import '../../../../shared/models/professional_models.dart';
import '../../../../shared/widgets/responsive_page_body.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_theme.dart';
import '../../../profile/presentation/screens/help_screen.dart';
import '../../../profile/presentation/widgets/contextual_help_link.dart';

class ProfessionalsScreen extends StatelessWidget {
  const ProfessionalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profiles = AppData.professionalProfiles.take(3).toList();
    final services = AppData.professionalServiceSpotlights.take(3).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Profesionales pet beta')),
      body: SafeArea(
        child: ResponsivePageBody(
          maxWidth: 980,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            children: [
              const _BetaHero(),
              const SizedBox(height: 16),
              _PreviewSection(
                title: 'Vista previa',
                subtitle:
                    'Ideas de servicios futuros. No son formularios ni reservas reales.',
                children: services
                    .map((service) => _ServicePreviewCard(item: service))
                    .toList(),
              ),
              const SizedBox(height: 16),
              _PreviewSection(
                title: 'Perfiles demo',
                subtitle:
                    'Ejemplos visuales para entender la direccion del producto.',
                children: profiles
                    .map((profile) => _ProfilePreviewCard(profile: profile))
                    .toList(),
              ),
              const SizedBox(height: 16),
              const _LockedActionsCard(),
              const SizedBox(height: 16),
              const ContextualHelpLink(
                topic: HelpTopic.professionals,
                label: 'Ver ayuda sobre Profesionales beta',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BetaHero extends StatelessWidget {
  const _BetaHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            mascotifyTone(context, AppColors.supportSoft),
            mascotifySurface(context),
            mascotifyTone(context, AppColors.accentSoft),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: mascotifyBorder(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: mascotifySurfaceTint(context),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: mascotifyBorder(context)),
                ),
                child: Text(
                  'Beta',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: mascotifyPrimaryText(context),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Preview read-only',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: mascotifySecondaryText(context),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Profesionales pet',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Estamos preparando herramientas para veterinarias, paseadores, cuidadores y servicios pet. Hoy Mascotify esta enfocada en familias y tutores.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: mascotifySecondaryText(context),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 16),
          const Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _StatusPill(label: 'Sin agenda real'),
              _StatusPill(label: 'Sin pagos'),
              _StatusPill(label: 'Sin datos profesionales'),
              _StatusPill(label: 'Contacto futuro mediado'),
            ],
          ),
        ],
      ),
    );
  }
}

class _PreviewSection extends StatelessWidget {
  const _PreviewSection({
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
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: mascotifySecondaryText(context),
              ),
            ),
            const SizedBox(height: 14),
            ...children.map(
              (child) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServicePreviewCard extends StatelessWidget {
  const _ServicePreviewCard({required this.item});

  final ProfessionalServiceSpotlight item;

  @override
  Widget build(BuildContext context) {
    return _PreviewTile(
      icon: Icons.storefront_outlined,
      color: Color(item.accentColorHex),
      title: item.title,
      subtitle: item.availabilityLabel,
      body: item.subtitle,
    );
  }
}

class _ProfilePreviewCard extends StatelessWidget {
  const _ProfilePreviewCard({required this.profile});

  final ProfessionalProfile profile;

  @override
  Widget build(BuildContext context) {
    return _PreviewTile(
      icon: Icons.verified_outlined,
      color: Color(profile.accentColorHex),
      title: profile.name,
      subtitle: profile.specialty,
      body:
          'Perfil demo para visualizar confianza y contenido futuro. No permite contacto ni contratacion real.',
    );
  }
}

class _PreviewTile extends StatelessWidget {
  const _PreviewTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.body,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: mascotifySurfaceAlt(context),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: mascotifyBorder(context)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: mascotifyTone(context, color),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: mascotifyPrimaryText(context)),
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
                    color: mascotifySecondaryText(context),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  body,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: mascotifyPrimaryText(context),
                    height: 1.35,
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

class _LockedActionsCard extends StatelessWidget {
  const _LockedActionsCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: mascotifySurface(context),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Por ahora es solo preview',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'No se pueden cargar datos profesionales, crear turnos, publicar servicios, recibir pagos ni contactar desde esta beta.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: mascotifySecondaryText(context),
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: mascotifyTone(context, Colors.white.withValues(alpha: 0.76)),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: mascotifyBorder(context)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: mascotifyPrimaryText(context),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
