class PlanEntitlement {
  const PlanEntitlement({
    required this.planName,
    required this.shortName,
    required this.priceLabel,
    required this.petLimitLabel,
    required this.positioningLabel,
    required this.adsLabel,
    required this.maxPets,
    this.usesFairUsePolicy = false,
  });

  final String planName;
  final String shortName;
  final String priceLabel;
  final String petLimitLabel;
  final String positioningLabel;
  final String adsLabel;
  final int? maxPets;
  final bool usesFairUsePolicy;

  bool get hasUnlimitedPets => maxPets == null;

  String get petLimitDisplayLabel {
    if (!usesFairUsePolicy) return petLimitLabel;
    return '$petLimitLabel con politica de uso razonable';
  }

  bool canAddPet(int currentPetsCount) {
    return hasUnlimitedPets || currentPetsCount < maxPets!;
  }
}

const List<PlanEntitlement> planEntitlements = [
  PlanEntitlement(
    planName: 'Mascotify Free',
    shortName: 'Free',
    priceLabel: 'US\$ 0 mensual',
    petLimitLabel: 'Hasta 1 mascota',
    positioningLabel: 'Plan base gratuito para empezar con una mascota.',
    adsLabel: 'Publicidad principalmente en Free.',
    maxPets: 1,
  ),
  PlanEntitlement(
    planName: 'Mascotify Plus',
    shortName: 'Plus',
    priceLabel: 'US\$ 1,99 mensual',
    petLimitLabel: 'Hasta 5 mascotas',
    positioningLabel:
        'Plan familiar accesible para hogares con varias mascotas.',
    adsLabel: 'Sin publicidad o con presencia minima no invasiva.',
    maxPets: 5,
  ),
  PlanEntitlement(
    planName: 'Mascotify Pro',
    shortName: 'Pro',
    priceLabel: 'US\$ 4,99 mensual',
    petLimitLabel: 'Mascotas ilimitadas',
    positioningLabel:
        'Plan profesional con mas visibilidad y perfiles ilimitados.',
    adsLabel: 'Sin publicidad o con presencia minima no invasiva.',
    maxPets: null,
    usesFairUsePolicy: true,
  ),
];

PlanEntitlement planEntitlementFor(String planName) {
  final normalized = planName.toLowerCase();
  for (final entitlement in planEntitlements) {
    if (normalized.contains(entitlement.shortName.toLowerCase())) {
      return entitlement;
    }
  }
  return planEntitlements.first;
}
