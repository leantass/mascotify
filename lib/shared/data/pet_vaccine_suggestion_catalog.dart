import '../models/pet_vaccine_suggestion.dart';

class PetVaccineSuggestionSet {
  const PetVaccineSuggestionSet({
    required this.speciesKey,
    required this.speciesLabel,
    required this.note,
    required this.suggestions,
    this.emptyTitle,
    this.emptyMessage,
  });

  final String speciesKey;
  final String speciesLabel;
  final String note;
  final List<PetVaccineSuggestion> suggestions;
  final String? emptyTitle;
  final String? emptyMessage;

  bool get hasSuggestions => suggestions.isNotEmpty;
}

class PetVaccineSuggestionCatalog {
  const PetVaccineSuggestionCatalog._();

  static const _sourceLabel = 'Plantilla local/demo editable';

  static PetVaccineSuggestionSet forSpecies(String speciesLabel) {
    final key = speciesKeyFor(speciesLabel);
    return _sets[key] ?? _sets['other']!;
  }

  static String speciesKeyFor(String speciesLabel) {
    final normalized = _normalize(speciesLabel);
    if (normalized.contains('perro')) return 'dog';
    if (normalized.contains('gato') || normalized.contains('gata')) {
      return 'cat';
    }
    if (normalized.contains('conejo')) return 'rabbit';
    if (normalized.contains('hamster')) return 'rodent';
    if (normalized.contains('cobayo') || normalized.contains('cuy')) {
      return 'rodent';
    }
    if (normalized.contains('chinchilla') ||
        normalized.contains('raton') ||
        normalized.contains('roedor')) {
      return 'rodent';
    }
    if (normalized.contains('huron')) return 'ferret';
    if (normalized.contains('ave') ||
        normalized.contains('loro') ||
        normalized.contains('canario')) {
      return 'bird';
    }
    if (normalized.contains('pez')) return 'fish';
    if (normalized.contains('tortuga') || normalized.contains('reptil')) {
      return 'reptile';
    }
    if (normalized.contains('caballo')) return 'horse';
    return 'other';
  }

  static String? crossSpeciesWarningFor({
    required String currentSpeciesLabel,
    required String vaccineName,
  }) {
    final currentKey = speciesKeyFor(currentSpeciesLabel);
    final normalizedName = _normalize(vaccineName);
    if (normalizedName.length < 4) return null;

    final currentSet = _sets[currentKey];
    if (currentSet != null) {
      for (final suggestion in currentSet.suggestions) {
        final suggestionName = _normalize(suggestion.vaccineName);
        if (suggestionName == normalizedName ||
            suggestionName.contains(normalizedName) ||
            normalizedName.contains(suggestionName)) {
          return null;
        }
      }
    }

    for (final entry in _sets.entries) {
      final speciesKey = entry.key;
      if (speciesKey == currentKey || speciesKey == 'other') continue;
      for (final suggestion in entry.value.suggestions) {
        if (suggestion.isManualOnly) continue;
        final suggestionName = _normalize(suggestion.vaccineName);
        if (suggestionName == normalizedName ||
            suggestionName.contains(normalizedName) ||
            normalizedName.contains(suggestionName)) {
          return 'Esta vacuna suele figurar asociada a otra especie. Confirmá con un veterinario antes de registrarla.';
        }
      }
    }
    return null;
  }

