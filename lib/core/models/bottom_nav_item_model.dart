// lib/core/models/bottom_nav_item_model.dart
class BottomNavItemModel {
  final int itemId;
  final String icon;
  final String activeIcon;
  final String label;
  final String route;

  BottomNavItemModel({
    required this.itemId,
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
  });

  factory BottomNavItemModel.fromJson(Map<String, dynamic> json) {
    return BottomNavItemModel(
      itemId: json['itemId'] ?? 0,
      icon: json['icon'] ?? '',
      activeIcon: json['activeIcon'] ?? json['icon'] ?? '',
      label: json['label'] ?? '',
      route: json['route'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'icon': icon,
      'activeIcon': activeIcon,
      'label': label,
      'route': route,
    };
  }

  BottomNavItemModel copyWith({
    int? itemId,
    String? icon,
    String? activeIcon,
    String? label,
    String? route,
  }) {
    return BottomNavItemModel(
      itemId: itemId ?? this.itemId,
      icon: icon ?? this.icon,
      activeIcon: activeIcon ?? this.activeIcon,
      label: label ?? this.label,
      route: route ?? this.route,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BottomNavItemModel &&
        other.itemId == itemId &&
        other.icon == icon &&
        other.activeIcon == activeIcon &&
        other.label == label &&
        other.route == route;
  }

  @override
  int get hashCode {
    return itemId.hashCode ^
        icon.hashCode ^
        activeIcon.hashCode ^
        label.hashCode ^
        route.hashCode;
  }

  @override
  String toString() {
    return 'BottomNavItemModel(itemId: $itemId, icon: $icon, activeIcon: $activeIcon, label: $label, route: $route)';
  }
}
