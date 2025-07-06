import 'package:provider/single_child_widget.dart';

import 'providers/app_core_providers.dart';
import 'providers/auth_providers.dart';
import 'providers/coupon_promo_providers.dart';
import 'providers/home_providers.dart';
import 'providers/profile_providers.dart';
import 'providers/redemption_providers.dart';
import 'providers/spin_providers.dart';
import 'providers/vhub_providers.dart';
import 'providers/vizzle_providers.dart';
import 'providers/vjob_provider.dart';

class AppProviders {
  static List<SingleChildWidget> get providers => [
    ...AppCoreProviders.providers,
    ...AuthProviders.providers,
    ...HomeProviders.providers,
    ...ProfileProviders.providers,
    ...SpinProviders.providers,
    ...CouponPromoProviders.providers,
    ...RedemptionProviders.providers,
    ...VizzleProviders.providers,
    ...VHubProviders.providers,
    ...VJobProviders.providers,
  ];

  static Future<List<SingleChildWidget>> getInitializedProviders() async {
    final coreProviders = await AppCoreProviders.getInitializedProviders();

    return [
      ...coreProviders,
      ...AuthProviders.providers,
      ...HomeProviders.providers,
      ...ProfileProviders.providers,
      ...SpinProviders.providers,
      ...CouponPromoProviders.providers,
      ...RedemptionProviders.providers,
      ...VizzleProviders.providers,
      ...VHubProviders.providers,
      ...VJobProviders.providers,
    ];
  }

  static List<SingleChildWidget> getCoreProviders() =>
      AppCoreProviders.providers;
  static List<SingleChildWidget> getAuthProviders() => AuthProviders.providers;
  static List<SingleChildWidget> getHomeProviders() => HomeProviders.providers;
  static List<SingleChildWidget> getProfileProviders() =>
      ProfileProviders.providers;
  static List<SingleChildWidget> getSpinProviders() => SpinProviders.providers;
  static List<SingleChildWidget> getCouponPromoProviders() =>
      CouponPromoProviders.providers;
  static List<SingleChildWidget> getRedemptionProviders() =>
      RedemptionProviders.providers;
  static List<SingleChildWidget> getVizzleProviders() =>
      VizzleProviders.providers;
  static List<SingleChildWidget> getVHubProviders() => VHubProviders.providers;
  static List<SingleChildWidget> getVJobProviders() => VJobProviders.providers;

  static List<SingleChildWidget> getEssentialProviders() => [
    ...AppCoreProviders.providers,
    ...AuthProviders.providers,
    ...HomeProviders.providers,
  ];

  static int get totalProvidersCount => providers.length;

  static Map<String, int> get providersCountByCategory => {
    'Core': AppCoreProviders.providers.length,
    'Auth': AuthProviders.providers.length,
    'Home': HomeProviders.providers.length,
    'Profile': ProfileProviders.providers.length,
    'Spin': SpinProviders.providers.length,
    'Coupon/Promo': CouponPromoProviders.providers.length,
    'Redemption': RedemptionProviders.providers.length,
    'Vizzle': VizzleProviders.providers.length,
    'VHub': VHubProviders.providers.length,
    'VJob': VJobProviders.providers.length,
  };
}
