class CategoryModel {
  final String? id;
  final String? name;
  final String? image;
  final bool? deleted;
  final String? createdAt;
  final String? updatedAt;
  final List<SubcategoryModel>? subcategories;

  const CategoryModel({
    this.id,
    this.name,
    this.image,
    this.deleted,
    this.createdAt,
    this.updatedAt,
    this.subcategories,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    id: json["_id"],
    name: json["name"],
    image: json["image"],
    deleted: json["deleted"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
    subcategories: json["subcategories"] == null
        ? []
        : List<SubcategoryModel>.from(
            json["subcategories"]!.map((x) => SubcategoryModel.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "image": image,
    "deleted": deleted,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "subcategories": subcategories == null
        ? []
        : List<dynamic>.from(subcategories!.map((x) => x.toJson())),
  };
}

class SubcategoryModel {
  final String? id;
  final String? name;
  final String? categoryId;
  final bool? deleted;
  final String? createdAt;
  final String? updatedAt;

  const SubcategoryModel({
    this.id,
    this.name,
    this.categoryId,
    this.deleted,
    this.createdAt,
    this.updatedAt,
  });

  factory SubcategoryModel.fromJson(Map<String, dynamic> json) =>
      SubcategoryModel(
        id: json["_id"],
        name: json["name"],
        categoryId: json["categoryId"],
        deleted: json["deleted"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
      );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "categoryId": categoryId,
    "deleted": deleted,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
  };
}
