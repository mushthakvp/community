import 'package:equatable/equatable.dart';

class NavItem extends Equatable {
  final int id;
  final String label;
  final String icon;
  final String route;
  final bool isActive;

  const NavItem({
    required this.id,
    required this.label,
    required this.icon,
    required this.route,
    this.isActive = false,
  });

  NavItem copyWith({
    int? id,
    String? label,
    String? icon,
    String? route,
    bool? isActive,
  }) {
    return NavItem(
      id: id ?? this.id,
      label: label ?? this.label,
      icon: icon ?? this.icon,
      route: route ?? this.route,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [id, label, icon, route, isActive];
}
