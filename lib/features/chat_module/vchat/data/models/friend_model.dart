import 'package:equatable/equatable.dart';

class FriendModel extends Equatable {
  final String id;
  final String name;
  final String? profileImage;
  final bool isOnline;
  final DateTime? lastSeen;
  final String? status;
  final String? email;
  final String? phone;

  const FriendModel({
    required this.id,
    required this.name,
    this.profileImage,
    this.isOnline = false,
    this.lastSeen,
    this.status,
    this.email,
    this.phone,
  });

  factory FriendModel.fromJson(Map<String, dynamic> json) {
    return FriendModel(
      id: json['_id'] ?? json['id'] ?? '',
      name:
          json['name'] ??
          json['userName'] ??
          json['friendName'] ??
          json['displayName'] ??
          '',
      profileImage: json['profileImage'] ?? json['avatar'] ?? json['image'],
      isOnline: json['isOnline'] ?? false,
      lastSeen: json['lastSeen'] != null
          ? DateTime.tryParse(json['lastSeen'])
          : null,
      status: json['status'],
      email: json['email'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'profileImage': profileImage,
      'isOnline': isOnline,
      'lastSeen': lastSeen?.toIso8601String(),
      'status': status,
      'email': email,
      'phone': phone,
    };
  }

  FriendModel copyWith({
    String? id,
    String? name,
    String? profileImage,
    bool? isOnline,
    DateTime? lastSeen,
    String? status,
    String? email,
    String? phone,
  }) {
    return FriendModel(
      id: id ?? this.id,
      name: name ?? this.name,
      profileImage: profileImage ?? this.profileImage,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
      status: status ?? this.status,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    profileImage,
    isOnline,
    lastSeen,
    status,
    email,
    phone,
  ];
}
