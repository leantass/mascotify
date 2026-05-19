import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/app_environment.dart';
import '../../data/qr_api_client.dart';
import '../../../../shared/data/app_data_source.dart';
import '../../../../shared/models/pet.dart';
import '../../../../shared/models/report_models.dart';
import '../../../../shared/widgets/responsive_page_body.dart';
import '../../../../theme/app_colors.dart';
import 'qr_geolocation.dart';
import 'qr_scan_event_detail_screen.dart';

const _qrSafetyError =
    'Mascotify no permite pedir dinero por una mascota encontrada. Modificá el texto para continuar.';

class SecureQrScanScreen extends StatefulWidget {
  const SecureQrScanScreen({super.key, required this.qrId, this.initialPet});

  final String qrId;
  final Pet? initialPet;

  @override
  State<SecureQrScanScreen> createState() => _SecureQrScanScreenState();
}

class _SecureQrScanScreenState extends State<SecureQrScanScreen> {
  final _countryController = TextEditingController(text: 'Argentina');
  final _regionController = TextEditingController();
  final _cityController = TextEditingController();
  final _areaController = TextEditingController();
  final _messageController = TextEditingController();
  final _contactController = TextEditingController();

  QrDeviceLocation? _deviceLocation;
  late final QrApiClient _qrApiClient;
  PublicQrPet? _remotePet;
  bool _requestingLocation = false;
  bool _loadingRemotePet = false;
  String? _errorMessage;
  QrScanEvent? _sentEvent;

  @override
  void initState() {
    super.initState();
    _qrApiClient = QrApiClient(baseUrl: AppEnvironment.qrApiBaseUrl);
    if (widget.initialPet == null &&
        AppData.findPetByQrId(widget.qrId) == null) {
      unawaited(_loadRemotePet());
    }
  }

