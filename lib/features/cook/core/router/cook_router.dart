import 'package:go_router/go_router.dart';

import '../../home/presentation/pages/home_page.dart';
import '../../my_challenges/presentation/pages/my_challenges_page.dart';
import '../../search/presentation/pages/search_page.dart';

class CookRouter {
  static const String cookHome = '/cook';
  static const String cookSearch = '/cook/search';
  static const String cookMyChallenges = '/cook/my-challenges';

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
  ];
}
