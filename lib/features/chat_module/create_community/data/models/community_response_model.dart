import 'community_model.dart';

class CommunityResponseModel {
  final bool success;
  final String? message;
  final CommunityModel? community;
  final List<CommunityModel>? communities;

  CommunityResponseModel({
    required this.success,
    this.message,
    this.community,
    this.communities,
  });

  factory CommunityResponseModel.fromJson(Map<String, dynamic> json) {
    return CommunityResponseModel(
      success: json['success'] ?? false,
      message: json['message'],
      community: json['data'] != null
          ? CommunityModel.fromJson(json['data'])
          : null,
      communities: json['communities'] != null
          ? (json['communities'] as List)
                .map((community) => CommunityModel.fromJson(community))
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': community?.toJson(),
      'communities': communities?.map((c) => c.toJson()).toList(),
    };
  }
}
