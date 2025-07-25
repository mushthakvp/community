import 'package:get/get.dart';

import '../../add_a_step/presentation/controllers/add_step_controller.dart';
import '../../add_recipe/presentation/controllers/add_recipe_controller.dart';
import '../../add_recipe_steps/presentation/controllers/recipe_steps_controller.dart';
import '../../add_text_recipe/presentation/controllers/add_text_recipe_controller.dart';
import '../../add_video_recipe/presentation/controllers/add_video_recipe_controller.dart';

class AddRecipeInjection {
  static void init() {
    Get.lazyPut<AddRecipeController>(
      () => AddRecipeController(),
      tag: 'add_recipe',
    );
    Get.lazyPut<AddTextRecipeController>(
      () => AddTextRecipeController(),
      tag: 'add_text_recipe',
    );
    Get.lazyPut<AddVideoRecipeController>(
      () => AddVideoRecipeController(),
      tag: 'add_video_recipe',
    );
    Get.lazyPut<RecipeStepsController>(
      () => RecipeStepsController(),
      tag: 'recipe_steps',
    );
    Get.lazyPut<AddStepController>(() => AddStepController(), tag: 'add_step');
  }

  static void dispose() {
    if (Get.isRegistered<AddRecipeController>(tag: 'add_recipe')) {
      Get.delete<AddRecipeController>(tag: 'add_recipe');
    }

    if (Get.isRegistered<AddTextRecipeController>(tag: 'add_text_recipe')) {
      Get.delete<AddTextRecipeController>(tag: 'add_text_recipe');
    }

    if (Get.isRegistered<AddVideoRecipeController>(tag: 'add_video_recipe')) {
      Get.delete<AddVideoRecipeController>(tag: 'add_video_recipe');
    }

    if (Get.isRegistered<RecipeStepsController>(tag: 'recipe_steps')) {
      Get.delete<RecipeStepsController>(tag: 'recipe_steps');
    }

    if (Get.isRegistered<AddStepController>(tag: 'add_step')) {
      Get.delete<AddStepController>(tag: 'add_step');
    }
  }
}
