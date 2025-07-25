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

  static void navigateToAddRecipe(context) {
    context.go(CookRouter.addRecipe);
  }

  static void navigateToTextRecipe(context) {
    context.go(CookRouter.addTextRecipe);
  }

  static void navigateToVideoRecipe(context) {
    context.go(CookRouter.addVideoRecipe);
  }

  static void navigateToRecipeSteps(context) {
    context.go(CookRouter.addRecipeSteps);
  }

  static void navigateToAddStep(
    context, {
    int? editIndex,
    Map<String, dynamic>? stepData,
  }) {
    final path = editIndex != null
        ? '${CookRouter.addStep}/$editIndex'
        : CookRouter.addStep;

    context.go(path, extra: stepData);
  }
}
