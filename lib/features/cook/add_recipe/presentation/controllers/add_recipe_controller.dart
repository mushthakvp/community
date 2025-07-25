import 'package:get/get.dart';

enum RecipeMethod { none, text, video }

class AddRecipeController extends GetxController {
  final Rx<RecipeMethod> _selectedMethod = RecipeMethod.none.obs;

  RecipeMethod get selectedMethod => _selectedMethod.value;
  bool get isMethodSelected => _selectedMethod.value != RecipeMethod.none;

  void selectRecipeMethod(RecipeMethod method) {
    _selectedMethod.value = method;
  }

  void resetSelection() {
    _selectedMethod.value = RecipeMethod.none;
  }

  bool isMethodActive(RecipeMethod method) {
    return _selectedMethod.value == method;
  }

  String getMethodName(RecipeMethod method) {
    switch (method) {
      case RecipeMethod.text:
        return 'Text Recipe';
      case RecipeMethod.video:
        return 'Video Recipe';
      case RecipeMethod.none:
        return 'None';
    }
  }
}
