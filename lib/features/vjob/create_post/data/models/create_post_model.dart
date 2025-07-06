import '../../domain/entities/create_post_entity.dart';

class CreatePostModel extends CreatePostEntity {
  const CreatePostModel({
    required super.title,
    required super.description,
    required super.image,
  });

  factory CreatePostModel.fromEntity(CreatePostEntity entity) {
    return CreatePostModel(
      title: entity.title,
      description: entity.description,
      image: entity.image,
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'description': description, 'image': image};
  }

  factory CreatePostModel.fromJson(Map<String, dynamic> json) {
    return CreatePostModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
    );
  }

  @override
  CreatePostModel copyWith({
    String? title,
    String? description,
    String? image,
  }) {
    return CreatePostModel(
      title: title ?? this.title,
      description: description ?? this.description,
      image: image ?? this.image,
    );
  }
}
