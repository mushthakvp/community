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

  static void navigateToRecipeTypeSelection(
    BuildContext context,
    String challengeId,
  ) {
    context.push(
      CookRouter.recipeTypeSelection,
      extra: {'challengeId': challengeId},
    );
  }

  static void navigateToAddStep(
    BuildContext context, {
    int? editIndex,
    Map<String, dynamic>? stepData,
  }) {
    final path = editIndex != null
        ? '${CookRouter.addStep}/$editIndex'
        : CookRouter.addStep;

    context.push(path, extra: stepData);
  }
}
