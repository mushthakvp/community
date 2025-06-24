// lib/core/error/error_handler.dart - Updated
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'exceptions.dart';
import 'failures.dart';

class ErrorHandler {
  static Failure handleException(Exception exception) {
    if (kDebugMode) {
      debugPrint('Exception handled: $exception');
    }

    // Use pattern matching for better type checking
    return switch (exception) {
      ServerException(message: final msg) => ServerFailure(message: msg),
      NetworkException(message: final msg) => NetworkFailure(message: msg),
      CacheException(message: final msg) => CacheFailure(message: msg),
      AuthException(message: final msg) => AuthFailure(message: msg),
      ValidationException(message: final msg) => ValidationFailure(
        message: msg,
      ),
      TimeoutException(message: final msg) => TimeoutFailure(message: msg),
      _ => UnknownFailure(message: exception.toString()),
    };
  }

  static void showError(BuildContext context, Failure failure) {
    final message = getErrorMessage(failure);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  static String getErrorMessage(Failure failure) {
    return switch (failure) {
      NetworkFailure() => 'No internet connection. Please check your network.',
      ServerFailure(message: final msg) =>
        msg.isNotEmpty ? msg : 'Server error. Please try again later.',
      ValidationFailure(message: final msg) => msg,
      CacheFailure() => 'Cache error. Please refresh the app.',
      AuthFailure(message: final msg) =>
        msg.isNotEmpty ? msg : 'Authentication failed. Please login again.',
      TimeoutFailure() => 'Request timeout. Please try again.',
      _ => 'Something went wrong. Please try again.',
    };
  }

  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void showInfo(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void showWarning(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// Alternative approach using if-else for older Dart versions
class ErrorHandlerCompat {
  static String getErrorMessage(Failure failure) {
    if (failure is NetworkFailure) {
      return 'No internet connection. Please check your network.';
    } else if (failure is ServerFailure) {
      return failure.message.isNotEmpty
          ? failure.message
          : 'Server error. Please try again later.';
    } else if (failure is ValidationFailure) {
      return failure.message;
    } else if (failure is CacheFailure) {
      return 'Cache error. Please refresh the app.';
    } else if (failure is AuthFailure) {
      return failure.message.isNotEmpty
          ? failure.message
          : 'Authentication failed. Please login again.';
    } else if (failure is TimeoutFailure) {
      return 'Request timeout. Please try again.';
    } else {
      return 'Something went wrong. Please try again.';
    }
  }
}
