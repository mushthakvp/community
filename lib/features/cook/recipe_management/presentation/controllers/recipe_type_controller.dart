import 'package:get/get.dart';

import '../../domain/entities/recipe.dart';

class RecipeTypeController extends GetxController {
  final RxString _selectedType = 'none'.obs;

  String get selectedType => _selectedType.value;
  RecipeType? get selectedRecipeType {
    switch (_selectedType.value) {
      case 'text':
        return RecipeType.text;
      case 'video':
        return RecipeType.video;
      default:
        return null;
    }
  }

  bool get hasSelectedType => _selectedType.value != 'none';

  void selectRecipeType(String type) {
    _selectedType.value = type;
  }

  void reset() {
    _selectedType.value = 'none';
  }
}
