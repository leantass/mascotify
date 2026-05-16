class LocationCountry {
  const LocationCountry({
    required this.code,
    required this.name,
    required this.regions,
  });

  final String code;
  final String name;
  final List<LocationRegion> regions;
}

class LocationRegion {
  const LocationRegion({required this.name, required this.cities});

  final String name;
  final List<String> cities;
}

class LocationCatalog {
  const LocationCatalog._();

  static const otherCity = 'Otra localidad';

  static const countries = <LocationCountry>[
    LocationCountry(
      code: 'AR',
      name: 'Argentina',
      regions: [
        LocationRegion(
          name: 'Buenos Aires',
          cities: [
            'La Plata',
            'Mar del Plata',
            'Bahía Blanca',
            'Tandil',
            'San Isidro',
            'Quilmes',
            otherCity,
          ],
        ),
        LocationRegion(
          name: 'Ciudad Autónoma de Buenos Aires',
          cities: ['CABA', 'Palermo', 'Recoleta', 'Caballito', otherCity],
        ),
        LocationRegion(
          name: 'Catamarca',
          cities: ['San Fernando del Valle de Catamarca', otherCity],
        ),
        LocationRegion(
          name: 'Chaco',
          cities: ['Resistencia', 'Presidencia Roque Sáenz Peña', otherCity],
        ),
        LocationRegion(
          name: 'Chubut',
          cities: ['Rawson', 'Comodoro Rivadavia', 'Puerto Madryn', otherCity],
        ),
        LocationRegion(
          name: 'Córdoba',
          cities: ['Córdoba', 'Río Cuarto', 'Villa Carlos Paz', otherCity],
        ),
        LocationRegion(
          name: 'Corrientes',
          cities: ['Corrientes', 'Goya', otherCity],
        ),
        LocationRegion(
          name: 'Entre Ríos',
          cities: ['Paraná', 'Concordia', 'Gualeguaychú', otherCity],
        ),
        LocationRegion(name: 'Formosa', cities: ['Formosa', otherCity]),
        LocationRegion(
          name: 'Jujuy',
          cities: ['San Salvador de Jujuy', 'Palpalá', otherCity],
        ),
        LocationRegion(
          name: 'La Pampa',
          cities: ['Santa Rosa', 'General Pico', otherCity],
        ),
        LocationRegion(name: 'La Rioja', cities: ['La Rioja', otherCity]),
        LocationRegion(
          name: 'Mendoza',
          cities: ['Mendoza', 'San Rafael', 'Godoy Cruz', otherCity],
        ),
        LocationRegion(
          name: 'Misiones',
          cities: ['Posadas', 'Oberá', 'Puerto Iguazú', otherCity],
        ),
        LocationRegion(
          name: 'Neuquén',
          cities: ['Neuquén', 'San Martín de los Andes', otherCity],
        ),
        LocationRegion(
          name: 'Río Negro',
          cities: ['Viedma', 'Bariloche', 'General Roca', otherCity],
        ),
        LocationRegion(name: 'Salta', cities: ['Salta', 'Orán', otherCity]),
        LocationRegion(
          name: 'San Juan',
          cities: ['San Juan', 'Rawson', otherCity],
        ),
        LocationRegion(
          name: 'San Luis',
          cities: ['San Luis', 'Villa Mercedes', otherCity],
        ),
        LocationRegion(
          name: 'Santa Cruz',
          cities: ['Río Gallegos', 'El Calafate', otherCity],
        ),
        LocationRegion(
          name: 'Santa Fe',
          cities: ['Santa Fe', 'Rosario', 'Rafaela', otherCity],
        ),
        LocationRegion(
          name: 'Santiago del Estero',
          cities: ['Santiago del Estero', 'La Banda', otherCity],
        ),
        LocationRegion(
          name: 'Tierra del Fuego',
          cities: ['Ushuaia', 'Río Grande', otherCity],
        ),
        LocationRegion(
          name: 'Tucumán',
          cities: ['San Miguel de Tucumán', 'Yerba Buena', otherCity],
        ),
      ],
    ),
    LocationCountry(code: 'UY', name: 'Uruguay', regions: []),
    LocationCountry(code: 'CL', name: 'Chile', regions: []),
    LocationCountry(code: 'BR', name: 'Brasil', regions: []),
    LocationCountry(code: 'PY', name: 'Paraguay', regions: []),
    LocationCountry(code: 'BO', name: 'Bolivia', regions: []),
    LocationCountry(code: 'US', name: 'Estados Unidos', regions: []),
    LocationCountry(code: 'ES', name: 'España', regions: []),
    LocationCountry(code: 'OTHER', name: 'Otro país', regions: []),
  ];

  static LocationCountry countryForName(String name) {
    final normalized = name.trim().toLowerCase();
    return countries.firstWhere(
      (country) => country.name.toLowerCase() == normalized,
      orElse: () => countries.first,
    );
  }

  static List<LocationRegion> regionsForCountry(String countryName) {
    return countryForName(countryName).regions;
  }

  static String display({
    required String country,
    required String region,
    required String city,
    required String freeText,
  }) {
    final parts = <String>[
      if (city.trim().isNotEmpty && city != otherCity) city.trim(),
      if (freeText.trim().isNotEmpty) freeText.trim(),
      if (region.trim().isNotEmpty) region.trim(),
      if (country.trim().isNotEmpty) country.trim(),
    ];
    return parts.join(', ');
  }
}
