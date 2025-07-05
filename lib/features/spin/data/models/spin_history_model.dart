import '../../domain/entities/spin_history_entity.dart';
import '../../domain/entities/spin_option_entity.dart';

class SpinHistoryResponseModel {
  final bool? success;
  final List<SpinHistoryItemModel>? data;
  final int? totalRecords;
  final int? totalPages;

  const SpinHistoryResponseModel({
    this.success,
    this.data,
    this.totalRecords,
    this.totalPages,
  });

  factory SpinHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    try {
      return SpinHistoryResponseModel(
        success: json["success"] as bool?,
        data: json["data"] != null
            ? List<SpinHistoryItemModel>.from(
                (json["data"] as List).map(
                  (x) => SpinHistoryItemModel.fromJson(x),
                ),
              )
            : null,
        totalRecords: json["totalRecords"] as int?,
        totalPages: json["totalPages"] as int?,
      );
    } catch (e) {
      return const SpinHistoryResponseModel();
    }
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data?.map((x) => x.toJson()).toList(),
    "totalRecords": totalRecords,
    "totalPages": totalPages,
  };
}

class SpinHistoryItemModel {
  final String? id;
  final String? userId;
  final SpinOptionModel? spinOptionId;
  final String? spinType;
  final String? resultType;
  final int? loyaltyPoint;
  final String? couponCode;
  final DateTime? date;
  final int? v;

  const SpinHistoryItemModel({
    this.id,
    this.userId,
    this.spinOptionId,
    this.spinType,
    this.resultType,
    this.loyaltyPoint,
    this.couponCode,
    this.date,
    this.v,
  });

  factory SpinHistoryItemModel.fromJson(Map<String, dynamic> json) {
    try {
      return SpinHistoryItemModel(
        id: json["_id"] as String?,
        userId: json["userId"] as String?,
        spinOptionId: json["spinOptionId"] != null
            ? SpinOptionModel.fromJson(json["spinOptionId"])
            : null,
        spinType: json["spinType"] as String?,
        resultType: json["resultType"] as String?,
        loyaltyPoint: json["loyaltyPoint"] as int?,
        couponCode: json["couponCode"] as String?,
        date: json["date"] != null ? DateTime.tryParse(json["date"]) : null,
        v: json["__v"] as int?,
      );
    } catch (e) {
      return const SpinHistoryItemModel();
    }
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userId": userId,
    "spinOptionId": spinOptionId?.toJson(),
    "spinType": spinType,
    "resultType": resultType,
    "loyaltyPoint": loyaltyPoint,
    "couponCode": couponCode,
    "date": date?.toIso8601String(),
    "__v": v,
  };

  // Convert to entity
  SpinHistoryEntity toEntity() {
    return SpinHistoryEntity(
      id: id ?? '',
      userId: userId ?? '',
      spinOption: spinOptionId?.toEntity(),
      spinType: spinType ?? '',
      resultType: resultType ?? '',
      loyaltyPoint: loyaltyPoint,
      couponCode: couponCode,
      date: date ?? DateTime.now(),
    );
  }
}

class SpinOptionModel {
  final String? id;
  final String? type;
  final String? title;

  const SpinOptionModel({this.id, this.type, this.title});

  factory SpinOptionModel.fromJson(Map<String, dynamic> json) {
    try {
      return SpinOptionModel(
        id: json["_id"] as String?,
        type: json["type"] as String?,
        title: json["title"] as String?,
      );
    } catch (e) {
      return const SpinOptionModel();
    }
  }

  Map<String, dynamic> toJson() => {"_id": id, "type": type, "title": title};

  // Convert to entity
  SpinOptionEntity toEntity() {
    return SpinOptionEntity(id: id ?? '', type: type ?? '', title: title ?? '');
  }
}
