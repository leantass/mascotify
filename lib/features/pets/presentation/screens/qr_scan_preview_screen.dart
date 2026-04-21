import 'package:flutter/material.dart';

import '../../../../shared/data/app_data_source.dart';
import '../../../../shared/models/pet.dart';
import '../../../../shared/models/report_models.dart';
import '../../../../shared/widgets/responsive_page_body.dart';
import '../../../../theme/app_colors.dart';
import 'qr_traceability_screen.dart';
import 'report_sighting_screen.dart';

class QrScanPreviewScreen extends StatefulWidget {
  const QrScanPreviewScreen({super.key, required this.pet});

  final Pet pet;

  @override
  State<QrScanPreviewScreen> createState() => _QrScanPreviewScreenState();
}

class _QrScanPreviewScreenState extends State<QrScanPreviewScreen> {
  late QrStatusSnapshot _snapshot;
  late List<QrActivityEntry> _activity;

  @override
  void initState() {
    super.initState();
    _reloadQrState();
    _registerScan();
  }

  @override
  Widget build(BuildContext context) {
    final pet = AppData.findPetById(widget.pet.id) ?? widget.pet;
    final textTheme = Theme.of(context).textTheme;
    final snapshot = _snapshot;
    final operationalActivity = _activity
        .where((entry) => entry.iconKey == 'qr' || entry.iconKey == 'location')
        .take(3)
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Escaneo publico')),
      body: SafeArea(
        child: ResponsivePageBody(
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
                  Row(
                    children: [
                      Container(
                        width: 78,
                        height: 78,
                        decoration: BoxDecoration(
                          color: AppColors.dark,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const Icon(
                          Icons.pets_rounded,
                          color: Colors.white,
                          size: 38,
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
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mascota registrada en Mascotify',
                          style: textTheme.titleMedium,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Este perfil fue disenado para ayudar a ubicar a la mascota de forma simple, segura y confiable.',
                          style: textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Card(
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
                              Text(
                                'Codigo publico activo',
                                style: textTheme.titleLarge,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Identificacion visible para reportar un avistamiento sin exponer datos privados.',
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
                        color: AppColors.surfaceAlt,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _PublicInfoTile(
                              label: 'Codigo',
                              value: pet.qrCodeLabel,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _PublicInfoTile(
                              label: 'Estado',
                              value: pet.qrEnabled ? 'Activo' : 'Pendiente',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _PublicInfoTile(
                            label: 'Última señal',
                            value: snapshot.lastSignalLabel,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _PublicInfoTile(
                            label: 'Contacto protegido',
                            value: snapshot.protectedContactState,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.dark, Color(0xFF264B4B)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(26),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Encontraste a ${pet.name}?',
                            style: textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Podes informar un avistamiento de forma simple. El sistema registra la senal, mantiene trazabilidad y deriva la informacion al responsable sin mostrar contacto privado directo.',
                            style: textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.82),
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          ReportSightingScreen(pet: pet),
                                    ),
                                  ),
                                  child: const Text('Reportar avistamiento'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          QrTraceabilityScreen(pet: pet),
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    side: BorderSide(
                                      color: Colors.white.withValues(
                                        alpha: 0.22,
                                      ),
                                    ),
                                    backgroundColor: Colors.white.withValues(
                                      alpha: 0.06,
                                    ),
                                  ),
                                  child: const Text('Ver historial'),
                                ),
                              ),
                            ],
                          ),
                        ],
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
                      'Actividad reciente del QR',
                      style: textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ultimos eventos utiles para entender si este QR ya recibio escaneos o reportes reales.',
                      style: textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    if (operationalActivity.isEmpty)
                      const _PreviewEmptyState()
                    else
                      ...operationalActivity.map(
                        (entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _ActivityTile(entry: entry),
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
                      'Como funciona este flujo',
                      style: textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    const _InfoBullet(
                      text:
                          'No se expone contacto privado directo del responsable en esta pantalla publica.',
                    ),
                    const _InfoBullet(
                      text:
                          'Cada escaneo o reporte puede transformarse en una senal util dentro del historial QR persistente.',
                    ),
                    const _InfoBullet(
                      text:
                          'El objetivo es dar contexto claro, seguimiento y una vía segura para actuar más rápido.',
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

  void _reloadQrState() {
    final pet = AppData.findPetById(widget.pet.id) ?? widget.pet;
    _snapshot = AppData.qrStatusSnapshotForPet(pet);
    _activity = AppData.qrActivityEntriesForPet(pet);
  }

  Future<void> _registerScan() async {
    await AppData.registerQrScan(widget.pet.id);
    if (!mounted) return;

    setState(_reloadQrState);
  }
}

class _PreviewEmptyState extends StatelessWidget {
  const _PreviewEmptyState();

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
      child: Text(
        'Todavía no hay actividad QR real para esta mascota. Cuando llegue el primer escaneo o reporte, esta preview va a mostrar el contexto más reciente.',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.textPrimary,
          height: 1.45,
        ),
      ),
    );
  }
}

class _PublicInfoTile extends StatelessWidget {
  const _PublicInfoTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
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

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({required this.entry});

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
            width: 42,
            height: 42,
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
                  entry.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  '${entry.statusLabel} - ${entry.timeLabel}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
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

class _InfoBullet extends StatelessWidget {
  const _InfoBullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.only(top: 6),
            decoration: const BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
