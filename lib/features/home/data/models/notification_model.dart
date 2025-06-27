class ViveraNotificationModel {
  bool? success;
  String? message;
  List<NotificationData>? notifications;
  num? total;

  ViveraNotificationModel({
    this.success,
    this.message,
    this.notifications,
    this.total,
  });

  factory ViveraNotificationModel.fromJson(Map<String, dynamic> json) =>
      ViveraNotificationModel(
        success: json["success"],
        message: json["message"],
        notifications: json["notifications"] == null
            ? []
            : List<NotificationData>.from(
                json["notifications"]!.map((x) => NotificationData.fromJson(x)),
              ),
        total: json["total"],
      );
}

class NotificationData {
  String? id;
  String? title;
  String? message;
  DateTime? createdAt;

  NotificationData({this.id, this.title, this.message, this.createdAt});

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      NotificationData(
        id: json["_id"],
        title: json["title"],
        message: json["message"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
      );
}
