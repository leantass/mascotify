import 'package:flutter/material.dart';

import '../../../../features/explore/presentation/screens/connections_inbox_screen.dart';
import '../../../../features/explore/presentation/screens/explore_screen.dart';
import '../../../../features/explore/presentation/screens/professionals_screen.dart';
import '../../../../features/pets/presentation/screens/pet_detail_screen.dart';
import '../../../../shared/data/mock_data.dart';
import '../../../../shared/models/pet.dart';
import '../../../../shared/widgets/pet_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../theme/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = MockData.currentUser;
    final pets = MockData.pets;
    final activeQrCount = pets.where((pet) => pet.qrEnabled).length;
    final socialReadyCount = pets
        .where((pet) => pet.socialProfileStatus.isNotEmpty)
        .length;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: [
            _HomeHero(
              firstName: user.name.split(' ').first,
              petCount: pets.length,
              planName: user.planName,
              city: user.city,
            ),
            const SizedBox(height: 20),
            _EcosystemOverview(
              pets: pets,
              activeQrCount: activeQrCount,
              socialReadyCount: socialReadyCount,
            ),
            const SizedBox(height: 20),
            const SectionHeader(
              eyebrow: 'Centro del ecosistema',
              title: 'Accesos principales',
              subtitle:
                  'Entradas rapidas a identidad, social y comunidad experta.',
            ),
            const SizedBox(height: 16),
            _PrimaryAccessGrid(pets: pets),
            const SizedBox(height: 24),
            SectionHeader(
              eyebrow: 'Base Mascotify',
              title: 'Mis mascotas',
              subtitle:
                  'Perfiles listos para crecer con QR, documentos, matching y seguridad.',
              trailing: TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => PetDetailScreen(pet: pets.first),
                  ),
                ),
                child: const Text('Ver ficha'),
              ),
            ),
            const SizedBox(height: 16),
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
            _SectionCard(
              title: 'QR y seguridad',
              subtitle:
                  'Visibilidad clara sobre identidad digital, contacto seguro y estado QR.',
              child: Column(
                children: pets
                    .take(2)
                    .map(
                      (pet) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _QrStatusTile(pet: pet),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Actividad social',
              subtitle:
                  'Un resumen rapido del movimiento social y las conexiones que empiezan a tomar forma.',
              child: Column(
                children: [
                  const _ActivityTile(
                    title: 'Bandeja social activa',
                    description:
                        'Hay intereses recibidos, un vinculo visto y una posible afinidad para revisar.',
                    tone: AppColors.accentSoft,
                    icon: Icons.forum_rounded,
                  ),
                  const SizedBox(height: 10),
                  _ActivityTile(
                    title: '${pets.first.name} listo para explorar',
                    description:
                        'Su perfil social ya esta visible para futuras conexiones y matching responsable.',
                    tone: AppColors.primarySoft,
                    icon: Icons.favorite_border_rounded,
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const ConnectionsInboxScreen(),
                        ),
                      ),
                      child: const Text('Abrir bandeja social'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Contenido recomendado',
              subtitle:
                  'La comunidad experta ya empieza a sumar contexto util para decisiones de cuidado y matching.',
              child: Column(
                children: [
                  const _ContentRecommendationTile(
                    title:
                        'Presentaciones seguras entre mascotas: lo que conviene mirar primero',
                    subtitle: 'Comportamiento · 2 min · Lic. Tomas Ibarra',
                    description:
                        'Una pieza breve para entender energia, distancia y primeros pasos antes de un encuentro.',
                    accentColor: AppColors.accentSoft,
                  ),
                  const SizedBox(height: 10),
                  const _ContentRecommendationTile(
                    title: 'Que deberia tener un perfil QR realmente util',
                    subtitle:
                        'Identidad digital · 1 min 30 s · Dra. Paula Mendes',
                    description:
                        'Contenido corto sobre contacto seguro, informacion esencial y claridad para reportes.',
                    accentColor: AppColors.supportSoft,
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const ProfessionalsScreen(),
                        ),
                      ),
                      child: const Text('Ver profesionales y contenido'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeHero extends StatelessWidget {
  const _HomeHero({
    required this.firstName,
    required this.petCount,
    required this.planName,
    required this.city,
  });

  final String firstName;
  final int petCount;
  final String planName;
  final String city;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.primarySoft,
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.dark,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'Hola, $firstName',
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.pets_rounded, color: AppColors.accent),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            'Mascotify ya funciona como un ecosistema para identidad, social y comunidad experta.',
            style: textTheme.headlineLarge,
          ),
          const SizedBox(height: 12),
          Text(
            'Tus mascotas, su seguridad digital y nuevas capas de descubrimiento viven en una misma entrada clara y cercana desde $city.',
            style: textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Expanded(
                child: _MetricTile(
                  value: '$petCount',
                  label: 'Perfiles activos',
                  tone: AppColors.surface,
                  valueColor: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MetricTile(
                  value: planName,
                  label: 'Plan actual',
                  tone: AppColors.supportSoft,
                  valueColor: AppColors.textPrimary,
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
    required this.pets,
    required this.activeQrCount,
    required this.socialReadyCount,
  });

  final List<Pet> pets;
  final int activeQrCount;
  final int socialReadyCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _OverviewTile(
            title: 'QR y seguridad',
            value: '$activeQrCount activos',
            description: pets.first.qrStatus,
            color: AppColors.supportSoft,
            icon: Icons.qr_code_2_rounded,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _OverviewTile(
            title: 'Social y matching',
            value: '$socialReadyCount perfiles',
            description:
                'La capa social ya esta lista para conexiones futuras.',
            color: AppColors.accentSoft,
            icon: Icons.groups_rounded,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _OverviewTile(
            title: 'Contenido experto',
            value: '3 voces',
            description: 'Hay profesionales y piezas breves recomendadas.',
            color: AppColors.primarySoft,
            icon: Icons.workspace_premium_outlined,
          ),
        ),
      ],
    );
  }
}

class _PrimaryAccessGrid extends StatelessWidget {
  const _PrimaryAccessGrid({required this.pets});

  final List<Pet> pets;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _PrimaryAccessCard(
                title: 'Ficha de mascota',
                subtitle:
                    'Identidad, salud, documentos y QR desde una sola vista.',
                icon: Icons.badge_outlined,
                tone: AppColors.primarySoft,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => PetDetailScreen(pet: pets.first),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _PrimaryAccessCard(
                title: 'Bandeja social',
                subtitle: 'Intereses, afinidades y seguimiento de conexiones.',
                icon: Icons.forum_rounded,
                tone: AppColors.accentSoft,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const ConnectionsInboxScreen(),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _PrimaryAccessCard(
                title: 'Profesionales',
                subtitle:
                    'Charlas, opiniones y contenido breve para decidir mejor.',
                icon: Icons.play_circle_outline_rounded,
                tone: AppColors.supportSoft,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const ProfessionalsScreen(),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _PrimaryAccessCard(
                title: 'Explorar ecosistema',
                subtitle:
                    'Discovery progresivo entre perfiles y voces expertas.',
                icon: Icons.explore_outlined,
                tone: AppColors.surfaceAlt,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ExploreScreen()),
                ),
              ),
            ),
          ],
        ),
      ],
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

class _QrStatusTile extends StatelessWidget {
  const _QrStatusTile({required this.pet});

  final Pet pet;

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
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Color(pet.colorHex),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.qr_code_2_rounded, color: AppColors.dark),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        pet.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: pet.qrEnabled
                            ? AppColors.primarySoft
                            : AppColors.supportSoft,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        pet.qrEnabled ? 'Activo' : 'Pendiente',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  pet.qrStatus,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    height: 1.4,
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

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({
    required this.title,
    required this.description,
    required this.tone,
    required this.icon,
  });

  final String title;
  final String description;
  final Color tone;
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
              color: tone,
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
                  description,
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

class _ContentRecommendationTile extends StatelessWidget {
  const _ContentRecommendationTile({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.accentColor,
  });

  final String title;
  final String subtitle;
  final String description;
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
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.play_circle_outline_rounded,
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
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
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
          const SizedBox(height: 14),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              height: 1.4,
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
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color tone;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.surfaceAlt,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: tone,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 16),
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.value,
    required this.label,
    required this.tone,
    required this.valueColor,
  });

  final String value;
  final String label;
  final Color tone;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tone,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: valueColor),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
