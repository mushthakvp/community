import '../../domain/entities/edit_ad_response_entity.dart';

class EditAdResponseModel extends EditAdResponseEntity {
  const EditAdResponseModel({
    required super.success,
    required super.message,
    super.adId,
  });

  factory EditAdResponseModel.fromJson(Map<String, dynamic> json) {
    return EditAdResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      adId: json['adId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'adId': adId};
  }
}
