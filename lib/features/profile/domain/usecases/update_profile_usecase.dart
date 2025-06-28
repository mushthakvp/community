import '../../../../core/utils/result.dart';
import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<Result<ProfileEntity>> call({
    required String name,
    required String email,
    required String phone,
    required String dialCode,
    String? profileImageUrl,
  }) async {
    return await repository.updateProfile(
      name: name,
      email: email,
      phone: phone,
      dialCode: dialCode,
      profileImageUrl: profileImageUrl,
    );
  }
}
