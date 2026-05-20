import 'package:flutter/material.dart';

import '../../../../shared/data/app_data_source.dart';
import '../../../../shared/data/pet_vaccine_suggestion_catalog.dart';
import '../../../../shared/models/pet.dart';
import '../../../../shared/models/pet_activity_event.dart';
import '../../../../shared/models/pet_vaccine.dart';
import '../../../../shared/models/pet_vaccine_suggestion.dart';
import '../../../../shared/widgets/responsive_page_body.dart';
import '../../../../theme/app_colors.dart';

class PetHealthScreen extends StatefulWidget {
  const PetHealthScreen({super.key, required this.pet});

  final Pet pet;

  @override
  State<PetHealthScreen> createState() => _PetHealthScreenState();
}

class _PetHealthScreenState extends State<PetHealthScreen> {
  Pet get _pet => AppData.findPetById(widget.pet.id) ?? widget.pet;

  @override
  Widget build(BuildContext context) {
    final pet = _pet;
    final vaccines = AppData.petVaccinesForPet(pet.id);
    final applied = vaccines.where((vaccine) => vaccine.isApplied).toList();
    final pending = vaccines.where((vaccine) => vaccine.isPending).toList();
    final nextDose = _nextDose(vaccines);
    final lastUpdate = _lastUpdate(vaccines);

    return Scaffold(
      appBar: AppBar(title: const Text('Salud y vacunas')),
      body: SafeArea(
        child: ResponsivePageBody(
          maxWidth: 920,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            children: [
              _HeaderCard(
                petName: pet.name,
                appliedCount: applied.length,
                pendingCount: pending.length,
                nextDose: nextDose,
                lastUpdate: lastUpdate,
              ),
              const SizedBox(height: 16),
              _SpeciesSuggestedVaccinesCard(
                pet: pet,
                onAddPending: _addSuggestedPending,
                onRegisterApplied: _openForm,
              ),
              const SizedBox(height: 16),
              if (vaccines.isEmpty)
                _EmptyVaccinesCard(onAdd: () => _openForm())
              else ...[
                _VaccinesSection(
                  title: 'Vacunas aplicadas',
                  emptyText: 'Sin vacunas aplicadas cargadas.',
                  vaccines: applied,
                  onEdit: _openForm,
                  onDelete: _confirmDelete,
                  onMarkApplied: _markPendingAsApplied,
                ),
                const SizedBox(height: 16),
                _VaccinesSection(
                  title: 'Vacunas pendientes',
                  emptyText: 'Sin vacunas pendientes registradas.',
                  vaccines: pending,
                  onEdit: _openForm,
                  onDelete: _confirmDelete,
                  onMarkApplied: _markPendingAsApplied,
                ),
              ],
              const SizedBox(height: 16),
              _HealthHistoryCard(pet: pet),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: const ValueKey('add-vaccine-button'),
        onPressed: () => _openForm(),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Agregar vacuna'),
      ),
    );
  }

  Future<void> _openForm([PetVaccine? vaccine]) async {
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => _VaccineFormSheet(pet: _pet, vaccine: vaccine),
    );
    if (saved == true && mounted) setState(() {});
  }

  Future<void> _addSuggestedPending(PetVaccine vaccine) async {
    await AppData.upsertPetVaccine(vaccine);
    if (mounted) setState(() {});
  }

  Future<void> _markPendingAsApplied(PetVaccine vaccine) async {
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => _MarkAppliedSheet(vaccine: vaccine),
    );
    if (saved == true && mounted) setState(() {});
  }

  Future<void> _confirmDelete(PetVaccine vaccine) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar vacuna'),
        content: const Text(
          '¿Querés eliminar esta vacuna del registro de la mascota?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            key: const ValueKey('confirm-delete-vaccine-button'),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await AppData.deletePetVaccine(vaccine.petId, vaccine.id);
    if (mounted) setState(() {});
  }

  DateTime? _nextDose(List<PetVaccine> vaccines) {
    final dates =
        vaccines
            .map((vaccine) => vaccine.nextDoseDate)
            .whereType<DateTime>()
            .toList()
          ..sort();
    if (dates.isEmpty) return null;
    return dates.first;
  }