  @override
  void dispose() {
    _countryController.dispose();
    _regionController.dispose();
    _cityController.dispose();
    _areaController.dispose();
    _messageController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pet = AppData.findPetByQrId(widget.qrId) ?? widget.initialPet;
    final publicPet = pet != null
        ? _LocalQrPetView(pet)
        : (_remotePet == null ? null : _RemoteQrPetView(_remotePet!));
    final textTheme = Theme.of(context).textTheme;

    if (publicPet == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('QR seguro')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              _loadingRemotePet
                  ? 'Buscando mascota registrada para este QR...'
                  : 'No encontramos una mascota registrada para este QR.',
            ),
          ),
        ),
      );
    }

    final isLost = publicPet.isLost;

    return Scaffold(
      appBar: AppBar(title: const Text('QR seguro')),
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
                      Color(publicPet.colorHex),
                      AppColors.surface,
                      AppColors.primarySoft,
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
                        const _Pill(label: 'Mascota registrada'),
                        if (isLost)
                          const _Pill(label: 'Posible mascota perdida'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(publicPet.name, style: textTheme.headlineLarge),
                    const SizedBox(height: 8),
                    Text(
                      publicPet.breed.trim().isEmpty
                          ? publicPet.species
                          : '${publicPet.species} - ${publicPet.breed}',
                      style: textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Esta mascota está registrada en Mascotify. Para proteger a la familia, no mostramos datos privados. Podés avisar de forma segura dónde la viste.',
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const _SafetyNotice(),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Avisar que encontré o vi esta mascota',
                        style: textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'La ubicación actual solo se intenta obtener si aceptás compartirla. Si no aceptás, podés cargar una zona aproximada manual.',
                        style: textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          ElevatedButton.icon(
                            key: const ValueKey(
                              'share-current-location-button',
                            ),
                            onPressed: _requestingLocation
                                ? null
                                : _requestDeviceLocation,
                            icon: const Icon(Icons.my_location_rounded),
                            label: Text(
                              _requestingLocation
                                  ? 'Solicitando...'
                                  : 'Compartir ubicación actual',
                            ),
                          ),
                          OutlinedButton.icon(
                            key: const ValueKey('manual-location-button'),
                            onPressed: () => _scrollToManualFields(context),
                            icon: const Icon(Icons.edit_location_alt_outlined),
                            label: const Text('Cargar ubicación manual'),
                          ),
                        ],
                      ),
                      if (_deviceLocation != null) ...[
                        const SizedBox(height: 14),
                        _SuccessBox(
                          text:
                              'Ubicación compartida con consentimiento. Latitud ${_deviceLocation!.latitude.toStringAsFixed(5)}, longitud ${_deviceLocation!.longitude.toStringAsFixed(5)}.',
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                key: const ValueKey('manual-location-card'),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ubicación manual', style: textTheme.titleLarge),
                      const SizedBox(height: 14),
                      _FormGrid(
                        children: [
                          _QrField(
                            fieldKey: const ValueKey('qr-country-field'),
                            controller: _countryController,
                            label: 'País',
                          ),
                          _QrField(
                            fieldKey: const ValueKey('qr-region-field'),
                            controller: _regionController,
                            label: 'Provincia / región',
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _FormGrid(
                        children: [
                          _QrField(
                            fieldKey: const ValueKey('qr-city-field'),
                            controller: _cityController,
                            label: 'Ciudad / localidad',
                          ),
                          _QrField(
                            fieldKey: const ValueKey('qr-area-field'),
                            controller: _areaController,
                            label: 'Zona aproximada',
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _QrField(
                        fieldKey: const ValueKey('qr-message-field'),
                        controller: _messageController,
                        label: 'Comentario opcional',
                        maxLines: 3,
                      ),
                      const SizedBox(height: 12),
                      _QrField(
                        fieldKey: const ValueKey('qr-contact-field'),
                        controller: _contactController,
                        label: 'Contacto opcional',
                      ),
                      if (_errorMessage != null) ...[
                        const SizedBox(height: 12),
                        _ErrorBox(message: _errorMessage!),
                      ],
                      if (_sentEvent != null) ...[
                        const SizedBox(height: 12),
                        _SuccessBox(
                          text:
                              'Gracias. Avisamos a la familia con la información cargada.',
                        ),
                      ],
                      const SizedBox(height: 18),
                      ElevatedButton.icon(
                        key: const ValueKey('submit-secure-qr-scan-button'),
                        onPressed: () => _submit(pet, publicPet),
                        icon: const Icon(Icons.send_rounded),
                        label: const Text('Enviar aviso'),
                      ),
                    ],
                  ),
                ),
              ),
              if (_sentEvent != null) ...[
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  key: const ValueKey('open-qr-event-detail-button'),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => QrScanEventDetailScreen(
                        event: _sentEvent!,
                        pet: pet ?? publicPet.asPlaceholderPet(),
                      ),
                    ),
                  ),
                  icon: const Icon(Icons.open_in_new_rounded),
                  label: const Text('Ver detalle del evento QR'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _requestDeviceLocation() async {
    setState(() {
      _requestingLocation = true;
      _errorMessage = null;
    });
    final location = await requestQrDeviceLocation();
    if (!mounted) return;
    setState(() {
      _requestingLocation = false;
      _deviceLocation = location;
      if (location == null) {
        _errorMessage =
            'No pudimos obtener ubicación del dispositivo. Cargá una zona aproximada manual.';
      }
    });
  }

  Future<void> _loadRemotePet() async {
    setState(() {
      _loadingRemotePet = true;
      _errorMessage = null;
    });
    try {
      final remotePet = await _qrApiClient.fetchPublicPet(widget.qrId);
      if (!mounted) return;
      setState(() {
        _remotePet = remotePet;
        _loadingRemotePet = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loadingRemotePet = false;
      });
    }
  }

  void _scrollToManualFields(BuildContext context) {
    Scrollable.ensureVisible(
      context,
      alignment: 0.55,
      duration: const Duration(milliseconds: 200),
    );
  }

  Future<void> _submit(Pet? pet, _QrPetViewData publicPet) async {
    final text = [
      _areaController.text,
      _messageController.text,
      _contactController.text,
    ].join(' ');
    if (_containsPaymentIntent(text)) {
      setState(() => _errorMessage = _qrSafetyError);
      return;
    }
    if (_deviceLocation == null &&
        _areaController.text.trim().isEmpty &&
        _cityController.text.trim().isEmpty) {
      setState(
        () => _errorMessage =
            'Compartí ubicación actual o cargá ciudad/zona aproximada.',
      );
      return;
    }

    final now = DateTime.now();
    final event = QrScanEvent(
      id: 'qr-scan-${publicPet.petId}-${now.microsecondsSinceEpoch}',
      petId: publicPet.petId,
      qrId: publicPet.qrId,
      ownerUserId: AppData.currentUser.id,
      scannedAt: now,
      locationSource: _deviceLocation == null
          ? QrScanLocationSource.manual
          : QrScanLocationSource.deviceGeolocation,
      latitude: _deviceLocation?.latitude,
      longitude: _deviceLocation?.longitude,
      accuracyMeters: _deviceLocation?.accuracyMeters,
      country: _countryController.text.trim(),
      region: _regionController.text.trim(),
      city: _cityController.text.trim(),
      area: _areaController.text.trim(),
      message: _messageController.text.trim(),
      scannerContact: _contactController.text.trim(),
    );
    QrScanEvent? saved;
    try {
      saved = pet == null
          ? await _qrApiClient.submitPublicScan(qrId: widget.qrId, draft: event)
          : await AppData.submitQrScanEvent(event);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorMessage =
            'No pudimos enviar el aviso ahora. Probá nuevamente en unos segundos.';
      });
      return;
    }
    if (!mounted) return;
    setState(() {
      _sentEvent = saved;
      _errorMessage = null;
    });
  }
}

class _SafetyNotice extends StatelessWidget {
  const _SafetyNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF2C6),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        'No pidas ni pagues dinero por devolver una mascota. Mascotify no muestra teléfono, email ni dirección privada del dueño en esta página.',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          height: 1.35,
        ),
      ),
    );
  }
}

