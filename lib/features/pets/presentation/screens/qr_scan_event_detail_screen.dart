import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../shared/data/app_data_source.dart';
import '../../../../shared/models/pet.dart';
import '../../../../shared/models/report_models.dart';
import '../../../../shared/widgets/responsive_page_body.dart';
import '../../../../theme/app_colors.dart';

class QrScanEventDetailScreen extends StatelessWidget {
  const QrScanEventDetailScreen({
    super.key,
    required this.event,
    required this.pet,
  });

  final QrScanEvent event;
  final Pet pet;

  @override
  Widget build(BuildContext context) {
    final currentPet = AppData.findPetById(pet.id) ?? pet;
    final currentEvent = AppData.findQrScanEventById(event.id) ?? event;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del evento QR')),
      body: SafeArea(
        child: ResponsivePageBody(
          maxWidth: 920,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            children: [
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(currentPet.colorHex),
                      AppColors.surface,
                      currentEvent.possibleLostPetSighting
                          ? AppColors.supportSoft
                          : AppColors.primarySoft,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _Pill(label: currentEvent.sourceLabel),
                        if (currentEvent.possibleLostPetSighting)
                          const _Pill(
                            label: 'Posible avistaje de mascota perdida',
                          ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'QR escaneado de ${currentPet.name}',
                      style: textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ubicación reportada: ${currentEvent.locationSummary}',
                      style: textTheme.bodyLarge?.copyWith(
                        color: AppColors.textPrimary,
                        height: 1.45,
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
                      Text('Datos del evento', style: textTheme.titleLarge),
                      const SizedBox(height: 14),
                      _InfoRow(label: 'Mascota', value: currentPet.name),
                      _InfoRow(label: 'QR', value: currentEvent.qrId),
                      _InfoRow(
                        label: 'Fecha/hora',
                        value: currentEvent.scannedAt.toLocal().toString(),
                      ),
                      _InfoRow(
                        label: 'Ubicación',
                        value: currentEvent.locationSummary,
                      ),
                      if (currentEvent.hasCoordinates) ...[
                        _InfoRow(
                          label: 'Coordenadas',
                          value:
                              '${currentEvent.latitude}, ${currentEvent.longitude}',
                        ),
                        _InfoRow(
                          label: 'Precisión',
                          value: currentEvent.accuracyMeters == null
                              ? 'No informada'
                              : '${currentEvent.accuracyMeters!.toStringAsFixed(0)} m',
                        ),
                      ],
                      if (currentEvent.message.trim().isNotEmpty)
                        _InfoRow(
                          label: 'Comentario',
                          value: currentEvent.message,
                        ),
                      if (currentEvent.scannerContact.trim().isNotEmpty)
                        _InfoRow(
                          label: 'Contacto opcional del escáner',
                          value: currentEvent.scannerContact,
                        ),
                      if (currentEvent.hasCoordinates) ...[
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            OutlinedButton.icon(
                              key: const ValueKey('open-google-maps-button'),
                              onPressed: () {
                                unawaited(
                                  launchUrlString(
                                    currentEvent.mapUrl,
                                    mode: LaunchMode.externalApplication,
                                  ),
                                );
                              },
                              icon: const Icon(Icons.map_rounded),
                              label: const Text('Abrir en Google Maps'),
                            ),
                            OutlinedButton.icon(
                              key: const ValueKey('copy-qr-coordinates-button'),
                              onPressed: () {
                                Clipboard.setData(
                                  ClipboardData(
                                    text:
                                        '${currentEvent.latitude}, ${currentEvent.longitude}',
                                  ),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Coordenadas copiadas'),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.copy_rounded),
                              label: const Text('Copiar coordenadas'),
                            ),
                            OutlinedButton.icon(
                              onPressed: () {
                                Clipboard.setData(
                                  ClipboardData(text: currentEvent.mapUrl),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Link de mapa copiado'),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.map_outlined),
                              label: const Text('Copiar link de mapa'),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const _SafetyCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SafetyCard extends StatelessWidget {
  const _SafetyCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Recomendaciones de seguridad'),
            SizedBox(height: 12),
            _SafetyBullet(text: 'No pagues rescates ni transferencias.'),
            _SafetyBullet(text: 'Verificá señas privadas de la mascota.'),
            _SafetyBullet(text: 'Encontrate en un lugar público.'),
            _SafetyBullet(text: 'Andá acompañado si podés.'),
            _SafetyBullet(text: 'Reportá cualquier intento de cobro.'),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

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
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textMuted,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
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
        color: AppColors.surface,
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

class _SafetyBullet extends StatelessWidget {
  const _SafetyBullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
