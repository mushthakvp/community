import 'package:equatable/equatable.dart';

class SpinOptionEntity extends Equatable {
  final String id;
  final String type;
  final String title;

  const SpinOptionEntity({
    required this.id,
    required this.type,
    required this.title,
  });

  SpinOptionEntity copyWith({String? id, String? type, String? title}) {
    return SpinOptionEntity(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
    );
  }

  @override
  List<Object?> get props => [id, type, title];
}
