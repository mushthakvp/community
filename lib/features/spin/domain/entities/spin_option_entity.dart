import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum SpinRewardType {
  loyaltyPoints,
  coupon,
  betterLuck,
  extraSpin,
  gift,
  discount,
}

class SpinOptionEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final SpinRewardType rewardType;
  final int? loyaltyPoints;
  final String? couponCode;
  final String? giftDescription;
  final double? discountPercentage;
  final bool isWinningOption;
  final Color backgroundColor;
  final IconData icon;
  final int probability; // 1-100

  const SpinOptionEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.rewardType,
    this.loyaltyPoints,
    this.couponCode,
    this.giftDescription,
    this.discountPercentage,
    this.isWinningOption = false,
    this.backgroundColor = Colors.grey,
    this.icon = Icons.star,
    this.probability = 10,
  });

  SpinOptionEntity copyWith({
    String? id,
    String? title,
    String? description,
    SpinRewardType? rewardType,
    int? loyaltyPoints,
    String? couponCode,
    String? giftDescription,
    double? discountPercentage,
    bool? isWinningOption,
    Color? backgroundColor,
    IconData? icon,
    int? probability,
  }) {
    return SpinOptionEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      rewardType: rewardType ?? this.rewardType,
      loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
      couponCode: couponCode ?? this.couponCode,
      giftDescription: giftDescription ?? this.giftDescription,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      isWinningOption: isWinningOption ?? this.isWinningOption,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      icon: icon ?? this.icon,
      probability: probability ?? this.probability,
    );
  }

  // Helper methods
  String get displayTitle => title.isNotEmpty ? title : 'Mystery Prize';
  String get displayDescription =>
      description.isNotEmpty ? description : 'Try your luck!';

  String get rewardDisplayText {
    switch (rewardType) {
      case SpinRewardType.loyaltyPoints:
        return '$loyaltyPoints Points';
      case SpinRewardType.coupon:
        return couponCode ?? 'Coupon Code';
      case SpinRewardType.betterLuck:
        return 'Better Luck Next Time';
      case SpinRewardType.extraSpin:
        return 'Extra Spin';
      case SpinRewardType.gift:
        return giftDescription ?? 'Gift';
      case SpinRewardType.discount:
        return '${discountPercentage?.toStringAsFixed(0)}% Off';
    }
  }

  IconData get rewardIcon {
    switch (rewardType) {
      case SpinRewardType.loyaltyPoints:
        return Icons.stars;
      case SpinRewardType.coupon:
        return Icons.local_offer;
      case SpinRewardType.betterLuck:
        return Icons.sentiment_neutral;
      case SpinRewardType.extraSpin:
        return Icons.refresh;
      case SpinRewardType.gift:
        return Icons.card_giftcard;
      case SpinRewardType.discount:
        return Icons.percent;
    }
  }

  Color get rewardColor {
    switch (rewardType) {
      case SpinRewardType.loyaltyPoints:
        return Colors.amber;
      case SpinRewardType.coupon:
        return Colors.green;
      case SpinRewardType.betterLuck:
        return Colors.grey;
      case SpinRewardType.extraSpin:
        return Colors.purple;
      case SpinRewardType.gift:
        return Colors.red;
      case SpinRewardType.discount:
        return Colors.blue;
    }
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    rewardType,
    loyaltyPoints,
    couponCode,
    giftDescription,
    discountPercentage,
    isWinningOption,
    backgroundColor,
    icon,
    probability,
  ];
}
