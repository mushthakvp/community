import '../../domain/entities/spin_entity.dart';
import '../../domain/entities/spin_result_entity.dart';

class SpinResultModel {
  final bool? success;
  final String? message;
  final Map<String, dynamic>? spinOption;

  const SpinResultModel({this.success, this.message, this.spinOption});

  factory SpinResultModel.fromJson(Map<String, dynamic> json) {
    try {
      return SpinResultModel(
        success: json["success"] as bool?,
        message: json["message"] as String?,
        spinOption: json["spinOption"] as Map<String, dynamic>?,
      );
    } catch (e) {
      return const SpinResultModel();
    }
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "spinOption": spinOption,
  };

  // Convert to entity
  SpinResultEntity toEntity() {
    SpinEntity? spinEntity;
    int? loyaltyPoints;
    String? couponCode;

    if (spinOption != null) {
      loyaltyPoints = spinOption!['loyaltyPoint'] as int?;
      couponCode = spinOption!['couponCode'] as String?;

      spinEntity = SpinEntity(
        id: spinOption!['_id'] ?? '',
        type: spinOption!['type'] ?? '',
        title: spinOption!['title'] ?? '',
        isBetterLuck: spinOption!['isBetterLuck'] ?? false,
        isSpinAgain: spinOption!['isSpinAgain'] ?? false,
        image: spinOption!['image'],
        couponCode: couponCode,
        loyaltyPoint: loyaltyPoints,
      );
    }

    return SpinResultEntity(
      success: success ?? false,
      message: message ?? '',
      spinOption: spinEntity,
      loyaltyPointsEarned: loyaltyPoints,
      couponCodeEarned: couponCode,
    );
  }
}
