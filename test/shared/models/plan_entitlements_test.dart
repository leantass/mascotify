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
    expect(free.adsEnabled, isTrue);
    expect(free.nativeAdsEnabled, isTrue);
    expect(free.bannerAdsEnabled, isTrue);
    expect(free.rewardedAdsEnabled, isTrue);
    expect(free.interstitialAdsEnabled, isFalse);
    expect(free.sponsorsEnabled, isTrue);

    expect(plus.priceLabel, 'US\$ 1,99 mensual');
    expect(plus.maxPets, 5);
    expect(plus.canAddPet(4), isTrue);
    expect(plus.canAddPet(5), isFalse);
    expect(plus.adsEnabled, isFalse);
    expect(plus.nativeAdsEnabled, isFalse);
    expect(plus.bannerAdsEnabled, isFalse);
    expect(plus.rewardedAdsEnabled, isFalse);
    expect(plus.interstitialAdsEnabled, isFalse);
    expect(plus.sponsorsEnabled, isFalse);

    expect(pro.priceLabel, 'US\$ 4,99 mensual');
    expect(pro.hasUnlimitedPets, isTrue);
    expect(pro.usesFairUsePolicy, isTrue);
    expect(pro.canAddPet(500), isTrue);
    expect(pro.adsEnabled, isFalse);
    expect(pro.nativeAdsEnabled, isFalse);
    expect(pro.bannerAdsEnabled, isFalse);
    expect(pro.rewardedAdsEnabled, isFalse);
    expect(pro.interstitialAdsEnabled, isFalse);
    expect(pro.sponsorsEnabled, isFalse);
  });
}
