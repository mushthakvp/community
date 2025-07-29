import 'package:go_router/go_router.dart';

import '../../challenge_details/presentation/pages/challenge_details_page.dart';
import '../../home/presentation/pages/home_page.dart';
import '../../my_challenges/presentation/pages/my_challenges_page.dart';
import '../../prize_view/presentation/pages/prize_overview_page.dart';
import '../../recipe_management/presentation/pages/add_step_page.dart';
import '../../recipe_management/presentation/pages/recipe_steps_page.dart';
import '../../recipe_management/presentation/pages/recipe_type_selection_page.dart';
import '../../recipe_management/presentation/pages/text_recipe_page.dart';
import '../../recipe_management/presentation/pages/video_recipe_page.dart';
import '../../search/presentation/pages/search_page.dart';

class CookRouter {
  static const String cookHome = '/cook';
  static const String cookSearch = '/cook/search';
  static const String cookMyChallenges = '/cook/my-challenges';
  static const String challengeDetails = '/cook/challenge-details';
  static const String prizeOverview = '/cook/prize-overview';
  static const String recipeTypeSelection = '/cook/recipe/type';
  static const String textRecipe = '/cook/recipe/text';
  static const String videoRecipe = '/cook/recipe/video';
  static const String recipeSteps = '/cook/recipe/steps';
  static const String addStep = '/cook/recipe/steps/add';
  static const String editStep = '/cook/recipe/steps/edit';

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
      path: '$challengeDetails/:challengeId',
      name: 'challenge_details',
      builder: (context, state) {
        final challengeId = state.pathParameters['challengeId'];
        if (challengeId == null || challengeId.isEmpty) {
          throw ArgumentError('challengeId is required');
        }
        return ChallengeDetailsPage(challengeId: challengeId);
      },
    ),
    GoRoute(
      path: '$prizeOverview/:challengeId',
      name: 'prize_overview',
      builder: (context, state) {
        final challengeId = state.pathParameters['challengeId'];
        if (challengeId == null || challengeId.isEmpty) {
          throw ArgumentError('challengeId is required');
        }
        return PrizeOverviewPage(challengeId: challengeId);
      },
    ),
    // Recipe-related routes
    GoRoute(
      path: '$recipeTypeSelection/:challengeId',
      name: 'recipe_type_selection',
      builder: (context, state) {
        final challengeId = state.pathParameters['challengeId'];
        if (challengeId == null || challengeId.isEmpty) {
          throw ArgumentError('challengeId is required');
        }
        return RecipeTypeSelectionPage(challengeId: challengeId);
      },
    ),
    GoRoute(
      path: textRecipe,
      name: 'text_recipe',
      builder: (context, state) => const TextRecipePage(),
    ),
    GoRoute(
      path: videoRecipe,
      name: 'video_recipe',
      builder: (context, state) => const VideoRecipePage(),
    ),
    GoRoute(
      path: recipeSteps,
      name: 'recipe_steps',
      builder: (context, state) => const RecipeStepsPage(),
    ),
    GoRoute(
      path: addStep,
      name: 'add_step',
      builder: (context, state) => const AddStepPage(),
    ),
    GoRoute(
      path: '$editStep/:index',
      name: 'edit_step',
      builder: (context, state) {
        final indexStr = state.pathParameters['index'];
        final index = indexStr != null ? int.tryParse(indexStr) : null;
        return AddStepPage(editIndex: index);
      },
    ),
  ];
}