  static const _sets = <String, PetVaccineSuggestionSet>{
    'dog': PetVaccineSuggestionSet(
      speciesKey: 'dog',
      speciesLabel: 'Perro',
      note:
          'Las vacunas sugeridas para perros dependen de edad, zona, estilo de vida y criterio veterinario.',
      suggestions: [
        PetVaccineSuggestion(
          id: 'dog-rabies',
          speciesKey: 'dog',
          vaccineName: 'Antirrábica',
          category: PetVaccineSuggestionCategory.base,
          description: 'Plantilla común para registrar vacuna antirrábica.',
          note: 'Confirmar esquema vigente con veterinario.',
          sourceLabel: _sourceLabel,
        ),
        PetVaccineSuggestion(
          id: 'dog-multiple',
          speciesKey: 'dog',
          vaccineName: 'Múltiple canina / quíntuple / séxtuple',
          category: PetVaccineSuggestionCategory.base,
          description: 'Plantilla editable para vacunas múltiples caninas.',
          note: 'Puede variar por producto, país y criterio profesional.',
          sourceLabel: _sourceLabel,
        ),
        PetVaccineSuggestion(
          id: 'dog-distemper',
          speciesKey: 'dog',
          vaccineName: 'Moquillo / distemper',
          category: PetVaccineSuggestionCategory.base,
          description: 'Plantilla de organización para distemper canino.',
          note: 'No define dosis ni calendario obligatorio.',
          sourceLabel: _sourceLabel,
        ),
        PetVaccineSuggestion(
          id: 'dog-parvovirus',
          speciesKey: 'dog',
          vaccineName: 'Parvovirus',
          category: PetVaccineSuggestionCategory.base,
          description: 'Plantilla editable para registro de parvovirus.',
          note: 'Consultar esquema con veterinario.',
          sourceLabel: _sourceLabel,
        ),
        PetVaccineSuggestion(
          id: 'dog-adenovirus',
          speciesKey: 'dog',
          vaccineName: 'Adenovirus / hepatitis infecciosa canina',
          category: PetVaccineSuggestionCategory.base,
          description: 'Plantilla para registro sanitario canino.',
          note: 'Puede estar incluida en vacunas múltiples.',
          sourceLabel: _sourceLabel,
        ),
        PetVaccineSuggestion(
          id: 'dog-leptospirosis',
          speciesKey: 'dog',
          vaccineName: 'Leptospirosis',
          category: PetVaccineSuggestionCategory.riskBased,
          description: 'Sugerencia por riesgo o zona.',
          note: 'Registrar solo si corresponde según veterinario.',
          sourceLabel: _sourceLabel,
          isRiskBased: true,
        ),
        PetVaccineSuggestion(
          id: 'dog-bordetella',
          speciesKey: 'dog',
          vaccineName: 'Bordetella',
          category: PetVaccineSuggestionCategory.riskBased,
          description: 'Sugerencia según exposición y convivencia.',
          note: 'Confirmar indicación profesional.',
          sourceLabel: _sourceLabel,
          isRiskBased: true,
        ),
        PetVaccineSuggestion(
          id: 'dog-influenza',
          speciesKey: 'dog',
          vaccineName: 'Influenza canina',
          category: PetVaccineSuggestionCategory.riskBased,
          description: 'Sugerencia por riesgo/exposición.',
          note: 'Puede no aplicar en todos los países.',
          sourceLabel: _sourceLabel,
          isRiskBased: true,
        ),
        PetVaccineSuggestion(
          id: 'dog-giardia',
          speciesKey: 'dog',
          vaccineName: 'Giardia',
          category: PetVaccineSuggestionCategory.consultVet,
          description: 'Solo si el veterinario la indica.',
          note: 'No registrar como obligatoria.',
          sourceLabel: _sourceLabel,
          isRiskBased: true,
        ),
        PetVaccineSuggestion(
          id: 'dog-coronavirus',
          speciesKey: 'dog',
          vaccineName: 'Coronavirus canino',
          category: PetVaccineSuggestionCategory.consultVet,
          description: 'Solo si el veterinario la indica.',
          note: 'Puede no formar parte de esquemas habituales.',
          sourceLabel: _sourceLabel,
          isRiskBased: true,
        ),
      ],
    ),
    'cat': PetVaccineSuggestionSet(
      speciesKey: 'cat',
      speciesLabel: 'Gato',
      note:
          'Las vacunas sugeridas para gatos dependen de si vive adentro, sale al exterior, convive con otros gatos y criterio veterinario.',
      suggestions: [
        PetVaccineSuggestion(
          id: 'cat-triple',
          speciesKey: 'cat',
          vaccineName: 'Triple felina',
          category: PetVaccineSuggestionCategory.base,
          description: 'Plantilla común de organización para gatos.',
          note: 'Confirmar esquema con veterinario.',
          sourceLabel: _sourceLabel,
        ),
        PetVaccineSuggestion(
          id: 'cat-panleukopenia',
          speciesKey: 'cat',
          vaccineName: 'Panleucopenia felina',
          category: PetVaccineSuggestionCategory.base,
          description: 'Plantilla editable para registro felino.',
          note: 'Puede estar incluida en triple felina.',
          sourceLabel: _sourceLabel,
        ),
        PetVaccineSuggestion(
          id: 'cat-calicivirus',
          speciesKey: 'cat',
          vaccineName: 'Calicivirus felino',
          category: PetVaccineSuggestionCategory.base,
          description: 'Plantilla editable para registro felino.',
          note: 'Confirmar con veterinario.',
          sourceLabel: _sourceLabel,
        ),
        PetVaccineSuggestion(
          id: 'cat-herpesvirus',
          speciesKey: 'cat',
          vaccineName: 'Herpesvirus felino',
          category: PetVaccineSuggestionCategory.base,
          description: 'Plantilla editable para registro felino.',
          note: 'Confirmar con veterinario.',
          sourceLabel: _sourceLabel,
        ),
        PetVaccineSuggestion(
          id: 'cat-rabies',
          speciesKey: 'cat',
          vaccineName: 'Antirrábica',
          category: PetVaccineSuggestionCategory.base,
          description: 'Plantilla común para registro antirrábico.',
          note: 'Puede variar por región y normativa.',
          sourceLabel: _sourceLabel,
        ),
        PetVaccineSuggestion(
          id: 'cat-leukemia',
          speciesKey: 'cat',
          vaccineName: 'Leucemia felina',
          category: PetVaccineSuggestionCategory.riskBased,
          description: 'Sugerencia según convivencia y exposición.',
          note: 'Registrar solo si corresponde según veterinario.',
          sourceLabel: _sourceLabel,
          isRiskBased: true,
        ),
        PetVaccineSuggestion(
          id: 'cat-chlamydia',
          speciesKey: 'cat',
          vaccineName: 'Clamidiosis',
          category: PetVaccineSuggestionCategory.riskBased,
          description: 'Sugerencia por riesgo o indicación profesional.',
          note: 'No aplica como regla universal.',
          sourceLabel: _sourceLabel,
          isRiskBased: true,
        ),
        PetVaccineSuggestion(
          id: 'cat-bordetella',
          speciesKey: 'cat',
          vaccineName: 'Bordetella felina',
          category: PetVaccineSuggestionCategory.riskBased,
          description: 'Sugerencia según exposición.',
          note: 'Confirmar con veterinario.',
          sourceLabel: _sourceLabel,
          isRiskBased: true,
        ),
      ],
    ),
    'horse': PetVaccineSuggestionSet(
      speciesKey: 'horse',
      speciesLabel: 'Caballo',
      note:
          'Las vacunas equinas dependen de región, actividad, viajes, exposición y criterio veterinario. No usar vacunas de perro/gato en caballos.',
      suggestions: [
        PetVaccineSuggestion(
          id: 'horse-tetanus',
          speciesKey: 'horse',
          vaccineName: 'Tétanos',
          category: PetVaccineSuggestionCategory.base,
          description: 'Plantilla orientativa para registro equino.',
          note: 'Confirmar esquema con veterinario equino.',
          sourceLabel: _sourceLabel,
        ),
        PetVaccineSuggestion(
          id: 'horse-encephalomyelitis',
          speciesKey: 'horse',
          vaccineName: 'Encefalomielitis equina Este/Oeste',
          category: PetVaccineSuggestionCategory.base,
          description: 'Plantilla orientativa para registro equino.',
          note: 'Puede variar por región.',
          sourceLabel: _sourceLabel,
        ),
        PetVaccineSuggestion(
          id: 'horse-west-nile',
          speciesKey: 'horse',
          vaccineName: 'Virus del Nilo Occidental',
          category: PetVaccineSuggestionCategory.base,
          description: 'Plantilla orientativa por región/riesgo.',
          note: 'Confirmar disponibilidad local.',
          sourceLabel: _sourceLabel,
        ),
        PetVaccineSuggestion(
          id: 'horse-rabies',
          speciesKey: 'horse',
          vaccineName: 'Rabia',
          category: PetVaccineSuggestionCategory.base,
          description: 'Plantilla orientativa para registro.',
          note: 'Confirmar normativa y región.',
          sourceLabel: _sourceLabel,
        ),
        PetVaccineSuggestion(
          id: 'horse-influenza',
          speciesKey: 'horse',
          vaccineName: 'Influenza equina',
          category: PetVaccineSuggestionCategory.riskBased,
          description: 'Sugerencia según actividad, viajes o exposición.',
          note: 'Confirmar con veterinario.',
          sourceLabel: _sourceLabel,
          isRiskBased: true,
        ),
        PetVaccineSuggestion(
          id: 'horse-herpesvirus',
          speciesKey: 'horse',
          vaccineName: 'Rinoneumonitis / herpesvirus equino',
          category: PetVaccineSuggestionCategory.riskBased,
          description: 'Sugerencia según exposición y actividad.',
          note: 'Confirmar con veterinario.',
          sourceLabel: _sourceLabel,
          isRiskBased: true,
        ),
        PetVaccineSuggestion(
          id: 'horse-strangles',
          speciesKey: 'horse',
          vaccineName: 'Adenitis equina',
          category: PetVaccineSuggestionCategory.riskBased,
          description: 'Si corresponde por zona o exposición.',
          note: 'No aplica como regla universal.',
          sourceLabel: _sourceLabel,
          isRiskBased: true,
        ),
      ],
    ),
    'rabbit': PetVaccineSuggestionSet(
      speciesKey: 'rabbit',
      speciesLabel: 'Conejo',
      note:
          'Las vacunas para conejos dependen del país, disponibilidad y criterio veterinario. No usar vacunas de perro/gato.',
      suggestions: [
        PetVaccineSuggestion(
          id: 'rabbit-myxomatosis',
          speciesKey: 'rabbit',
          vaccineName: 'Mixomatosis',
          category: PetVaccineSuggestionCategory.base,
          description: 'Plantilla según disponibilidad regiónal.',
          note: 'Confirmar con veterinario de exoticos.',
          sourceLabel: _sourceLabel,
        ),
        PetVaccineSuggestion(
          id: 'rabbit-rhd',
          speciesKey: 'rabbit',
          vaccineName: 'Enfermedad hemorrágica viral del conejo / RHD / RVHD',
          category: PetVaccineSuggestionCategory.base,
          description: 'Plantilla según país y disponibilidad.',
          note: 'Confirmar variante y disponibilidad local.',
          sourceLabel: _sourceLabel,
        ),
        PetVaccineSuggestion(
          id: 'rabbit-rvhd',
          speciesKey: 'rabbit',
          vaccineName: 'RVHD1 / RVHD2',
          category: PetVaccineSuggestionCategory.consultVet,
          description: 'Si corresponde por país o disponibilidad.',
          note: 'Confirmar con veterinario.',
          sourceLabel: _sourceLabel,
          isRiskBased: true,
        ),
      ],
    ),
    'ferret': PetVaccineSuggestionSet(
      speciesKey: 'ferret',
      speciesLabel: 'Hurón',
      note:
          'En hurones las vacunas deben definirse con veterinario, usando productos adecuados para la especie cuando esten disponibles.',
      suggestions: [
        PetVaccineSuggestion(
          id: 'ferret-distemper',
          speciesKey: 'ferret',
          vaccineName: 'Moquillo canino / distemper',
          category: PetVaccineSuggestionCategory.base,
          description: 'Plantilla orientativa para hurones.',
          note: 'Confirmar producto adecuado para la especie.',
          sourceLabel: _sourceLabel,
        ),
        PetVaccineSuggestion(
          id: 'ferret-rabies',
          speciesKey: 'ferret',
          vaccineName: 'Rabia',
          category: PetVaccineSuggestionCategory.base,
          description: 'Plantilla orientativa para registro.',
          note: 'Confirmar normativa y producto adecuado.',
          sourceLabel: _sourceLabel,
        ),
      ],
    ),
    'bird': PetVaccineSuggestionSet(
      speciesKey: 'bird',
      speciesLabel: 'Ave',
      note:
          'En aves no hay un esquema único para todas las especies. Consultá un veterinario especializado en aves.',
      emptyTitle: 'Sin esquema general automático',
      emptyMessage:
          'Podrías registrar manualmente vacunas indicadas por un veterinario especializado. Algunas consultas pueden incluir poliomavirus aviar, Newcastle o influenza aviar según especie, región y exposición.',
      suggestions: [],
    ),
    'reptile': PetVaccineSuggestionSet(
      speciesKey: 'reptile',
      speciesLabel: 'Reptil',
      note:
          'En reptiles el seguimiento suele centrarse en controles, manejo, alimentacion, hábitat y prevención. Consultá un veterinario especializado.',
      emptyTitle: 'Sin vacunas rutinarias generales registradas',
      emptyMessage:
          'Podés registrar manualmente controles o vacunas indicadas por un veterinario. No se muestran vacunas de perro, gato ni caballo para reptiles.',
      suggestions: [],
    ),
    'fish': PetVaccineSuggestionSet(
      speciesKey: 'fish',
      speciesLabel: 'Pez',
      note:
          'En peces domesticos el cuidado preventivo suele centrarse en calidad del agua, cuarentena y controles. Consulta un especialista si corresponde.',
      emptyTitle: 'Sin vacunas hogareñas rutinarias',
      emptyMessage:
          'Podés usar la carga manual si un profesional indicó una vacuna o control especifico.',
      suggestions: [],
    ),
    'rodent': PetVaccineSuggestionSet(
      speciesKey: 'rodent',
      speciesLabel: 'Pequeno mamifero',
      note:
          'En pequeños mamíferos las vacunas dependen de especie, país y criterio veterinario. Usá carga manual si un profesional indicó una vacuna.',
      emptyTitle: 'Sin vacunas rutinarias generales registradas',
      emptyMessage:
          'No hay calendario universal para esta especie en Mascotify. Registra manualmente solo indicaciónes profesionales.',
      suggestions: [],
    ),
    'other': PetVaccineSuggestionSet(
      speciesKey: 'other',
      speciesLabel: 'Otro',
      note: 'Cargá únicamente vacunas indicadas por un veterinario.',
      emptyTitle: 'No hay sugerencias automáticas para esta especie',
      emptyMessage:
          'Podés registrar manualmente vacunas, controles o notas indicadas por un profesional.',
      suggestions: [],
    ),
  };

  static String _normalize(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ü', 'u')
        .replaceAll('ñ', 'n');
  }
}
