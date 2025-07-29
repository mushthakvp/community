import '../../../../../core/error/exceptions.dart';
import '../../../core/constants/cook_api_endpoints.dart';
import '../../../core/network/cook_api_client.dart';
import '../../domain/entities/recipe.dart';
import '../../domain/entities/recipe_draft.dart';
import '../models/ingredient_model.dart';
import '../models/recipe_model.dart';
import '../models/recipe_step_model.dart';

abstract class RecipeRemoteDataSource {
  Future<Recipe> submitRecipe({
    required String challengeId,
    required RecipeDraft recipeDraft,
  });
}

class RecipeRemoteDataSourceImpl implements RecipeRemoteDataSource {
  final CookApiClient apiClient;

  RecipeRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<Recipe> submitRecipe({
    required String challengeId,
    required RecipeDraft recipeDraft,
  }) async {
    final body = _buildSubmissionBody(challengeId, recipeDraft);

    final result = await apiClient.post(
      CookApiEndpoints.submitTextRecipe,
      body: body,
    );

    return result.fold((failure) => throw ServerException(failure.message), (
      data,
    ) {
      // Create a recipe model from the draft and response
      return RecipeModel(
        id: data['_id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: recipeDraft.title!,
        description: recipeDraft.description!,
        type: recipeDraft.type!,
        cookingTime: recipeDraft.cookingTime,
        dishImageUrl: recipeDraft.dishImageUrl,
        videoUrl: recipeDraft.videoUrl,
        ingredients: recipeDraft.ingredients,
        steps: recipeDraft.steps,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    });
  }

  Map<String, dynamic> _buildSubmissionBody(
    String challengeId,
    RecipeDraft draft,
  ) {
    final body = <String, dynamic>{
      '_id': challengeId,
      'recipeTitle': draft.title,
      'description': draft.description,
    };

    if (draft.type == RecipeType.video) {
      body['recipeType'] = 'videoRecipe';
      body['cookingTime'] = draft.cookingTime;
      body['video'] = draft.videoUrl;
      body['dishPicture'] = draft.dishImageUrl;
    } else {
      body['recipeType'] = 'textRecipe';
      body['ingredients'] = draft.ingredients
          .map((e) => IngredientModel.fromEntity(e).toJson())
          .toList();
      body['steps'] = draft.steps
          .map((e) => RecipeStepModel.fromEntity(e).toJson())
          .toList();
    }

    return body;
  }
}
