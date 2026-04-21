import 'package:flutter/material.dart';

import '../../../../shared/data/app_data_source.dart';
import '../../../../shared/models/pet.dart';
import '../../../../shared/models/report_models.dart';
import '../../../../shared/widgets/responsive_page_body.dart';
import '../../../../theme/app_colors.dart';

class ReportSightingScreen extends StatefulWidget {
  const ReportSightingScreen({super.key, required this.pet});

  final Pet pet;

  @override
  State<ReportSightingScreen> createState() => _ReportSightingScreenState();
}

class _ReportSightingScreenState extends State<ReportSightingScreen> {
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedCondition = 'La vi en movimiento';
  bool _allowContact = true;

  late final SightingLocationReference _suggestedLocation;

  @override
  void initState() {
    super.initState();
    _suggestedLocation = AppData.suggestedLocationForPet(widget.pet);
    _locationController.text = _suggestedLocation.zoneReference;
  }

  @override
  void dispose() {
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pet = AppData.findPetById(widget.pet.id) ?? widget.pet;
    final textTheme = Theme.of(context).textTheme;
    final snapshot = AppData.qrStatusSnapshotForPet(pet);
    final activity = AppData.qrActivityEntriesForPet(pet);
    final operationalActivity = activity
        .where((entry) => entry.iconKey == 'qr' || entry.iconKey == 'location')
        .take(2)
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Reportar avistamiento')),
      body: SafeArea(
        child: ResponsivePageBody(
          maxWidth: 920,
          child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(pet.colorHex), AppColors.surface],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tu reporte puede ayudar a ubicar a ${pet.name} mas rapido.',
                    style: textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Compartis una referencia simple, visible y segura. El responsable podria recibir una ubicacion aproximada util sin exponer contacto privado directo.',
                    style: textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 62,
                      height: 62,
                      decoration: BoxDecoration(
                        color: Color(pet.colorHex),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.pets_rounded,
                        color: AppColors.dark,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(pet.name, style: textTheme.titleMedium),
                          const SizedBox(height: 4),
                          Text(
                            '${pet.species} - ${pet.breed}',
                            style: textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceAlt,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              pet.qrCodeLabel,
                              style: textTheme.bodyMedium?.copyWith(
                                color: AppColors.textPrimary,
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
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Trazabilidad QR activa', style: textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(
                      'Este reporte se suma a la actividad reciente del QR y refuerza la lectura de seguimiento del perfil.',
                      style: textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _StatusMetric(
                            label: 'Estado',
                            value: snapshot.currentStatus,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _StatusMetric(
                            label: 'Ultima senal',
                            value: snapshot.lastSignalLabel,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (operationalActivity.isEmpty)
                      const _QrTraceabilityEmptyState()
                    else
                      ...operationalActivity.map(
                        (entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _TraceabilityPreview(entry: entry),
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
                      'Ubicacion aproximada detectada',
                      style: textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Representacion de la referencia que puede capturarse al escanear el QR y preparar el aviso para el responsable.',
                      style: textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    _MockLocationMap(location: _suggestedLocation),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _StatusMetric(
                            label: 'Zona',
                            value: _suggestedLocation.zone,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _StatusMetric(
                            label: 'Referencia',
                            value: _suggestedLocation.shortReference,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceAlt,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: AppColors.supportSoft,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.location_on_rounded,
                              color: AppColors.textPrimary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ubicacion lista para enviar',
                                  style: textTheme.titleMedium,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${_suggestedLocation.zoneReference}. El sistema podria enviar este punto como referencia aproximada de avistamiento.',
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: AppColors.textPrimary,
                                    height: 1.45,
                                  ),
                                ),
                              ],
                            ),
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
                      'Detalle del avistamiento',
                      style: textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _locationController,
                      decoration: const InputDecoration(
                        labelText: 'Ubicacion aproximada',
                        hintText: 'Ej. Plaza Irlanda, Caballito',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Podes ajustar la referencia si queres sumar mas precision sin necesidad de compartir datos privados.',
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: _notesController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'Observaciones',
                        hintText:
                            'Conta que viste, hacia donde iba o cualquier dato util.',
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text('Estado observado', style: textTheme.titleMedium),
                    const SizedBox(height: 12),
                    RadioGroup<String>(
                      groupValue: _selectedCondition,
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() {
                          _selectedCondition = value;
                        });
                      },
                      child: Column(
                        children: [
                          ...[
                            'La vi en movimiento',
                            'Esta quieta',
                            'Parece lastimada',
                          ].map(
                            (option) => RadioListTile<String>(
                              value: option,
                              activeColor: AppColors.accent,
                              contentPadding: EdgeInsets.zero,
                              title: Text(option),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      value: _allowContact,
                      onChanged: (value) {
                        setState(() {
                          _allowContact = value;
                        });
                      },
                      activeThumbColor: AppColors.accent,
                      activeTrackColor: AppColors.accentSoft,
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Permitir contacto posterior'),
                      subtitle: const Text(
                        'Si hace falta ampliar el reporte, Mascotify podria usar este permiso dentro del flujo seguro.',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: _submitReport,
              child: const Text('Enviar reporte'),
            ),
          ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitReport() async {
    final locationLabel = _locationController.text.trim().isEmpty
        ? _suggestedLocation.zoneReference
        : _locationController.text.trim();
    final draft = SightingReportDraft(
      petId: widget.pet.id,
      locationLabel: locationLabel,
      notes: _notesController.text.trim(),
      condition: _selectedCondition,
      allowContact: _allowContact,
    );

    await AppData.submitSightingReport(draft);
    if (!mounted) return;

    await showDialog<void>(
      context: context,
      builder: (context) {
        final pet = widget.pet;
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.primarySoft,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: AppColors.primaryDeep,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Reporte enviado',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'La referencia sobre ${pet.name} quedo registrada y puede enviarse al responsable como una ubicacion aproximada util desde Mascotify.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 18),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceAlt,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Resumen enviado',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 10),
                      _SummaryRow(label: 'Estado', value: _selectedCondition),
                      _SummaryRow(
                        label: 'Ubicacion aproximada',
                        value: locationLabel,
                      ),
                      _SummaryRow(
                        label: 'Zona sugerida',
                        value: _suggestedLocation.zone,
                      ),
                      _SummaryRow(
                        label: 'Referencia visual',
                        value: _suggestedLocation.shortReference,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.supportSoft,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    'El responsable recibiria una senal clara de zona y punto aproximado, sin necesidad de exponer tu contacto privado de forma directa.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textPrimary,
                      height: 1.45,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceAlt,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    'Dentro del historial QR, este evento ya quedo asentado como una nueva senal de trazabilidad vinculada a ${pet.qrCodeLabel}.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textPrimary,
                      height: 1.45,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(this.context).pop();
                    },
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
}

class _QrTraceabilityEmptyState extends StatelessWidget {
  const _QrTraceabilityEmptyState();

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
      child: Text(
        'Todavia no hay eventos QR reales para esta mascota. Este reporte puede transformarse en la primera senal util dentro del historial.',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.textPrimary,
          height: 1.45,
        ),
      ),
    );
  }
}

class _TraceabilityPreview extends StatelessWidget {
  const _TraceabilityPreview({required this.entry});

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

class _MockLocationMap extends StatelessWidget {
  const _MockLocationMap({required this.location});

  final SightingLocationReference location;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 220,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.surfaceAlt, AppColors.primarySoft],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 12,
            top: 14,
            child: _MapLabel(text: location.mapLabelTop),
          ),
          Positioned(
            right: 12,
            bottom: 14,
            child: _MapLabel(text: location.mapLabelBottom),
          ),
          Positioned.fill(child: CustomPaint(painter: _MapGridPainter())),
          Align(
            alignment: Alignment(
              (location.horizontalFactor * 2) - 1,
              (location.verticalFactor * 2) - 1,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.dark,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    location.shortReference,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: 26,
                  height: 26,
                  decoration: const BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.location_on_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.72),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.supportSoft,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.shield_outlined,
                      color: AppColors.textPrimary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${location.timeReference}. Punto listo para enviar como referencia util al responsable.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusMetric extends StatelessWidget {
  const _StatusMetric({required this.label, required this.value});

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
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(height: 1.35),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
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
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _MapLabel extends StatelessWidget {
  const _MapLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1;

    final routePaint = Paint()
      ..color = AppColors.accent.withValues(alpha: 0.28)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    final softRoutePaint = Paint()
      ..color = AppColors.primaryDeep.withValues(alpha: 0.12)
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    for (var i = 1; i < 4; i++) {
      final dx = size.width * (i / 4);
      final dy = size.height * (i / 4);
      canvas.drawLine(Offset(dx, 0), Offset(dx, size.height), gridPaint);
      canvas.drawLine(Offset(0, dy), Offset(size.width, dy), gridPaint);
    }

    final path = Path()
      ..moveTo(size.width * 0.12, size.height * 0.28)
      ..quadraticBezierTo(
        size.width * 0.34,
        size.height * 0.18,
        size.width * 0.56,
        size.height * 0.34,
      )
      ..quadraticBezierTo(
        size.width * 0.74,
        size.height * 0.44,
        size.width * 0.86,
        size.height * 0.26,
      );

    final softPath = Path()
      ..moveTo(size.width * 0.20, size.height * 0.72)
      ..quadraticBezierTo(
        size.width * 0.42,
        size.height * 0.58,
        size.width * 0.66,
        size.height * 0.76,
      )
      ..quadraticBezierTo(
        size.width * 0.76,
        size.height * 0.82,
        size.width * 0.88,
        size.height * 0.66,
      );

    canvas.drawPath(path, routePaint);
    canvas.drawPath(softPath, softRoutePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
