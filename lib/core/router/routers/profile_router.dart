import 'package:go_router/go_router.dart';

import '../../../features/coupons/presentation/pages/coupon_home_page.dart';
import '../../../features/profile/presentation/pages/about_app_page.dart';
import '../../../features/profile/presentation/pages/change_password_page.dart';
import '../../../features/profile/presentation/pages/contact_us_page.dart';
import '../../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../../features/profile/presentation/pages/help_support_page.dart';
import '../../../features/profile/presentation/pages/loyalty_points_page.dart';
import '../../../features/profile/presentation/pages/notifications_page.dart';
import '../../../features/profile/presentation/pages/privacy_page.dart';
import '../../../features/profile/presentation/pages/terms_conditions_page.dart';
import '../../../features/redemption/presentation/pages/wallet_recharge_page.dart';
import '../../constants/route_constants.dart';

class ProfileRouter {
  /// Profile and settings related routes
  static List<RouteBase> get routes => [
    // ==================== PROFILE MANAGEMENT ROUTES ====================
    GoRoute(
      path: RouteConstants.editProfile,
      name: 'editProfile',
      builder: (context, state) => const EditProfilePage(),
    ),
    GoRoute(
      path: RouteConstants.loyaltyPoints,
      name: 'loyaltyPoints',
      builder: (context, state) => const LoyaltyPointsPage(),
    ),
    GoRoute(
      path: RouteConstants.changePassword,
      name: 'changePassword',
      builder: (context, state) => const ChangePasswordPage(),
    ),
    GoRoute(
      path: RouteConstants.notifications,
      name: 'notifications',
      builder: (context, state) => const NotificationsPage(),
    ),

    // ==================== LEGAL & INFORMATION ROUTES ====================
    GoRoute(
      path: RouteConstants.privacy,
      name: 'privacy',
      builder: (context, state) => const PrivacyPage(),
    ),
    GoRoute(
      path: RouteConstants.termsConditions,
      name: 'termsConditions',
      builder: (context, state) => const TermsConditionsPage(),
    ),
    GoRoute(
      path: RouteConstants.aboutApp,
      name: 'aboutApp',
      builder: (context, state) => const AboutAppPage(),
    ),

    // ==================== SUPPORT ROUTES ====================
    GoRoute(
      path: RouteConstants.helpSupport,
      name: 'helpSupport',
      builder: (context, state) => const HelpSupportPage(),
    ),
    GoRoute(
      path: RouteConstants.contactUs,
      name: 'contactUs',
      builder: (context, state) => const ContactUsPage(),
    ),

    // ==================== COUPONS & REWARDS ROUTES ====================
    GoRoute(
      path: RouteConstants.coupons,
      name: 'coupons',
      builder: (context, state) => const CouponHomePage(),
    ),

    // ==================== WALLET & PAYMENT ROUTES ====================
    GoRoute(
      path: RouteConstants.walletRecharge,
      name: 'walletRecharge',
      builder: (context, state) => const WalletRechargePage(),
    ),
  ];

  /// Route paths constants
  static const String editProfilePath = RouteConstants.editProfile;
  static const String loyaltyPointsPath = RouteConstants.loyaltyPoints;
  static const String changePasswordPath = RouteConstants.changePassword;
  static const String notificationsPath = RouteConstants.notifications;
  static const String privacyPath = RouteConstants.privacy;
  static const String termsConditionsPath = RouteConstants.termsConditions;
  static const String aboutAppPath = RouteConstants.aboutApp;
  static const String helpSupportPath = RouteConstants.helpSupport;
  static const String contactUsPath = RouteConstants.contactUs;
  static const String couponsPath = RouteConstants.coupons;
  static const String walletRechargePath = RouteConstants.walletRecharge;

  /// Profile route categories for analytics and organization
  static const List<String> profileManagementRoutes = [
    RouteConstants.editProfile,
    RouteConstants.loyaltyPoints,
    RouteConstants.changePassword,
    RouteConstants.notifications,
  ];

  static const List<String> legalInformationRoutes = [
    RouteConstants.privacy,
    RouteConstants.termsConditions,
    RouteConstants.aboutApp,
  ];

  static const List<String> supportRoutes = [
    RouteConstants.helpSupport,
    RouteConstants.contactUs,
  ];

  static const List<String> rewardsRoutes = [
    RouteConstants.coupons,
    RouteConstants.walletRecharge,
  ];

  /// Helper methods to check route categories
  static bool isProfileManagementRoute(String route) {
    return profileManagementRoutes.contains(route);
  }

  static bool isLegalInformationRoute(String route) {
    return legalInformationRoutes.contains(route);
  }

  static bool isSupportRoute(String route) {
    return supportRoutes.contains(route);
  }

  static bool isRewardsRoute(String route) {
    return rewardsRoutes.contains(route);
  }
}
