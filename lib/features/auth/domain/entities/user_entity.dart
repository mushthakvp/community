// lib/features/auth/domain/entities/user_entity.dart
import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? profileImage;
  final String? gender;
  final DateTime? dateOfBirth;
  final String? profession;
  final String? country;
  final String? state;
  final String? district;
  final String? tier;
  final String? currencyCode;
  final int loyaltyPoints;
  final double walletAmount;
  final bool isOtpVerified;
  final bool profileCompleted;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.profileImage,
    this.gender,
    this.dateOfBirth,
    this.profession,
    this.country,
    this.currencyCode,
    this.state,
    this.district,
    this.tier,
    this.loyaltyPoints = 0,
    this.walletAmount = 0.0,
    this.isOtpVerified = false,
    this.profileCompleted = false,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    phone,
    profileImage,
    gender,
    dateOfBirth,
    profession,
    country,
    currencyCode,
    state,
    district,
    tier,
    loyaltyPoints,
    walletAmount,
    isOtpVerified,
    profileCompleted,
  ];
}
