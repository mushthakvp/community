import 'package:equatable/equatable.dart';

class ApplyJobEntity extends Equatable {
  final bool success;
  final String message;

  const ApplyJobEntity({required this.success, required this.message});

  @override
  List<Object?> get props => [success, message];
}
