import 'package:flutter/material.dart';

import '../../domain/entities/spin_option_entity.dart';

class SpinOptionModel extends SpinOptionEntity {
  const SpinOptionModel({
    required super.id,
    required super.title,
    required super.description,
    required super.rewardType,
    super.loyaltyPoints,
    super.couponCode,
    super.giftDescription,
    super.discountPercentage,
    super.isWinningOption,
    super.backgroundColor,
    super.icon,
    super.probability,
  });

  factory SpinOptionModel.fromJson(Map<String, dynamic> json) {
    return SpinOptionModel(
      id: json['id'] ?? json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      rewardType: _parseRewardType(json['rewardType'] ?? json['type']),
      loyaltyPoints: json['loyaltyPoints'] ?? json['loyaltyPoint'],
      couponCode: json['couponCode'],
      giftDescription: json['giftDescription'],
      discountPercentage: json['discountPercentage']?.toDouble(),
      isWinningOption: json['isWinningOption'] ?? json['isBetterLuck'] != true,
      backgroundColor: _parseColor(json['backgroundColor']),
      icon: _parseIcon(json['icon']),
      probability: json['probability'] ?? 10,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'rewardType': rewardType.name,
      'loyaltyPoints': loyaltyPoints,
      'couponCode': couponCode,
      'giftDescription': giftDescription,
      'discountPercentage': discountPercentage,
      'isWinningOption': isWinningOption,
      'backgroundColor': backgroundColor.value,
      'icon': icon.codePoint,
      'probability': probability,
    };
  }

  static SpinRewardType _parseRewardType(String? type) {
    switch (type?.toLowerCase()) {
      case 'loyalty_points':
      case 'loyaltypoints':
      case 'points':
        return SpinRewardType.loyaltyPoints;
      case 'coupon':
      case 'couponcode':
        return SpinRewardType.coupon;
      case 'better_luck':
      case 'betterluck':
        return SpinRewardType.betterLuck;
      case 'extra_spin':
      case 'extraspin':
        return SpinRewardType.extraSpin;
      case 'gift':
        return SpinRewardType.gift;
      case 'discount':
        return SpinRewardType.discount;
      default:
        return SpinRewardType.betterLuck;
    }
  }

  static Color _parseColor(dynamic colorValue) {
    if (colorValue is String) {
      // Handle hex color strings
      if (colorValue.startsWith('#')) {
        return Color(
          int.parse(colorValue.substring(1), radix: 16) + 0xFF000000,
        );
      }
      // Handle predefined color names
      switch (colorValue.toLowerCase()) {
        case 'red':
          return Colors.red;
        case 'blue':
          return Colors.blue;
        case 'green':
          return Colors.green;
        case 'yellow':
          return Colors.yellow;
        case 'purple':
          return Colors.purple;
        case 'orange':
          return Colors.orange;
        default:
          return Colors.grey;
      }
    } else if (colorValue is int) {
      return Color(colorValue);
    }
    return Colors.grey;
  }

  static IconData _parseIcon(dynamic iconValue) {
    if (iconValue is String) {
      switch (iconValue.toLowerCase()) {
        case 'star':
          return Icons.star;
        case 'gift':
          return Icons.card_giftcard;
        case 'coupon':
          return Icons.local_offer;
        case 'points':
          return Icons.stars;
        case 'spin':
          return Icons.refresh;
        case 'discount':
          return Icons.percent;
        case 'better_luck':
          return Icons.sentiment_neutral;
        default:
          return Icons.casino;
      }
    } else if (iconValue is int) {
      return IconData(iconValue, fontFamily: 'MaterialIcons');
    }
    return Icons.casino;
  }

  SpinOptionEntity toEntity() {
    return SpinOptionEntity(
      id: id,
      title: title,
      description: description,
      rewardType: rewardType,
      loyaltyPoints: loyaltyPoints,
      couponCode: couponCode,
      giftDescription: giftDescription,
      discountPercentage: discountPercentage,
      isWinningOption: isWinningOption,
      backgroundColor: backgroundColor,
      icon: icon,
      probability: probability,
    );
  }

  factory SpinOptionModel.fromEntity(SpinOptionEntity entity) {
    return SpinOptionModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      rewardType: entity.rewardType,
      loyaltyPoints: entity.loyaltyPoints,
      couponCode: entity.couponCode,
      giftDescription: entity.giftDescription,
      discountPercentage: entity.discountPercentage,
      isWinningOption: entity.isWinningOption,
      backgroundColor: entity.backgroundColor,
      icon: entity.icon,
      probability: entity.probability,
    );
  }
}
