import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? code;

  const Failure({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];

  @override
  String toString() => '$message${code != null ? ' (Code: $code)' : ''}';

  String get userFriendlyMessage;
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.code});

  @override
  String get userFriendlyMessage =>
      message.isNotEmpty ? message : 'Server error. Please try again later.';
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.message, super.code});

  @override
  String get userFriendlyMessage =>
      'No internet connection. Please check your network.';
}

class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.code});

  @override
  String get userFriendlyMessage => message.isNotEmpty
      ? message
      : 'Authentication failed. Please login again.';
}

class ValidationFailure extends Failure {
  const ValidationFailure({required super.message, super.code});

  @override
  String get userFriendlyMessage => message;
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message, super.code});

  @override
  String get userFriendlyMessage => 'Cache error. Please refresh the app.';
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({required super.message, super.code});

  @override
  String get userFriendlyMessage => 'Request timeout. Please try again.';
}

class UnknownFailure extends Failure {
  const UnknownFailure({required super.message, super.code});

  @override
  String get userFriendlyMessage => 'Something went wrong. Please try again.';
}
