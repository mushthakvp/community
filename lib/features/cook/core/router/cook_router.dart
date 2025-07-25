import 'package:go_router/go_router.dart';

import '../../add_a_step/presentation/pages/add_a_step_page.dart';
import '../../add_recipe/presentation/pages/add_recipe_page.dart';
import '../../add_recipe_steps/presentation/pages/add_recipe_steps_page.dart';
import '../../add_text_recipe/presentation/pages/add_text_recipe_page.dart';
import '../../add_video_recipe/presentation/pages/add_video_recipe_page.dart';
import '../../challenge_details/presentation/pages/challenge_details_page.dart';
import '../../home/presentation/pages/home_page.dart';
import '../../my_challenges/presentation/pages/my_challenges_page.dart';
import '../../preview/presentation/pages/preview_page.dart';
import '../../prize_view/presentation/pages/prize_overview_page.dart';
import '../../search/presentation/pages/search_page.dart';

class CookRouter {
  static const String cookHome = '/cook';
  static const String cookSearch = '/cook/search';
  static const String cookMyChallenges = '/cook/my-challenges';
  static const String challengeDetails = '/cook/challenge-details';
  static const String preview = '/cook/preview';
  static const String prizeOverview = '/cook/prize-overview';
  static const String addRecipe = '/cook/add-recipe';
  static const String addTextRecipe = '/cook/add-text-recipe';
  static const String addVideoRecipe = '/cook/add-video-recipe';
  static const String addRecipeSteps = '/cook/add-recipe-steps';
  static const String addStep = '/cook/add-step';

  static List<RouteBase> get routes => [
    GoRoute(
      path: cookHome,
      name: 'cook_home',
      builder: (context, state) => const CookHomePage(),
    ),
    GoRoute(
      path: cookSearch,
      name: 'cook_search',
      builder: (context, state) => const CookSearchPage(),
    ),
    GoRoute(
      path: cookMyChallenges,
      name: 'cook_my_challenges',
      builder: (context, state) {
        final fromMyChallenges =
            state.uri.queryParameters['from'] == 'my_challenges';
        return CookMyChallengesPage(fromMyChallenges: fromMyChallenges);
      },
    ),
    GoRoute(
      path: challengeDetails,
      name: 'challenge_details',
      builder: (context, state) {
        final challengeId = state.uri.queryParameters['challengeId'];
        if (challengeId == null) {
          throw ArgumentError('challengeId is required');
        }
        return ChallengeDetailsPage(challengeId: challengeId);
      },
    ),
    GoRoute(
      path: preview,
      name: 'preview',
      builder: (context, state) {
        final recipeData = state.extra as Map<String, dynamic>? ?? {};
        final isFromPreview = state.uri.queryParameters['from'] == 'preview';
        return PreviewPage(
          recipeData: recipeData,
          isFromPreview: isFromPreview,
        );
      },
    ),
    GoRoute(
      path: prizeOverview,
      name: 'prize_overview',
      builder: (context, state) {
        final challengeId = state.uri.queryParameters['challengeId'];
        if (challengeId == null) {
          throw ArgumentError('challengeId is required');
        }
        return PrizeOverviewPage(challengeId: challengeId);
      },
    ),
    GoRoute(
      path: addRecipe,
      name: 'add_recipe',
      builder: (context, state) => const AddRecipePage(),
    ),
    GoRoute(
      path: addTextRecipe,
      name: 'add_text_recipe',
      builder: (context, state) => const AddTextRecipePage(),
    ),
    GoRoute(
      path: addVideoRecipe,
      name: 'add_video_recipe',
      builder: (context, state) => const AddVideoRecipePage(),
    ),
    GoRoute(
      path: addRecipeSteps,
      name: 'add_recipe_steps',
      builder: (context, state) => const AddRecipeStepsPage(),
    ),
    GoRoute(
      path: '$addStep/:stepIndex?',
      name: 'add_step',
      builder: (context, state) {
        final stepIndex = state.pathParameters['stepIndex'];
        final stepData = state.extra as Map<String, dynamic>?;
        return AddStepPage(
          editIndex: stepIndex != null ? int.tryParse(stepIndex) : null,
          stepData: stepData,
        );
      },
    ),
  ];
}
