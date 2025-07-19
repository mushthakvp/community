import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/category.dart';
import '../entities/section.dart';
import '../entities/subcategory.dart';

abstract class CategoriesRepository {
  Future<Either<Failure, List<Section>>> getSections({
    int page = 1,
    int limit = 1000,
  });

  Future<Either<Failure, List<CategoryItem>>> getCategoriesBySection({
    required String sectionId,
    int page = 1,
    int limit = 1000,
  });

  Future<Either<Failure, List<SubCategory>>> getSubCategoriesByCategory({
    required String categoryId,
    int page = 1,
    int limit = 10,
  });
}
