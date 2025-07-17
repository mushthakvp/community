import '../../domain/entities/nav_item.dart';

class NavItemModel extends NavItem {
  const NavItemModel({
    required super.id,
    required super.label,
    super.iconData,
    super.activeIconData,
    required super.route,
    super.isActive,
  });

  factory NavItemModel.fromJson(Map<String, dynamic> json) {
    return NavItemModel(
      id: json['id'] ?? 0,
      label: json['label'] ?? '',
      route: json['route'] ?? '',
      isActive: json['isActive'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'label': label, 'route': route, 'isActive': isActive};
  }
}
