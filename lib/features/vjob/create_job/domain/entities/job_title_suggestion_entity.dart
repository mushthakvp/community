import 'package:equatable/equatable.dart';

class JobTitleSuggestionEntity extends Equatable {
  final String id;
  final String title;
  final bool isCustom;

  const JobTitleSuggestionEntity({
    required this.id,
    required this.title,
    this.isCustom = false,
  });

  JobTitleSuggestionEntity copyWith({
    String? id,
    String? title,
    bool? isCustom,
  }) {
    return JobTitleSuggestionEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      isCustom: isCustom ?? this.isCustom,
    );
  }

  @override
  List<Object?> get props => [id, title, isCustom];
}
