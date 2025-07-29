import 'dart:convert';

import '../../../../../core/services/storage_service.dart';
import '../../domain/entities/recipe_draft.dart';
import '../models/recipe_draft_model.dart';

abstract class RecipeLocalDataSource {
  Future<void> saveDraft(RecipeDraft draft);
  Future<RecipeDraft?> loadDraft();
  Future<void> clearDraft();
}

class RecipeLocalDataSourceImpl implements RecipeLocalDataSource {
  static const String _draftKey = 'recipe_draft';

  @override
  Future<void> saveDraft(RecipeDraft draft) async {
    try {
      final model = RecipeDraftModel.fromEntity(draft);
      final jsonString = jsonEncode(model.toJson());
      await StorageService.setString(_draftKey, jsonString);
    } catch (e) {
      // Ignore storage errors for draft saving
    }
  }

  @override
  Future<RecipeDraft?> loadDraft() async {
    try {
      final jsonString = StorageService.getString(_draftKey);
      if (jsonString != null) {
        final json = jsonDecode(jsonString);
        return RecipeDraftModel.fromJson(json);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> clearDraft() async {
    try {
      await StorageService.remove(_draftKey);
    } catch (e) {
      // Ignore storage errors
    }
  }
}
