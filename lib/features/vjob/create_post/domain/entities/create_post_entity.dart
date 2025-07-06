import 'package:equatable/equatable.dart';

class CreatePostEntity extends Equatable {
  final String title;
  final String description;
  final String image;

  const CreatePostEntity({
    required this.title,
    required this.description,
    required this.image,
  });

  CreatePostEntity copyWith({
    String? title,
    String? description,
    String? image,
  }) {
    return CreatePostEntity(
      title: title ?? this.title,
      description: description ?? this.description,
      image: image ?? this.image,
    );
  }

  // Validation methods
  bool get isValid =>
      title.trim().isNotEmpty &&
      description.trim().isNotEmpty &&
      image.trim().isNotEmpty;

  String? get titleError {
    if (title.trim().isEmpty) return 'Title is required';
    if (title.trim().length < 3) return 'Title must be at least 3 characters';
    if (title.trim().length > 100) {
      return 'Title must be less than 100 characters';
    }
    return null;
  }

  String? get descriptionError {
    if (description.trim().isEmpty) return 'Description is required';
    if (description.trim().length < 10) {
      return 'Description must be at least 10 characters';
    }
    if (description.trim().length > 1000) {
      return 'Description must be less than 1000 characters';
    }
    return null;
  }

  String? get imageError {
    if (image.trim().isEmpty) return 'Image is required';
    return null;
  }

  Map<String, String?> get validationErrors => {
    'title': titleError,
    'description': descriptionError,
    'image': imageError,
  };

  bool get hasValidationErrors =>
      validationErrors.values.any((error) => error != null);

  @override
  List<Object?> get props => [title, description, image];

  @override
  String toString() {
    return 'CreatePostEntity(title: $title, description: $description, image: $image)';
  }
}
