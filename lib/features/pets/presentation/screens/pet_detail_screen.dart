import 'package:flutter/material.dart';

import '../../../../shared/data/app_data_source.dart';
import '../../../../shared/models/pet.dart';
import '../../../../shared/models/report_models.dart';
import '../../../../theme/app_colors.dart';
import 'qr_scan_preview_screen.dart';
import 'qr_traceability_screen.dart';

class PetDetailScreen extends StatelessWidget {
  const PetDetailScreen({super.key, required this.pet});

  final Pet pet;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de mascota')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: [
            _PetHeroCard(pet: pet),
            const SizedBox(height: 20),
            _AboutPetCard(pet: pet),
            const SizedBox(height: 16),
            _SocialProfileCard(pet: pet),
            const SizedBox(height: 16),
            _MatchingProfileCard(pet: pet),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Identidad',
              subtitle:
                  'Base del perfil digital y estado general del registro.',
              icon: Icons.badge_outlined,
              accentColor: AppColors.primarySoft,
              children: [
                _DetailRow(label: 'ID de perfil', value: pet.profileId),
                _DetailRow(label: 'Especie', value: pet.species),
                _DetailRow(label: 'Raza', value: pet.breed),
                _DetailRow(label: 'Edad', value: pet.ageLabel),
                _DetailText(text: pet.identitySummary),
              ],
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Documentación',
              subtitle:
                  'Preparada para vacunas, certificados e historial base.',
              icon: Icons.description_outlined,
              accentColor: AppColors.supportSoft,
              children: [
                _DetailRow(label: 'Estado', value: pet.documentStatus),
              ],
            ),
            const SizedBox(height: 16),
            _QrExperienceCard(pet: pet),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Salud',
              subtitle: 'Resumen inicial para controles y seguimiento.',
              icon: Icons.favorite_border_rounded,
              accentColor: AppColors.surfaceAlt,
              children: [
                _DetailRow(label: 'Seguimiento', value: pet.healthSummary),
              ],
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Acciones rápidas',
              subtitle: 'Atajos listos para futuras operaciones del producto.',
              icon: Icons.flash_on_outlined,
              accentColor: AppColors.primarySoft,
              children: [
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: pet.quickActions
                      .map((action) => _ActionChip(label: action))
                      .toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PetHeroCard extends StatelessWidget {
  const _PetHeroCard({required this.pet});

  final Pet pet;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(pet.colorHex),
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
          Row(
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: AppColors.dark,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.pets_rounded,
                  color: Colors.white,
                  size: 36,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.supportSoft,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  pet.status,
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(pet.name, style: textTheme.headlineLarge),
          const SizedBox(height: 8),
          Text(
            '${pet.species} - ${pet.breed}',
            style: textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _HeroStat(label: 'Edad', value: pet.ageLabel),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _HeroStat(label: 'Perfil', value: pet.profileId),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AboutPetCard extends StatelessWidget {
  const _AboutPetCard({required this.pet});

  final Pet pet;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sobre ${pet.name}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(pet.biography, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _SocialStatTile(
                    label: 'Sexo',
                    value: pet.sex,
                    color: AppColors.primarySoft,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SocialStatTile(
                    label: 'Ubicación',
                    value: pet.location,
                    color: AppColors.surfaceAlt,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialProfileCard extends StatelessWidget {
  const _SocialProfileCard({required this.pet});

  final Pet pet;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.accentSoft,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.groups_rounded,
                    color: AppColors.accentDeep,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Perfil social',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        pet.socialProfileStatus,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              'Personalidad e intereses',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: pet.personalityTags
                  .map((tag) => _ProfileTagChip(label: tag))
                  .toList(),
            ),
            const SizedBox(height: 18),
            Text(
              'Momentos destacados',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Row(
              children: pet.featuredMoments
                  .asMap()
                  .entries
                  .map(
                    (entry) => Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: entry.key == 2 ? 0 : 10,
                        ),
                        child: _MomentCard(label: entry.value),
                      ),
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

class _MatchingProfileCard extends StatelessWidget {
  const _MatchingProfileCard({required this.pet});

  final Pet pet;

  @override
  Widget build(BuildContext context) {
    final currentPet = AppData.findPetById(pet.id) ?? pet;
    final preferences = currentPet.matchingPreferences;
    final textTheme = Theme.of(context).textTheme;
    final isSaved = AppData.savedProfiles.any(
      (entry) => entry.pet.id == currentPet.id,
    );
    final interestCount = AppData.socialInboxEntries
        .where((entry) => entry.pet.id == currentPet.id)
        .length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Matching más expresivo', style: textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Una base persistida para expresar qué busca ${currentPet.name} dentro del ecosistema social.',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.surfaceAlt, AppColors.primarySoft],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.72),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      'Lo que busca hoy',
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    preferences.preferredBondType,
                    style: textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currentPet.socialInterest,
                    style: textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    preferences.matchSummary,
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.textPrimary,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _MatchingPill(
                        label: 'Ritmo ${preferences.rhythmLabel}',
                        backgroundColor: Colors.white.withValues(alpha: 0.78),
                      ),
                      _MatchingPill(
                        label: preferences.acceptsGradualMeet
                            ? 'Acepta acercamiento gradual'
                            : 'Prefiere vínculo más directo',
                        backgroundColor: Colors.white.withValues(alpha: 0.78),
                      ),
                      if (isSaved)
                        _MatchingPill(
                          label: 'Perfil guardado',
                          backgroundColor: Colors.white.withValues(alpha: 0.78),
                        ),
                      if (interestCount > 0)
                        _MatchingPill(
                          label:
                              '$interestCount señal${interestCount == 1 ? '' : 'es'} social${interestCount == 1 ? '' : 'es'}',
                          backgroundColor: Colors.white.withValues(alpha: 0.78),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _MatchingKeyTile(
                    label: 'Radio ideal',
                    value: preferences.locationRadiusLabel,
                    color: AppColors.surfaceAlt,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _MatchingKeyTile(
                    label: 'Ritmo sugerido',
                    value: preferences.rhythmLabel,
                    color: AppColors.primarySoft,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _MatchingKeyTile(
              label: 'Afinidad principal',
              value: currentPet.socialInterest,
              color: AppColors.accentSoft,
            ),
            const SizedBox(height: 10),
            _MatchingKeyTile(
              label: 'Interés reproductivo',
              value: currentPet.seekingBreeding
                  ? 'Disponible a evaluar con responsabilidad'
                  : 'No busca cría por ahora',
              color: AppColors.supportSoft,
            ),
            const SizedBox(height: 18),
            Text(
              'Señales que ayudan a decidir mejor',
              style: textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            ...preferences.compatibilitySignals.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _MatchingSignalTile(text: item),
              ),
            ),
            const SizedBox(height: 8),
            Text('Compatibilidades deseadas', style: textTheme.titleMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: preferences.desiredCompatibilities
                  .map((item) => _PreferenceChip(label: item))
                  .toList(),
            ),
            const SizedBox(height: 18),
            Text('Límites o alertas suaves', style: textTheme.titleMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: preferences.softLimits
                  .map((item) => _SoftLimitChip(label: item))
                  .toList(),
            ),
            const SizedBox(height: 18),
            _PreferenceNoteCard(
              title: 'Contexto ideal',
              icon: Icons.wb_sunny_outlined,
              color: AppColors.surfaceAlt,
              text: preferences.idealContext,
            ),
            const SizedBox(height: 12),
            _PreferenceNoteCard(
              title: 'Primer paso sugerido',
              icon: Icons.alt_route_rounded,
              color: AppColors.primarySoft,
              text: preferences.suggestedApproach,
            ),
            const SizedBox(height: 12),
            _PreferenceNoteCard(
              title: 'Límites y notas importantes',
              icon: Icons.shield_outlined,
              color: AppColors.supportSoft,
              text: preferences.importantNotes,
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.accentSoft,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Esta estructura ya permite que la ficha no solo identifique a ${currentPet.name}, sino que también sostenga afinidades, guardados e intereses con una base local coherente dentro de Mascotify.',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QrExperienceCard extends StatelessWidget {
  const _QrExperienceCard({required this.pet});

  final Pet pet;

  @override
  Widget build(BuildContext context) {
    final currentPet = AppData.findPetById(pet.id) ?? pet;
    final textTheme = Theme.of(context).textTheme;
    final snapshot = AppData.qrStatusSnapshotForPet(currentPet);
    final activity = AppData.qrActivityEntriesForPet(currentPet);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.accentSoft,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.qr_code_2_rounded,
                    color: AppColors.accentDeep,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('QR Mascotify', style: textTheme.titleLarge),
                      const SizedBox(height: 4),
                      Text(
                        'Identificación, rastreo y contacto seguro desde una sola pieza.',
                        style: textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.dark,
                    AppColors.dark.withValues(alpha: 0.92),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _QrStatusBadge(
                          label: currentPet.qrEnabled ? 'Activo' : 'Pendiente',
                          backgroundColor: currentPet.qrEnabled
                              ? AppColors.primarySoft
                              : AppColors.supportSoft,
                          textColor: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _QrStatusBadge(
                          label: currentPet.qrLastUpdate,
                          backgroundColor: Colors.white.withValues(alpha: 0.10),
                          textColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Container(
                    width: 190,
                    height: 190,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: _MockQrCode(label: pet.qrCodeLabel),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    currentPet.qrCodeLabel,
                    style: textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currentPet.qrStatus,
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.82),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _TrackingMetricTile(
                    label: 'Estado actual',
                    value: snapshot.currentStatus,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _TrackingMetricTile(
                    label: 'Escaneos',
                    value: snapshot.totalScansLabel,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _TrackingMetricTile(
                    label: 'Última señal',
                    value: snapshot.lastSignalLabel,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _TrackingMetricTile(
                    label: 'Contacto protegido',
                    value: snapshot.protectedContactState,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceAlt,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Este QR será la base para rastreo, avistamientos, contacto seguro e historial de escaneos dentro del ecosistema Mascotify.',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                snapshot.lastSignalDetail,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Actividad QR reciente',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            ...activity
                .take(2)
                .map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _QrTimelinePreviewTile(entry: entry),
                  ),
                ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => QrTraceabilityScreen(pet: pet),
                      ),
                    ),
                    child: const Text('Ver historial QR'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => QrScanPreviewScreen(pet: pet),
                      ),
                    ),
                    child: const Text('Probar escaneo'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => QrScanPreviewScreen(pet: pet),
                  ),
                ),
                child: const Text('Probar experiencia pública de escaneo'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialStatTile extends StatelessWidget {
  const _SocialStatTile({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
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

class _MomentCard extends StatelessWidget {
  const _MomentCard({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 108),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.surfaceAlt, AppColors.primarySoft],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.photo_library_outlined,
              color: AppColors.primaryDeep,
              size: 18,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            label,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}

class _ProfileTagChip extends StatelessWidget {
  const _ProfileTagChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.accentSoft,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.accentDeep,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _PreferenceChip extends StatelessWidget {
  const _PreferenceChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
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

class _MatchingPill extends StatelessWidget {
  const _MatchingPill({required this.label, required this.backgroundColor});

  final String label;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
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

class _MatchingSignalTile extends StatelessWidget {
  const _MatchingSignalTile({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.favorite_border_rounded,
              color: AppColors.textPrimary,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SoftLimitChip extends StatelessWidget {
  const _SoftLimitChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.supportSoft,
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

class _MatchingKeyTile extends StatelessWidget {
  const _MatchingKeyTile({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
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
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(height: 1.35),
          ),
        ],
      ),
    );
  }
}

class _PreferenceNoteCard extends StatelessWidget {
  const _PreferenceNoteCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.text,
  });

  final String title;
  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.72),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppColors.textPrimary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 6),
                Text(
                  text,
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

class _TrackingMetricTile extends StatelessWidget {
  const _TrackingMetricTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              fontWeight: FontWeight.w700,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _QrTimelinePreviewTile extends StatelessWidget {
  const _QrTimelinePreviewTile({required this.entry});

  final QrActivityEntry entry;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Color(entry.accentColorHex),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(_iconFor(entry.iconKey), color: AppColors.textPrimary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${entry.title} • ${entry.timeLabel}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  entry.detail,
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

  IconData _iconFor(String iconKey) {
    switch (iconKey) {
      case 'shield':
        return Icons.shield_outlined;
      case 'location':
        return Icons.location_on_outlined;
      case 'pending':
        return Icons.schedule_rounded;
      case 'badge':
        return Icons.badge_outlined;
      case 'history':
        return Icons.history_rounded;
      case 'qr':
      default:
        return Icons.qr_code_2_rounded;
    }
  }
}

class _MockQrCode extends StatelessWidget {
  const _MockQrCode({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: [
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 11,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
              ),
              itemCount: 121,
              itemBuilder: (context, index) {
                final isDark = _isDarkCell(index);
                return DecoratedBox(
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.dark : Colors.white,
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              },
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'M',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isDarkCell(int index) {
    const anchors = {
      0,
      1,
      2,
      11,
      13,
      22,
      23,
      24,
      8,
      9,
      10,
      19,
      21,
      30,
      31,
      32,
      88,
      89,
      90,
      99,
      101,
      110,
      111,
      112,
    };

    if (anchors.contains(index)) {
      return true;
    }

    final row = index ~/ 11;
    final col = index % 11;
    return (row + col).isEven || (row * col) % 3 == 0;
  }
}

class _QrStatusBadge extends StatelessWidget {
  const _QrStatusBadge({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  final String label;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({required this.label, required this.value});

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
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 6),
          Text(value, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.children,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: AppColors.textPrimary),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(height: 1.35),
          ),
        ],
      ),
    );
  }
}

class _DetailText extends StatelessWidget {
  const _DetailText({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.textPrimary,
          height: 1.5,
        ),
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
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
