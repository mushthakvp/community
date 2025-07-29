class RecipeConstants {
  static const int minTitleLength = 3;
  static const int maxTitleLength = 100;
  static const int minDescriptionLength = 10;
  static const int maxDescriptionLength = 500;
  static const int minStepTitleLength = 3;
  static const int maxStepTitleLength = 50;
  static const int minStepDescriptionLength = 10;
  static const int maxStepDescriptionLength = 300;

  static const int maxImageSize = 5 * 1024 * 1024;
  static const int maxVideoSize = 100 * 1024 * 1024;

  // Supported formats
  static const List<String> supportedImageFormats = ['jpg', 'jpeg', 'png'];
  static const List<String> supportedVideoFormats = ['mp4', 'mov', 'avi'];

  // Draft storage
  static const String draftStorageKey = 'recipe_draft';

  // Error messages
  static const String titleRequiredError = 'Recipe title is required';
  static const String descriptionRequiredError =
      'Recipe description is required';
  static const String ingredientsRequiredError =
      'At least one ingredient is required';
  static const String stepsRequiredError = 'At least one step is required';
  static const String videoRequiredError =
      'Video is required for video recipes';
  static const String imageRequiredError =
      'Dish image is required for video recipes';

  // Success messages
  static const String recipeSavedSuccess = 'Recipe saved successfully';
  static const String recipeSubmittedSuccess = 'Recipe submitted successfully';
  static const String draftSavedSuccess = 'Draft saved';

  static const List<String> ingredientUnits = [
    'grams',
    'kg',
    'ml',
    'liters',
    'cups',
    'tablespoons',
    'teaspoons',
    'pieces',
    'pinch',
    'dash',
  ];
}
