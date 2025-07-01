import '../../domain/entities/vizzle_entities.dart';

// Vizzle Home Model
class VizzleHomeModel {
  final bool success;
  final String message;
  final String currencyCode;
  final List<AdModel> motors;
  final List<AdModel> classifieds;
  final List<AdModel> furnitureGarden;
  final List<AdModel> propertyForSale;

  VizzleHomeModel({
    required this.success,
    required this.message,
    required this.currencyCode,
    required this.motors,
    required this.classifieds,
    required this.furnitureGarden,
    required this.propertyForSale,
  });

  factory VizzleHomeModel.fromJson(Map<String, dynamic> json) {
    return VizzleHomeModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      currencyCode: json["currencyCode"] ?? "",
      motors: json["Motors"] == null
          ? []
          : List<AdModel>.from(json["Motors"].map((x) => AdModel.fromJson(x))),
      classifieds: json["Classifieds"] == null
          ? []
          : List<AdModel>.from(
              json["Classifieds"].map((x) => AdModel.fromJson(x)),
            ),
      furnitureGarden: json["Furniture & Garden"] == null
          ? []
          : List<AdModel>.from(
              json["Furniture & Garden"].map((x) => AdModel.fromJson(x)),
            ),
      propertyForSale: json["Property For Sale"] == null
          ? []
          : List<AdModel>.from(
              json["Property For Sale"].map((x) => AdModel.fromJson(x)),
            ),
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "currencyCode": currencyCode,
    "Motors": motors.map((x) => x.toJson()).toList(),
    "Classifieds": classifieds.map((x) => x.toJson()).toList(),
    "Furniture & Garden": furnitureGarden.map((x) => x.toJson()).toList(),
    "Property For Sale": propertyForSale.map((x) => x.toJson()).toList(),
  };

  // Convert to Entity
  VizzleHomeEntity toEntity() {
    return VizzleHomeEntity(
      success: success,
      message: message,
      currencyCode: currencyCode,
      motors: motors.map((ad) => ad.toEntity()).toList(),
      classifieds: classifieds.map((ad) => ad.toEntity()).toList(),
      furnitureGarden: furnitureGarden.map((ad) => ad.toEntity()).toList(),
      propertyForSale: propertyForSale.map((ad) => ad.toEntity()).toList(),
    );
  }
}

// Ad Model
class AdModel {
  final String id;
  final String title;
  final String shareLink;
  final List<String> images;
  final int? year;
  final int? kilometers;
  final double? price;
  final dynamic brand;
  final dynamic model;

  AdModel({
    required this.id,
    required this.title,
    required this.shareLink,
    required this.images,
    this.year,
    this.kilometers,
    this.price,
    this.brand,
    this.model,
  });

  factory AdModel.fromJson(Map<String, dynamic> json) {
    return AdModel(
      id: json["_id"] ?? "",
      title: json["title"] ?? "",
      shareLink: json["shareLink"] ?? "",
      images: json["images"] == null
          ? []
          : List<String>.from(json["images"].map((x) => x.toString())),
      year: json["year"],
      kilometers: json["kilometers"],
      price: json["price"]?.toDouble(),
      brand: json["brand"],
      model: json["model"],
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "shareLink": shareLink,
    "images": images,
    "year": year,
    "kilometers": kilometers,
    "price": price,
    "brand": brand,
    "model": model,
  };

  // Convert to Entity
  AdEntity toEntity() {
    return AdEntity(
      id: id,
      title: title,
      shareLink: shareLink,
      images: images,
      year: year,
      kilometers: kilometers,
      price: price,
      brand: brand?.toString(),
      model: model?.toString(),
    );
  }
}

// Category Model
class CategoryModel {
  final String id;
  final String name;
  final List<SubCategoryModel> subcategories;

  CategoryModel({
    required this.id,
    required this.name,
    required this.subcategories,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      subcategories: json["subcategories"] == null
          ? []
          : List<SubCategoryModel>.from(
              json["subcategories"].map((x) => SubCategoryModel.fromJson(x)),
            ),
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "subcategories": subcategories.map((x) => x.toJson()).toList(),
  };

  // Convert to Entity
  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      name: name,
      subcategories: subcategories.map((sub) => sub.toEntity()).toList(),
    );
  }
}

// Sub Category Model
class SubCategoryModel {
  final String id;
  final String name;
  final List<SubSubCategoryModel> subSubCategories;

  SubCategoryModel({
    required this.id,
    required this.name,
    required this.subSubCategories,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      subSubCategories: json["subSubCategories"] == null
          ? []
          : List<SubSubCategoryModel>.from(
              json["subSubCategories"].map(
                (x) => SubSubCategoryModel.fromJson(x),
              ),
            ),
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "subSubCategories": subSubCategories.map((x) => x.toJson()).toList(),
  };

  // Convert to Entity
  SubCategoryEntity toEntity() {
    return SubCategoryEntity(
      id: id,
      name: name,
      subSubCategories: subSubCategories.map((sub) => sub.toEntity()).toList(),
    );
  }
}

// Sub Sub Category Model
class SubSubCategoryModel {
  final String id;
  final String name;
  final List<SubItemModel> subItems;

  SubSubCategoryModel({
    required this.id,
    required this.name,
    required this.subItems,
  });

  factory SubSubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubSubCategoryModel(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      subItems: json["subItems"] == null
          ? []
          : List<SubItemModel>.from(
              json["subItems"].map((x) => SubItemModel.fromJson(x)),
            ),
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "subItems": subItems.map((x) => x.toJson()).toList(),
  };

  // Convert to Entity
  SubSubCategoryEntity toEntity() {
    return SubSubCategoryEntity(
      id: id,
      name: name,
      subItems: subItems.map((item) => item.toEntity()).toList(),
    );
  }
}

// Sub Item Model
class SubItemModel {
  final String id;
  final String name;

  SubItemModel({required this.id, required this.name});

  factory SubItemModel.fromJson(Map<String, dynamic> json) {
    return SubItemModel(id: json["_id"] ?? "", name: json["name"] ?? "");
  }

  Map<String, dynamic> toJson() => {"_id": id, "name": name};

  // Convert to Entity
  SubItemEntity toEntity() {
    return SubItemEntity(id: id, name: name);
  }
}

// Cities and Categories Response Model
class GetCitySectionAndCategoriesModel {
  final bool success;
  final String message;
  final List<CategoryModel> categories;

  GetCitySectionAndCategoriesModel({
    required this.success,
    required this.message,
    required this.categories,
  });

  factory GetCitySectionAndCategoriesModel.fromJson(Map<String, dynamic> json) {
    return GetCitySectionAndCategoriesModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      categories: json["categories"] == null
          ? []
          : List<CategoryModel>.from(
              json["categories"].map((x) => CategoryModel.fromJson(x)),
            ),
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "categories": categories.map((x) => x.toJson()).toList(),
  };
}

// Sub Sub Category Response Model
class GetVizzleSubSubCategoryModel {
  final bool success;
  final String message;
  final List<SubSubCategoryModel> categories;

  GetVizzleSubSubCategoryModel({
    required this.success,
    required this.message,
    required this.categories,
  });

  factory GetVizzleSubSubCategoryModel.fromJson(Map<String, dynamic> json) {
    return GetVizzleSubSubCategoryModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      categories: json["categories"] == null
          ? []
          : List<SubSubCategoryModel>.from(
              json["categories"].map((x) => SubSubCategoryModel.fromJson(x)),
            ),
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "categories": categories.map((x) => x.toJson()).toList(),
  };
}
