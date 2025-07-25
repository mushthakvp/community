import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:livera/features/cook/core/router/cook_router.dart';

class HelperRouterCook {
  static String challengeDetailsPath(String challengeId) {
    return '${CookRouter.challengeDetails}?challengeId=$challengeId';
  }

  static void myChallenges(BuildContext ctx) {
    ctx.push(CookRouter.cookMyChallenges);
  }
}
