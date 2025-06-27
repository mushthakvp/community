import 'package:dartz/dartz.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/error/failures.dart';

class LaunchUrlUseCase {
  Future<Either<Failure, bool>> call(String url) async {
    try {
      if (url.trim().isEmpty) {
        return const Left(ValidationFailure(message: 'URL cannot be empty'));
      }

      final uri = Uri.tryParse(url);
      if (uri == null) {
        return const Left(ValidationFailure(message: 'Invalid URL format'));
      }

      final canLaunch = await canLaunchUrl(uri);
      if (!canLaunch) {
        return const Left(ValidationFailure(message: 'Cannot launch this URL'));
      }

      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        final fallbackLaunched = await launchUrl(
          uri,
          mode: LaunchMode.platformDefault,
        );
        return Right(fallbackLaunched);
      }

      return Right(launched);
    } catch (e) {
      try {
        final uri = Uri.parse(url);
        final fallbackLaunched = await launchUrl(
          uri,
          mode: LaunchMode.platformDefault,
        );
        return Right(fallbackLaunched);
      } catch (fallbackError) {
        return Left(
          ValidationFailure(
            message: 'Failed to launch URL: ${fallbackError.toString()}',
          ),
        );
      }
    }
  }

  Future<Either<Failure, bool>> launchSocialMedia({
    required String appUrl,
    required String webUrl,
  }) async {
    try {
      final appResult = await call(appUrl);
      return appResult.fold((failure) async {
        return await call(webUrl);
      }, (success) => Right(success));
    } catch (e) {
      return Left(
        ValidationFailure(message: 'Failed to launch social media: $e'),
      );
    }
  }
}
