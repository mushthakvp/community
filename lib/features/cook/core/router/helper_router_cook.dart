import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:livera/features/cook/core/router/cook_router.dart';

class HelperRouterCook {
  static String challengeDetailsPath(String challengeId) {
    return '${CookRouter.challengeDetails}?challengeId=$challengeId';
  }

  static String prizeOverviewPath(String challengeId) {
    return '${CookRouter.prizeOverview}?challengeId=$challengeId';
  }

  static void myChallenges(BuildContext ctx) {
    ctx.push(CookRouter.cookMyChallenges);
  }

  static void navigateToPreview(
    BuildContext ctx,
    Map<String, dynamic> recipeData, {
    bool isFromPreview = false,
  }) {
    final queryParams = isFromPreview ? '?from=preview' : '';
    ctx.push('${CookRouter.preview}$queryParams', extra: recipeData);
  }

  static void navigateToPrizeOverview(BuildContext ctx, String challengeId) {
    ctx.push(prizeOverviewPath(challengeId));
  }
}
