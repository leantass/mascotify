import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../shared/data/app_data_source.dart';
import '../../../../shared/models/pet.dart';
import '../../../../shared/models/plan_entitlements.dart';
import '../../../../shared/widgets/responsive_page_body.dart';
import '../../../../shared/widgets/pet_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../theme/app_colors.dart';
import 'pet_detail_screen.dart';

class PetsScreen extends StatefulWidget {
  const PetsScreen({super.key});

  @override
  State<PetsScreen> createState() => _PetsScreenState();
}

class _PetsScreenState extends State<PetsScreen> {
  @override
  Widget build(BuildContext context) {
    final pets = AppData.pets;
    final entitlement = planEntitlementFor(AppData.currentUser.planName);

    return Scaffold(
      body: SafeArea(
        child: ResponsivePageBody(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            children: [
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    SectionHeader(
                      eyebrow: 'Centro de mascotas',
                      title: 'Mascotas',
                      subtitle:
                          'Gestiona perfiles persistidos localmente y listos para crecer hacia QR, social y seguimiento.',
                      trailing: ElevatedButton.icon(
                        onPressed: _handleAddPet,
                        icon: const Icon(Icons.add_rounded),
                        label: const Text('Agregar'),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceAlt,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${pets.length} perfiles activos guardados en este dispositivo para la cuenta actual.',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${entitlement.planName}: ${entitlement.petLimitDisplayLabel}.',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (pets.isEmpty)
                const _PetsEmptyState()
              else
                ResponsiveWrapGrid(
                  minItemWidth: 340,
                  children: pets
                      .map(
                        (pet) => Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            PetCard(
                              pet: pet,
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => PetDetailScreen(pet: pet),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () => _handleEditPet(pet),
                                    icon: const Icon(Icons.edit_outlined),
                                    label: const Text('Editar'),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () => _handleDeletePet(pet),
                                    icon: const Icon(Icons.delete_outline),
                                    label: const Text('Eliminar'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleAddPet() async {
    final entitlement = planEntitlementFor(AppData.currentUser.planName);
    if (!entitlement.canAddPet(AppData.pets.length)) {
      await _showPetLimitDialog(entitlement);
      return;
    }

    final createdPet = await showDialog<Pet>(
      context: context,
      builder: (_) => const _PetFormDialog(),
    );

    if (!mounted || createdPet == null) return;

    await AppData.addPet(createdPet);
    if (!mounted) return;

    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${createdPet.name} ya quedó guardado localmente.'),
      ),
    );
  }

  Future<void> _showPetLimitDialog(PlanEntitlement entitlement) {
    final upgradeMessage = entitlement.shortName == 'Free'
        ? 'Mascotify Free permite hasta 1 mascota. Pasate a Plus por US\$ 1,99 mensual para cargar hasta 5 mascotas.'
        : 'Mascotify Plus permite hasta 5 mascotas. Pasate a Pro por US\$ 4,99 mensual para mascotas ilimitadas, con politica de uso razonable.';

    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limite de mascotas del plan'),
        content: Text(upgradeMessage),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleEditPet(Pet pet) async {
    final updatedPet = await showDialog<Pet>(
      context: context,
      builder: (_) => _PetFormDialog(initialPet: pet),
    );

    if (!mounted || updatedPet == null) return;

    await AppData.updatePet(updatedPet);
    if (!mounted) return;

    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${updatedPet.name} fue actualizado.')),
    );
  }

  Future<void> _handleDeletePet(Pet pet) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar mascota'),
        content: Text(
          'Vas a eliminar a ${pet.name} de esta cuenta. Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (!mounted || confirmed != true) return;

    await AppData.deletePet(pet.id);
    if (!mounted) return;

    setState(() {});
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${pet.name} fue eliminado.')));
  }
}

class _PetsEmptyState extends StatelessWidget {
  const _PetsEmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Todavía no hay mascotas cargadas',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'En browser conviene dejar clara la base operativa desde el primer paso: cuando agregues tu primera mascota, esta vista va a crecer con identidad, QR, matching y seguimiento persistido.',
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

class _PetFormDialog extends StatefulWidget {
  const _PetFormDialog({this.initialPet});

  final Pet? initialPet;

  @override
  State<_PetFormDialog> createState() => _PetFormDialogState();
}

class _PetFormDialogState extends State<_PetFormDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _speciesController;
  late final TextEditingController _breedController;
  late final TextEditingController _ageController;
  late final TextEditingController _locationController;
  late final TextEditingController _biographyController;

  String _selectedSex = 'Macho';
  String? _errorMessage;
  bool _isSaving = false;
  bool get _isEditing => widget.initialPet != null;

  @override
  void initState() {
    super.initState();
    final initialPet = widget.initialPet;
    _nameController = TextEditingController(text: initialPet?.name ?? '');
    _speciesController = TextEditingController(
      text: initialPet?.species ?? 'Mascota',
    );
    _breedController = TextEditingController(text: initialPet?.breed ?? '');
    _ageController = TextEditingController(text: initialPet?.ageLabel ?? '');
    _locationController = TextEditingController(
      text: initialPet?.location ?? '',
    );
    _biographyController = TextEditingController(
      text: initialPet?.biography ?? '',
    );
    _selectedSex = initialPet?.sex ?? 'Macho';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _speciesController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    _locationController.dispose();
    _biographyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.pets_rounded,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _isEditing ? 'Editar mascota' : 'Alta de mascota',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                _isEditing
                    ? 'Actualizá los datos principales de esta mascota sin duplicar su perfil.'
                    : 'Este formulario ya crea una mascota real en almacenamiento local para la cuenta actual.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 18),
              _PetField(controller: _nameController, label: 'Nombre'),
              const SizedBox(height: 12),
              _PetField(controller: _speciesController, label: 'Especie'),
              const SizedBox(height: 12),
              _PetField(controller: _breedController, label: 'Raza'),
              const SizedBox(height: 12),
              _PetField(
                controller: _ageController,
                label: 'Edad',
                hintText: 'Ej: 2 años',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 12),
              _PetField(
                controller: _locationController,
                label: 'Ubicación',
                hintText: 'Ej: Palermo, Buenos Aires',
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _selectedSex,
                decoration: InputDecoration(
                  labelText: 'Sexo',
                  filled: true,
                  fillColor: AppColors.surfaceAlt,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: 'Macho', child: Text('Macho')),
                  DropdownMenuItem(value: 'Hembra', child: Text('Hembra')),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _selectedSex = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              _PetField(
                controller: _biographyController,
                label: 'Descripción breve',
                maxLines: 3,
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE5E5),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isSaving
                          ? null
                          : () => Navigator.of(context).pop(),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _savePet,
                      child: Text(_isSaving ? 'Guardando...' : 'Guardar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _savePet() {
    final name = _nameController.text.trim();
    final species = _speciesController.text.trim();
    final breed = _breedController.text.trim();
    final ageLabel = _ageController.text.trim();
    final location = _locationController.text.trim();
    final biography = _biographyController.text.trim();

    if (name.isEmpty ||
        species.isEmpty ||
        breed.isEmpty ||
        ageLabel.isEmpty ||
        location.isEmpty) {
      setState(() {
        _errorMessage =
            'Completa al menos nombre, especie, raza, edad y ubicación.';
      });
      return;
    }

    if (int.tryParse(ageLabel) == null) {
      setState(() {
        _errorMessage = 'La edad debe ser un valor numérico.';
      });
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    final initialPet = widget.initialPet;
    if (initialPet != null) {
      Navigator.of(context).pop(
        initialPet.copyWith(
          name: name,
          species: species,
          breed: breed,
          ageLabel: ageLabel,
          colorHex: _colorForSpecies(species),
          sex: _selectedSex,
          location: location,
          biography: biography.isEmpty
              ? '$name ya tiene una base persistida y lista para seguir completándose.'
              : biography,
          personalityTags: _tagsForSpecies(species),
        ),
      );
      return;
    }

    final now = DateTime.now();
    final shortName = name
        .replaceAll(RegExp(r'[^A-Za-z]'), '')
        .toUpperCase()
        .padRight(4, 'X')
        .substring(0, 4);
    final profileSuffix = (now.microsecondsSinceEpoch % 10000)
        .toString()
        .padLeft(4, '0');

    final pet = Pet(
      id: 'pet-${now.microsecondsSinceEpoch}',
      name: name,
      species: species,
      breed: breed,
      ageLabel: ageLabel,
      status: 'Perfil base guardado',
      colorHex: _colorForSpecies(species),
      profileId: 'MSC-$shortName-$profileSuffix',
      identitySummary:
          'Perfil base persistido localmente para empezar a centralizar identidad y evolución dentro de Mascotify.',
      documentStatus:
          'Base creada. Queda pendiente completar documentos y controles.',
      qrStatus: 'QR listo para activarse cuando decidas configurarlo.',
      healthSummary:
          'Resumen inicial creado. Luego podrás sumar más contexto de salud.',
      quickActions: const ['Ver perfil', 'Actualizar datos', 'Activar QR'],
      qrCodeLabel: 'MSC-$shortName-$profileSuffix',
      qrEnabled: false,
      qrLastUpdate: 'Creado hoy',
      qrPrimaryAction: 'Activar QR',
      qrSecondaryAction: 'Configurar placa',
      sex: _selectedSex,
      location: location,
      biography: biography.isEmpty
          ? '$name ya tiene una base persistida y lista para seguir completándose.'
          : biography,
      personalityTags: _tagsForSpecies(species),
      seekingBreeding: false,
      socialInterest:
          'Perfil inicial listo para crecer hacia matching y conexiones futuras.',
      socialProfileStatus:
          'Base social creada. Todavía puede enriquecerse con más señales.',
      featuredMoments: const [
        'Primer perfil',
        'Base persistida',
        'Listo para crecer',
      ],
      matchingPreferences: const PetMatchingPreferences(
        preferredBondType: 'Vínculo gradual y seguro',
        matchSummary:
            'Base inicial creada para que después puedas ajustar mejor compatibilidades, ritmo y contexto.',
        rhythmLabel: 'A definir',
        locationRadiusLabel: 'Hasta 8 km',
        acceptsGradualMeet: true,
        compatibilitySignals: [
          'Perfil inicial persistido',
          'Listo para sumar más contexto',
          'Base preparada para matching futuro',
        ],
        desiredCompatibilities: [
          'Entornos cuidados',
          'Interacciones claras',
          'Ritmo gradual',
        ],
        softLimits: [
          'Conviene completar mejor el perfil antes de exponerlo mucho',
          'La compatibilidad todavía necesita más señales reales',
        ],
        idealContext:
            'Primero conviene completar identidad, salud y señales básicas del perfil.',
        importantNotes:
            'Es una base local real, pero todavía no representa una ficha plenamente curada.',
        suggestedApproach:
            'Completa datos esenciales y luego suma QR, social y preferencias con más criterio.',
      ),
    );

    Navigator.of(context).pop(pet);
  }

  int _colorForSpecies(String species) {
    final normalized = species.trim().toLowerCase();
    if (normalized.contains('gato')) return 0xFFFFE1EA;
    if (normalized.contains('perro')) return 0xFFDDF6F6;
    return 0xFFFFF2C6;
  }

  List<String> _tagsForSpecies(String species) {
    final normalized = species.trim().toLowerCase();
    if (normalized.contains('gato')) {
      return const ['Curioso', 'Observador', 'En crecimiento'];
    }
    if (normalized.contains('perro')) {
      return const ['Compañero', 'Activo', 'En crecimiento'];
    }
    return const ['Perfil base', 'En crecimiento', 'Mascotify'];
  }
}

class _PetField extends StatelessWidget {
  const _PetField({
    required this.controller,
    required this.label,
    this.hintText,
    this.maxLines = 1,
    this.keyboardType,
    this.inputFormatters,
  });

  final TextEditingController controller;
  final String label;
  final String? hintText;
  final int maxLines;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        filled: true,
        fillColor: AppColors.surfaceAlt,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
