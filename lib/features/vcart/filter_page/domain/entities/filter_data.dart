import 'package:equatable/equatable.dart';

import 'filter_brand.dart';
import 'filter_color.dart';

class FilterData extends Equatable {
  final bool success;
  final String message;
  final List<FilterBrand> brands;
  final List<String> sizes;
  final List<FilterColor> colors;

  const FilterData({
    required this.success,
    required this.message,
    required this.brands,
    required this.sizes,
    required this.colors,
  });

  @override
  List<Object?> get props => [success, message, brands, sizes, colors];
}