  DateTime? _lastUpdate(List<PetVaccine> vaccines) {
    if (vaccines.isEmpty) return null;
    final dates = vaccines.map((vaccine) => vaccine.updatedAt).toList()..sort();
    return dates.last;
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({
    required this.petName,
    required this.appliedCount,
    required this.pendingCount,
    required this.nextDose,
    required this.lastUpdate,
  });

  final String petName;
  final int appliedCount;
  final int pendingCount;
  final DateTime? nextDose;
  final DateTime? lastUpdate;

  @override
  Widget build(BuildContext context) {
    final status = appliedCount == 0 && pendingCount == 0
        ? 'Sin vacunas cargadas'
        : pendingCount > 0
        ? 'Vacunas pendientes'
        : 'Vacunas al día';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(petName, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 6),
            Text(
              'Libreta sanitaria digital para vacunas y seguimiento.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 14),
            _NoticeCard(
              text:
                  'La libreta sanitaria ayuda a organizar información, pero no reemplaza la indicación de un veterinario.',
            ),
            const SizedBox(height: 14),
            Text(
              'Resumen sanitario',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            ResponsiveWrapGrid(
              minItemWidth: 160,
              children: [
                _MetricTile(label: 'Estado', value: status),
                _MetricTile(label: 'Vacunas aplicadas', value: '$appliedCount'),
                _MetricTile(
                  label: 'Vacunas pendientes',
                  value: '$pendingCount',
                ),
                _MetricTile(
                  label: 'Próxima vacuna',
                  value: nextDose == null
                      ? 'Sin fecha'
                      : _formatDate(nextDose!),
                ),
                _MetricTile(
                  label: 'Última actualización',
                  value: lastUpdate == null
                      ? 'Sin cambios'
                      : _formatDate(lastUpdate!),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SpeciesSuggestedVaccinesCard extends StatelessWidget {
  const _SpeciesSuggestedVaccinesCard({
    required this.pet,
    required this.onAddPending,
    required this.onRegisterApplied,
  });

  final Pet pet;
  final ValueChanged<PetVaccine> onAddPending;
  final ValueChanged<PetVaccine> onRegisterApplied;

  @override
  Widget build(BuildContext context) {
    final suggestionSet = PetVaccineSuggestionCatalog.forSpecies(pet.species);
    final suggestions = suggestionSet.suggestions;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vacunas sugeridas para ${suggestionSet.speciesLabel}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'La libreta sanitaria ayuda a organizar información. Las vacunas sugeridas son orientativas y no reemplazan la indicación de un veterinario.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              suggestionSet.note,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
            ),
            const SizedBox(height: 16),
            if (suggestions.isEmpty)
              _NoGeneralScheduleNotice(suggestionSet: suggestionSet)
            else
              Column(
                children: suggestions
                    .map(
                      (suggestion) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _SuggestionTile(
                          suggestion: suggestion,
                          onAddPending: () =>
                              onAddPending(_template(pet.id, suggestion)),
                          onRegisterApplied: () => onRegisterApplied(
                            _template(
                              pet.id,
                              suggestion,
                              status: PetVaccineStatus.applied,
                            ),
                          ),
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

  PetVaccine _template(
    String petId,
    PetVaccineSuggestion suggestion, {
    PetVaccineStatus status = PetVaccineStatus.pending,
  }) {
    final now = DateTime.now();
    return PetVaccine(
      id: 'vaccine-${now.microsecondsSinceEpoch}',
      petId: petId,
      name: suggestion.vaccineName,
      status: status,
      createdAt: now,
      updatedAt: now,
      notes: suggestion.note,
    );
  }
}

class _NoGeneralScheduleNotice extends StatelessWidget {
  const _NoGeneralScheduleNotice({required this.suggestionSet});

  final PetVaccineSuggestionSet suggestionSet;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            suggestionSet.emptyTitle ?? 'Sin sugerencias automáticas',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          Text(
            suggestionSet.emptyMessage ??
                'Podés registrar manualmente vacunas indicadas por un veterinario.',
          ),
        ],
      ),
    );
  }
}

class _SuggestionTile extends StatelessWidget {
  const _SuggestionTile({
    required this.suggestion,
    required this.onAddPending,
    required this.onRegisterApplied,
  });

  final PetVaccineSuggestion suggestion;
  final VoidCallback onAddPending;
  final VoidCallback onRegisterApplied;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                suggestion.vaccineName,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Chip(
                label: Text(suggestion.categoryLabel),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(suggestion.description),
          if (suggestion.note.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              suggestion.note,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
            ),
          ],
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: onAddPending,
                icon: const Icon(Icons.pending_actions_outlined),
                label: const Text('Agregar como pendiente'),
              ),
              FilledButton.icon(
                onPressed: onRegisterApplied,
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Registrar como aplicada'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyVaccinesCard extends StatelessWidget {
  const _EmptyVaccinesCard({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Todavía no cargaste vacunas',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'Agregá vacunas aplicadas o pendientes para llevar el seguimiento sanitario de esta mascota.',
            ),
            const SizedBox(height: 14),
            FilledButton.icon(
              key: const ValueKey('empty-add-vaccine-button'),
              onPressed: onAdd,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Agregar vacuna'),
            ),
          ],
        ),
      ),
    );
  }
}

class _VaccinesSection extends StatelessWidget {
  const _VaccinesSection({
    required this.title,
    required this.emptyText,
    required this.vaccines,
    required this.onEdit,
    required this.onDelete,
    required this.onMarkApplied,
  });

  final String title;
  final String emptyText;
  final List<PetVaccine> vaccines;
  final ValueChanged<PetVaccine> onEdit;
  final ValueChanged<PetVaccine> onDelete;
  final ValueChanged<PetVaccine> onMarkApplied;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            if (vaccines.isEmpty)
              Text(emptyText)
            else
              ...vaccines.map(
                (vaccine) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _VaccineTile(
                    vaccine: vaccine,
                    onEdit: () => onEdit(vaccine),
                    onDelete: () => onDelete(vaccine),
                    onMarkApplied: vaccine.isPending
                        ? () => onMarkApplied(vaccine)
                        : null,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _VaccineTile extends StatelessWidget {
  const _VaccineTile({
    required this.vaccine,
    required this.onEdit,
    required this.onDelete,
    required this.onMarkApplied,
  });

  final PetVaccine vaccine;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onMarkApplied;

  @override
  Widget build(BuildContext context) {
    final softColor = vaccine.isPending
        ? AppColors.supportSoft
        : AppColors.primarySoft;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: softColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  vaccine.isPending
                      ? Icons.schedule_rounded
                      : Icons.check_circle_outline_rounded,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vaccine.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      vaccine.isPending
                          ? 'Estado: Pendiente'
                          : 'Estado: Aplicada',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (vaccine.applicationDate != null)
            _InfoLine(
              label: 'Fecha de aplicación',
              value: _formatDate(vaccine.applicationDate!),
            ),
          if (vaccine.nextDoseDate != null)
            _InfoLine(
              label: 'Próxima dosis/refuerzo',
              value: _formatDate(vaccine.nextDoseDate!),
            ),
          if (_hasText(vaccine.clinic))
            _InfoLine(label: 'Veterinario o clínica', value: vaccine.clinic!),
          if (_hasText(vaccine.batch))
            _InfoLine(label: 'Lote o comprobante', value: vaccine.batch!),
          if (_hasText(vaccine.notes))
            _InfoLine(label: 'Notas', value: vaccine.notes!),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (onMarkApplied != null)
                OutlinedButton(
                  key: ValueKey('mark-applied-${vaccine.id}'),
                  onPressed: onMarkApplied,
                  child: const Text('Marcar como aplicada'),
                ),
              OutlinedButton(
                key: ValueKey('edit-vaccine-${vaccine.id}'),
                onPressed: onEdit,
                child: const Text('Editar'),
              ),
              TextButton(
                key: ValueKey('delete-vaccine-${vaccine.id}'),
                onPressed: onDelete,
                child: const Text('Eliminar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HealthHistoryCard extends StatelessWidget {
  const _HealthHistoryCard({required this.pet});

  final Pet pet;

  @override
  Widget build(BuildContext context) {
    final events = AppData.petActivityEventsForPet(
      pet.id,
    ).where((event) => event.type == PetActivityEventType.health).toList();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Historial', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            if (events.isEmpty)
              const Text('Todavía no hay eventos sanitarios registrados.')
            else
              ...events.map(
                (event) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _HistoryLine(event: event),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _VaccineFormSheet extends StatefulWidget {
  const _VaccineFormSheet({required this.pet, this.vaccine});

  final Pet pet;
  final PetVaccine? vaccine;

  @override
  State<_VaccineFormSheet> createState() => _VaccineFormSheetState();
}

class _VaccineFormSheetState extends State<_VaccineFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _applicationDateController;
  late final TextEditingController _nextDoseDateController;
  late final TextEditingController _clinicController;
  late final TextEditingController _batchController;
  late final TextEditingController _notesController;
  late PetVaccineStatus _status;

  @override
  void initState() {
    super.initState();
    final vaccine = widget.vaccine;
    _nameController = TextEditingController(text: vaccine?.name ?? '');
    _applicationDateController = TextEditingController(
      text: _formatOptionalDate(vaccine?.applicationDate),
    );
    _nextDoseDateController = TextEditingController(
      text: _formatOptionalDate(vaccine?.nextDoseDate),
    );
    _clinicController = TextEditingController(text: vaccine?.clinic ?? '');
    _batchController = TextEditingController(text: vaccine?.batch ?? '');
    _notesController = TextEditingController(text: vaccine?.notes ?? '');
    _status = vaccine?.status ?? PetVaccineStatus.applied;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _applicationDateController.dispose();
    _nextDoseDateController.dispose();
    _clinicController.dispose();
    _batchController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final now = DateTime.now();
    final previous = widget.vaccine;
    final vaccine = PetVaccine(
      id: previous?.id ?? 'vaccine-${now.microsecondsSinceEpoch}',
      petId: widget.pet.id,
      name: _nameController.text.trim(),
      status: _status,
      createdAt: previous?.createdAt ?? now,
      updatedAt: now,
      applicationDate: _parseDate(_applicationDateController.text),
      nextDoseDate: _parseDate(_nextDoseDateController.text),
      clinic: _optionalText(_clinicController.text),
      batch: _optionalText(_batchController.text),
      notes: _optionalText(_notesController.text),
    );
    await AppData.upsertPetVaccine(vaccine);
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 20,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.vaccine == null ? 'Agregar vacuna' : 'Editar vacuna',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 14),
              TextFormField(
                key: const ValueKey('vaccine-name-field'),
                controller: _nameController,
                decoration: _inputDecoration('Nombre de la vacuna'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingresá el nombre de la vacuna.';
                  }
                  return null;
                },
              ),
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _nameController,
                builder: (context, value, _) {
                  final warning =
                      PetVaccineSuggestionCatalog.crossSpeciesWarningFor(
                        currentSpeciesLabel: widget.pet.species,
                        vaccineName: value.text,
                      );
                  if (warning == null) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      warning,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: AppColors.support),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<PetVaccineStatus>(
                key: const ValueKey('vaccine-status-field'),
                initialValue: _status,
                decoration: _inputDecoration('Estado'),
                items: const [
                  DropdownMenuItem(
                    value: PetVaccineStatus.applied,
                    child: Text('Aplicada'),
                  ),
                  DropdownMenuItem(
                    value: PetVaccineStatus.pending,
                    child: Text('Pendiente'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _status = value);
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                key: const ValueKey('vaccine-application-date-field'),
                controller: _applicationDateController,
                decoration: _inputDecoration(
                  'Fecha de aplicación (dd/mm/aaaa)',
                ),
                validator: (value) {
                  final trimmed = value?.trim() ?? '';
                  if (_status == PetVaccineStatus.applied && trimmed.isEmpty) {
                    return 'Ingresá la fecha de aplicación.';
                  }
                  if (trimmed.isNotEmpty && _parseDate(trimmed) == null) {
                    return 'Usá formato dd/mm/aaaa.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                key: const ValueKey('vaccine-next-dose-field'),
                controller: _nextDoseDateController,
                decoration: _inputDecoration(
                  'Próxima dosis/refuerzo (opcional)',
                ),
                validator: (value) {
                  final trimmed = value?.trim() ?? '';
                  if (trimmed.isEmpty) return null;
                  final nextDose = _parseDate(trimmed);
                  if (nextDose == null) return 'Usá formato dd/mm/aaaa.';
                  final applied = _parseDate(_applicationDateController.text);
                  if (applied != null && nextDose.isBefore(applied)) {
                    return 'La próxima dosis no puede ser anterior a la aplicación.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _clinicController,
                decoration: _inputDecoration('Veterinario/clínica opcional'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _batchController,
                decoration: _inputDecoration('Lote/comprobante opcional'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _notesController,
                minLines: 2,
                maxLines: 4,
                decoration: _inputDecoration('Notas opcionales'),
              ),
              const SizedBox(height: 16),
              FilledButton(
                key: const ValueKey('save-vaccine-button'),
                onPressed: _save,
                child: const Text('Guardar vacuna'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MarkAppliedSheet extends StatefulWidget {
  const _MarkAppliedSheet({required this.vaccine});

  final PetVaccine vaccine;

  @override
  State<_MarkAppliedSheet> createState() => _MarkAppliedSheetState();
}

class _MarkAppliedSheetState extends State<_MarkAppliedSheet> {
  final _formKey = GlobalKey<FormState>();
  final _applicationDateController = TextEditingController();
  final _nextDoseController = TextEditingController();

  @override
  void dispose() {
    _applicationDateController.dispose();
    _nextDoseController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final now = DateTime.now();
    await AppData.upsertPetVaccine(
      widget.vaccine.copyWith(
        status: PetVaccineStatus.applied,
        applicationDate: _parseDate(_applicationDateController.text),
        nextDoseDate: _parseDate(_nextDoseController.text),
        updatedAt: now,
      ),
    );
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 20,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Marcar como aplicada',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: const ValueKey('mark-applied-date-field'),
              controller: _applicationDateController,
              decoration: _inputDecoration('Fecha de aplicación (dd/mm/aaaa)'),
              validator: (value) {
                final trimmed = value?.trim() ?? '';
                if (trimmed.isEmpty) return 'Ingresá la fecha de aplicación.';
                if (_parseDate(trimmed) == null) {
                  return 'Usá formato dd/mm/aaaa.';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: const ValueKey('mark-next-dose-field'),
              controller: _nextDoseController,
              decoration: _inputDecoration('Próxima dosis/refuerzo opcional'),
              validator: (value) {
                final trimmed = value?.trim() ?? '';
                if (trimmed.isEmpty) return null;
                final nextDose = _parseDate(trimmed);
                final applied = _parseDate(_applicationDateController.text);
                if (nextDose == null) return 'Usá formato dd/mm/aaaa.';
                if (applied != null && nextDose.isBefore(applied)) {
                  return 'La próxima dosis no puede ser anterior a la aplicación.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            FilledButton(
              key: const ValueKey('confirm-mark-applied-button'),
              onPressed: _save,
              child: const Text('Guardar aplicación'),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoticeCard extends StatelessWidget {
  const _NoticeCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.supportSoft,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(text),
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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
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

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text('$label: $value'),
    );
  }
}

class _HistoryLine extends StatelessWidget {
  const _HistoryLine({required this.event});

  final PetActivityEvent event;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text('${event.title}: ${event.description}'),
    );
  }
}

InputDecoration _inputDecoration(String label) {
  return InputDecoration(
    labelText: label,
    filled: true,
    fillColor: AppColors.surface,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: AppColors.border),
    ),
  );
}

DateTime? _parseDate(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) return null;
  final match = RegExp(r'^(\d{1,2})/(\d{1,2})/(\d{4})$').firstMatch(trimmed);
  if (match == null) return null;
  final day = int.tryParse(match.group(1)!);
  final month = int.tryParse(match.group(2)!);
  final year = int.tryParse(match.group(3)!);
  if (day == null || month == null || year == null) return null;
  final parsed = DateTime(year, month, day);
  if (parsed.day != day || parsed.month != month || parsed.year != year) {
    return null;
  }
  return parsed;
}

String _formatDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}

String _formatOptionalDate(DateTime? date) {
  return date == null ? '' : _formatDate(date);
}

String? _optionalText(String value) {
  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}

bool _hasText(String? value) => value != null && value.trim().isNotEmpty;
