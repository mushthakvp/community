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
      if (uri == null || (!uri.hasScheme)) {
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
      return Right(launched);
    } catch (e) {
      return Left(
        ValidationFailure(message: 'Failed to launch URL: ${e.toString()}'),
      );
    }
  }
}
