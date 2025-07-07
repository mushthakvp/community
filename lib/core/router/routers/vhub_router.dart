import 'package:go_router/go_router.dart';

import '../../../features/vhub/presentation/pages/vhub_home_page.dart';
import '../../../features/vhub/presentation/widgets/create_idea/create_idea_page.dart';
import '../../../features/vhub/presentation/widgets/faq/faq_page.dart';
import '../../../features/vhub/presentation/widgets/ideas/idea_details_page.dart';
import '../../../features/vhub/presentation/widgets/ideas/ideas_page.dart';
import '../../constants/route_constants.dart';

class VHubRouter {
  /// VHub business startup related routes
  static List<RouteBase> get routes => [
    // ==================== VHUB HOME ROUTE ====================
    GoRoute(
      path: RouteConstants.vhubHome,
      name: 'vhubHome',
      builder: (context, state) => const VHubHomePage(),
    ),

    // ==================== VHUB IDEAS ROUTE ====================
    GoRoute(
      path: RouteConstants.vhubIdeas,
      name: 'vhubIdeas',
      builder: (context, state) => const IdeasPage(),
    ),

    // ==================== VHUB CREATE IDEA ROUTE ====================
    GoRoute(
      path: RouteConstants.vhubCreateIdea,
      name: 'vhubCreateIdea',
      builder: (context, state) => const CreateIdeaPage(),
    ),

    // ==================== VHUB IDEA DETAILS ROUTE ====================
    GoRoute(
      path: '${RouteConstants.vhubIdeaDetails}/:ideaId',
      name: 'vhubIdeaDetails',
      builder: (context, state) {
        final ideaId = state.pathParameters['ideaId']!;
        return IdeaDetailsPage(ideaId: ideaId);
      },
    ),

    // ==================== VHUB FAQ ROUTE ====================
    GoRoute(
      path: RouteConstants.vhubFaq,
      name: 'vhubFaq',
      builder: (context, state) => const FaqPage(),
    ),

    // ==================== VHUB EDIT IDEA ROUTE ====================
    GoRoute(
      path: '${RouteConstants.vhubEditIdea}/:ideaId',
      name: 'vhubEditIdea',
      builder: (context, state) {
        return const CreateIdeaPage();
      },
    ),

    // ==================== VHUB MY PROFILE ROUTE ====================
    GoRoute(
      path: RouteConstants.vhubMyProfile,
      name: 'vhubMyProfile',
      builder: (context, state) => const VHubHomePage(), // Placeholder
    ),
  ];

  /// Route paths constants
  static const String vhubHomePath = RouteConstants.vhubHome;
  static const String vhubIdeasPath = RouteConstants.vhubIdeas;
  static const String vhubCreateIdeaPath = RouteConstants.vhubCreateIdea;
  static const String vhubIdeaDetailsPath = RouteConstants.vhubIdeaDetails;
  static const String vhubFaqPath = RouteConstants.vhubFaq;
  static const String vhubMyProfilePath = RouteConstants.vhubMyProfile;
  static const String vhubEditIdeaPath = RouteConstants.vhubEditIdea;

  /// Helper methods for VHub navigation
  static String buildIdeaDetailsRoute(String ideaId) {
    return '${RouteConstants.vhubIdeaDetails}/$ideaId';
  }

  static String buildEditIdeaRoute(String ideaId) {
    return '${RouteConstants.vhubEditIdea}/$ideaId';
  }
}
