import '../../domain/entities/nav_item.dart';

class NavItemModel extends NavItem {
  const NavItemModel({
    required super.id,
    required super.label,
    required super.icon,
    required super.route,
    super.isActive,
  });

  factory NavItemModel.fromJson(Map<String, dynamic> json) {
    return NavItemModel(
      id: json['id'] ?? 0,
      label: json['label'] ?? '',
      icon: json['icon'] ?? '',
      route: json['route'] ?? '',
      isActive: json['isActive'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'icon': icon,
      'route': route,
      'isActive': isActive,
    };
  }
}