class _FormGrid extends StatelessWidget {
  const _FormGrid({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 560) {
          return Column(
            children: children
                .map(
                  (child) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: child,
                  ),
                )
                .toList(),
          );
        }
        return Row(
          children: [
            for (var i = 0; i < children.length; i++) ...[
              Expanded(child: children[i]),
              if (i != children.length - 1) const SizedBox(width: 12),
            ],
          ],
        );
      },
    );
  }
}

class _QrField extends StatelessWidget {
  const _QrField({
    required this.fieldKey,
    required this.controller,
    required this.label,
    this.maxLines = 1,
  });

  final Key fieldKey;
  final TextEditingController controller;
  final String label;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: fieldKey,
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: AppColors.surfaceAlt,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
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

class _ErrorBox extends StatelessWidget {
  const _ErrorBox({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE5E5),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(message),
    );
  }
}

class _SuccessBox extends StatelessWidget {
  const _SuccessBox({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF8F3),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(text),
    );
  }
}

bool _containsPaymentIntent(String text) {
  final normalized = text.toLowerCase();
  const blocked = [
    'cobro',
    'cobrar',
    'pagame',
    'pago',
    'plata',
    'rescate',
    'recompensa obligatoria',
    'transferencia',
    'alias',
    'cbu',
    'mercado pago',
    'depósito',
    'deposito',
  ];
  return blocked.any(normalized.contains);
}

abstract class _QrPetViewData {
  String get qrId;
  String get petId;
  String get name;
  String get species;
  String get breed;
  bool get isLost;
  int get colorHex;
  Pet asPlaceholderPet();
}

class _LocalQrPetView implements _QrPetViewData {
  const _LocalQrPetView(this.pet);

  final Pet pet;

  @override
  String get qrId => pet.qrCodeLabel;

  @override
  String get petId => pet.id;

  @override
  String get name => pet.name;

  @override
  String get species => pet.species;

  @override
  String get breed => pet.breed;

  @override
  bool get isLost {
    return AppData.lostPets.any(
      (lostPet) =>
          !lostPet.isFound &&
          lostPet.name.trim().toLowerCase() == pet.name.trim().toLowerCase(),
    );
  }

  @override
  int get colorHex => pet.colorHex;

  @override
  Pet asPlaceholderPet() => pet;
}

class _RemoteQrPetView implements _QrPetViewData {
  const _RemoteQrPetView(this.pet);

  final PublicQrPet pet;

  @override
  String get qrId => pet.qrId;

  @override
  String get petId => pet.petId;

  @override
  String get name => pet.publicName;

  @override
  String get species => pet.species;

  @override
  String get breed => pet.breed ?? '';

  @override
  bool get isLost => pet.isLost;

  @override
  int get colorHex => 0xFFDDF6F6;

  @override
  Pet asPlaceholderPet() {
    return Pet(
      id: pet.petId,
      name: pet.publicName,
      species: pet.species,
      breed: pet.breed ?? 'No informado',
      ageLabel: 'No informada',
      status: pet.isLost ? 'Perdida' : 'Registrada',
      colorHex: 0xFFDDF6F6,
      profileId: pet.petId,
      identitySummary: 'Ficha publica segura',
      documentStatus: 'Publico',
      qrStatus: 'QR publico seguro',
      healthSummary: 'No informado',
      quickActions: const [],
      qrCodeLabel: pet.qrId,
      qrEnabled: true,
      qrLastUpdate: 'QR publico',
      qrPrimaryAction: 'Avisar ubicacion',
      qrSecondaryAction: 'Contacto seguro',
      sex: 'No informado',
      location: 'No publica',
      biography: pet.publicNotes ?? '',
      personalityTags: const [],
      seekingBreeding: false,
      socialInterest: 'Contacto seguro',
      socialProfileStatus: 'Publico seguro',
      featuredMoments: const [],
      matchingPreferences: const PetMatchingPreferences(
        preferredBondType: 'No aplica',
        matchSummary: 'No aplica',
        rhythmLabel: 'No aplica',
        locationRadiusLabel: 'No aplica',
        acceptsGradualMeet: false,
        compatibilitySignals: [],
        desiredCompatibilities: [],
        softLimits: [],
        idealContext: 'No aplica',
        importantNotes: 'No aplica',
        suggestedApproach: 'No aplica',
      ),
    );
  }
}
