class PetSpeciesOption {
  const PetSpeciesOption({
    required this.id,
    required this.label,
    required this.breeds,
  });

  final String id;
  final String label;
  final List<String> breeds;
}

class PetSpeciesCatalog {
  const PetSpeciesCatalog._();

  static const mixedBreed = 'Mestizo / Sin raza definida';
  static const other = 'Otra';

  static const species = <PetSpeciesOption>[
    PetSpeciesOption(
      id: 'dog',
      label: 'Perro',
      breeds: [
        mixedBreed,
        'Labrador Retriever',
        'Golden Retriever',
        'Caniche / Poodle',
        'Pastor Alemán',
        'Bulldog Francés',
        'Beagle',
        'Dachshund / Salchicha',
        'Border Collie',
        other,
      ],
    ),
    PetSpeciesOption(
      id: 'cat',
      label: 'Gato',
      breeds: [
        mixedBreed,
        'Siamés',
        'Persa',
        'Maine Coon',
        'Bengalí',
        'Ragdoll',
        'Británico de pelo corto',
        'Esfinge / Sphynx',
        other,
      ],
    ),
    PetSpeciesOption(
      id: 'rabbit',
      label: 'Conejo',
      breeds: [
        mixedBreed,
        'Enano',
        'Belier / Lop',
        'Angora',
        'Cabeza de león',
        other,
      ],
    ),
    PetSpeciesOption(
      id: 'hamster',
      label: 'Hámster',
      breeds: ['Sirio', 'Ruso', 'Roborovski', 'Chino', other],
    ),
    PetSpeciesOption(
      id: 'guinea_pig',
      label: 'Cobayo / Cuy',
      breeds: ['Americano', 'Abisinio', 'Peruano', 'Sheltie', other],
    ),
    PetSpeciesOption(
      id: 'ferret',
      label: 'Hurón',
      breeds: ['Sable', 'Albino', 'Champagne', 'Canela', other],
    ),
    PetSpeciesOption(
      id: 'bird',
      label: 'Ave',
      breeds: ['Ave pequeña', 'Ave mediana', 'Ave grande', other],
    ),
    PetSpeciesOption(
      id: 'parrot',
      label: 'Loro',
      breeds: ['Amazona', 'Yaco', 'Cotorra', 'Guacamayo', other],
    ),
    PetSpeciesOption(
      id: 'canary',
      label: 'Canario',
      breeds: ['Timbrado', 'Roller', 'Malinois', 'Color', other],
    ),
    PetSpeciesOption(
      id: 'fish',
      label: 'Pez',
      breeds: ['Betta', 'Goldfish', 'Guppy', 'Tetra', 'Cíclido', other],
    ),
    PetSpeciesOption(
      id: 'turtle',
      label: 'Tortuga',
      breeds: ['Acuática', 'Terrestre', 'Semiacuática', other],
    ),
    PetSpeciesOption(
      id: 'domestic_reptile',
      label: 'Reptil doméstico',
      breeds: [
        'Gecko leopardo',
        'Dragón barbudo',
        'Iguana',
        'Serpiente',
        other,
      ],
    ),
    PetSpeciesOption(
      id: 'horse',
      label: 'Caballo',
      breeds: [
        mixedBreed,
        'Criollo',
        'Pura sangre',
        'Cuarto de milla',
        'Árabe',
        other,
      ],
    ),
    PetSpeciesOption(id: 'other', label: 'Otro', breeds: [other]),
  ];

  static PetSpeciesOption optionForLabel(String label) {
    final normalized = label.trim().toLowerCase();
    return species.firstWhere(
      (item) => item.label.toLowerCase() == normalized,
      orElse: () => species.last,
    );
  }

  static List<String> breedOptionsForSpecies(String speciesLabel) {
    return optionForLabel(speciesLabel).breeds;
  }
}
