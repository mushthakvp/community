import '../../domain/entities/filter_color.dart';

class FilterColorModel extends FilterColor {
  const FilterColorModel({required super.color, required super.colorCode});

  factory FilterColorModel.fromJson(Map<String, dynamic> json) {
    return FilterColorModel(
      color: json['color'] ?? '',
      colorCode: json['colorCode'] ?? '#000000',
    );
  }

  Map<String, dynamic> toJson() {
    return {'color': color, 'colorCode': colorCode};
  }
}
