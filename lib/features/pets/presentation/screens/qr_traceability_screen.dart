import 'package:flutter/material.dart';

import '../../../../shared/data/reporting_mock_data.dart';
import '../../../../shared/models/pet.dart';
import '../../../../shared/models/report_models.dart';
import '../../../../theme/app_colors.dart';

class QrTraceabilityScreen extends StatelessWidget {
  const QrTraceabilityScreen({super.key, required this.pet});

  final Pet pet;

  @override
  Widget build(BuildContext context) {
    final status = buildQrStatusSnapshotForPet(pet);
    final activity = buildQrActivityEntriesForPet(pet);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Historial QR')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: [
            Container(
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
                      'Trazabilidad QR',
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'El código de ${pet.name} ya puede leerse como una capa de seguimiento.',
                    style: textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Este historial mock reúne escaneos, señales públicas, estado del contacto protegido y eventos recientes para comunicar valor real del QR.',
                    style: textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: _MetricTile(
                          label: 'Estado',
                          value: status.currentStatus,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _MetricTile(
                          label: 'Actividad',
                          value: status.activeWindowLabel,
                        ),
                      ),
                    ],
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
                      'Estado actual del perfil QR',
                      style: textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Lectura rápida del valor operativo del QR dentro de Mascotify.',
                      style: textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    _InfoTile(
                      label: 'Contacto protegido',
                      value: status.protectedContactState,
                    ),
                    const SizedBox(height: 10),
                    _InfoTile(
                      label: 'Última señal',
                      value: status.lastSignalLabel,
                    ),
                    const SizedBox(height: 10),
                    _InfoTile(
                      label: 'Detalle útil',
                      value: status.lastSignalDetail,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _InfoTile(
                            label: 'Escaneos',
                            value: status.totalScansLabel,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _InfoTile(
                            label: 'Ventana activa',
                            value: status.activeWindowLabel,
                          ),
                        ),
                      ],
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
                    Text('Timeline de actividad', style: textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(
                      'Eventos mock que ayudan a leer qué pasó con el QR y en qué momento.',
                      style: textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    ...activity.map(
                      (entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _TimelineEntry(entry: entry),
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
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineEntry extends StatelessWidget {
  const _TimelineEntry({required this.entry});

  final QrActivityEntry entry;

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
              color: Color(entry.accentColorHex),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(_iconFor(entry.iconKey), color: AppColors.textPrimary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _Pill(label: entry.statusLabel),
                    _Pill(label: entry.timeLabel),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  entry.title,
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

class _Pill extends StatelessWidget {
  const _Pill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
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
