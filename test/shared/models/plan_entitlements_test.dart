import 'package:flutter_test/flutter_test.dart';
import 'package:mascotify/shared/models/plan_entitlements.dart';

void main() {
  test('plan entitlements match current pricing and pet limits', () {
    final free = planEntitlementFor('Mascotify Free');
    final plus = planEntitlementFor('Mascotify Plus');
    final pro = planEntitlementFor('Mascotify Pro');

    expect(free.priceLabel, 'US\$ 0 mensual');
    expect(free.maxPets, 1);
    expect(free.canAddPet(0), isTrue);
    expect(free.canAddPet(1), isFalse);

    expect(plus.priceLabel, 'US\$ 1,99 mensual');
    expect(plus.maxPets, 5);
    expect(plus.canAddPet(4), isTrue);
    expect(plus.canAddPet(5), isFalse);

    expect(pro.priceLabel, 'US\$ 4,99 mensual');
    expect(pro.hasUnlimitedPets, isTrue);
    expect(pro.usesFairUsePolicy, isTrue);
    expect(pro.canAddPet(500), isTrue);
  });
}
