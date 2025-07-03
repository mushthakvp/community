import 'package:equatable/equatable.dart';

class EditAdResponseEntity extends Equatable {
  final bool success;
  final String message;
  final String? adId;

  const EditAdResponseEntity({
    required this.success,
    required this.message,
    this.adId,
  });

  @override
  List<Object?> get props => [success, message, adId];
}
