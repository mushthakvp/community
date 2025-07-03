class SpinResponseModel {
  final bool success;
  final String message;
  final dynamic data;

  const SpinResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory SpinResponseModel.fromJson(Map<String, dynamic> json) {
    return SpinResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data};
  }
}
