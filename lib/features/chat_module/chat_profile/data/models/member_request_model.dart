import '../../domain/entities/member_request_entity.dart';

class MemberRequestModel extends MemberRequestEntity {
  const MemberRequestModel({
    required super.id,
    required super.name,
    super.profileImage,
  });

  factory MemberRequestModel.fromJson(Map<String, dynamic> json) {
    return MemberRequestModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      profileImage: json['profileImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name, 'profileImage': profileImage};
  }
}

class MemberRequestsModel extends MemberRequestsEntity {
  const MemberRequestsModel({
    required super.id,
    required super.creator,
    required super.requests,
  });

  factory MemberRequestsModel.fromJson(Map<String, dynamic> json) {
    return MemberRequestsModel(
      id: json['_id'] ?? '',
      creator: json['creator'] ?? '',
      requests: json['requests'] == null
          ? []
          : List<MemberRequestModel>.from(
              json['requests'].map((x) => MemberRequestModel.fromJson(x)),
            ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'creator': creator,
      'requests': requests
          .map((request) => (request as MemberRequestModel).toJson())
          .toList(),
    };
  }
}

class MemberRequestResponseModel {
  final bool success;
  final String message;
  final MemberRequestsModel? requests;

  MemberRequestResponseModel({
    required this.success,
    required this.message,
    this.requests,
  });

  factory MemberRequestResponseModel.fromJson(Map<String, dynamic> json) {
    return MemberRequestResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      requests: json['requests'] == null
          ? null
          : MemberRequestsModel.fromJson(json['requests']),
    );
  }
}
