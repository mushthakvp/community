import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/section_category_data.dart';

abstract class SectionCategoryRepository {
  Future<Either<Failure, SectionCategoryData>> getCategoriesBySection({
    required String sectionId,
    int page = 1,
    int limit = 1000,
  });
}
