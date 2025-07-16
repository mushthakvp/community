import 'package:equatable/equatable.dart';

abstract class Result<T> extends Equatable {
  const Result();

  /// Check if the result is a success
  bool get isSuccess => this is Success<T>;

  /// Check if the result is an error
  bool get isError => this is Error<T>;

  /// Get data if success, null if error
  T? get data => isSuccess ? (this as Success<T>).data : null;

  /// Get error message if error, null if success
  String? get errorMessage => isError ? (this as Error<T>).message : null;

  /// Get error exception if error, null if success
  Exception? get exception => isError ? (this as Error<T>).exception : null;

  /// Get error code if error, null if success
  int? get errorCode => isError ? (this as Error<T>).code : null;
}

class Success<T> extends Result<T> {
  @override
  final T data;

  const Success(this.data);

  @override
  List<Object?> get props => [data];

  @override
  String toString() => 'Success(data: $data)';
}

class Error<T> extends Result<T> {
  final String message;
  @override
  final Exception? exception;
  final int? code;

  const Error({required this.message, this.exception, this.code});

  @override
  List<Object?> get props => [message, exception, code];

  @override
  String toString() => 'Error(message: $message, code: $code)';
}

// Extension methods for Result
extension ResultExtensions<T> on Result<T> {
  /// Fold the result into a single value
  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(String error) onError,
  }) {
    if (isSuccess) {
      return onSuccess(data as T);
    } else {
      return onError(errorMessage!);
    }
  }

  /// Map the success value to another type
  Result<R> map<R>(R Function(T) transform) {
    if (isSuccess) {
      try {
        return Success(transform(data as T));
      } catch (e) {
        return Error<R>(message: e.toString());
      }
    } else {
      return Error<R>(
        message: errorMessage!,
        exception: exception,
        code: errorCode,
      );
    }
  }

  /// Handle the result with optional callbacks
  void handle({
    void Function(T data)? onSuccess,
    void Function(String error)? onError,
  }) {
    if (isSuccess && onSuccess != null) {
      onSuccess(data as T);
    } else if (isError && onError != null) {
      onError(errorMessage!);
    }
  }
}
