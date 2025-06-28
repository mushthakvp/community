import 'package:equatable/equatable.dart';

/// A utility class for handling results that can either be success or failure
abstract class Result<T> extends Equatable {
  const Result();
}

class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);

  @override
  List<Object?> get props => [data];
}

class Error<T> extends Result<T> {
  final String message;
  final Exception? exception;
  final int? code;

  const Error({required this.message, this.exception, this.code});

  @override
  List<Object?> get props => [message, exception, code];
}

// Extension methods for Result
extension ResultExtensions<T> on Result<T> {
  bool get isSuccess => this is Success<T>;
  bool get isError => this is Error<T>;

  T? get data => isSuccess ? (this as Success<T>).data : null;
  String? get errorMessage => isError ? (this as Error<T>).message : null;

  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(String error) onError,
  }) {
    if (isSuccess) {
      return onSuccess((this as Success<T>).data);
    } else {
      return onError((this as Error<T>).message);
    }
  }
}
