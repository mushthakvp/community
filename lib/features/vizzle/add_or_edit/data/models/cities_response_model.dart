import 'category_model.dart';

class CitiesResponseModel {
  final bool? success;
  final String? message;
  final List<String>? cities;
  final List<CategoryModel>? categories;

  const CitiesResponseModel({
    this.success,
    this.message,
    this.cities,
    this.categories,
  });

  factory CitiesResponseModel.fromJson(Map<String, dynamic> json) =>
      CitiesResponseModel(
        success: json["success"],
        message: json["message"],
        cities: json["cities"] == null
            ? []
            : List<String>.from(json["cities"]!.map((x) => x)),
        categories: json["categories"] == null
            ? []
            : List<CategoryModel>.from(
                json["categories"]!.map((x) => CategoryModel.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "cities": cities == null ? [] : List<dynamic>.from(cities!.map((x) => x)),
    "categories": categories == null
        ? []
        : List<dynamic>.from(categories!.map((x) => x.toJson())),
  };
}
