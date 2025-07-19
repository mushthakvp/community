import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/filter_data.dart';

abstract class FilterPageRepository {
  Future<Either<Failure, FilterData>> getFilterData({
    String? sectionId,
    String? brandId,
  });
}
