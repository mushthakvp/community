import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class NavItem extends Equatable {
  final int id;
  final String label;
  final IconData? iconData;
  final IconData? activeIconData;
  final String route;
  final bool isActive;

  const NavItem({
    required this.id,
    required this.label,
    this.iconData,
    this.activeIconData,
    required this.route,
    this.isActive = false,
  });

  NavItem copyWith({
    int? id,
    String? label,
    String? icon,
    IconData? iconData,
    IconData? activeIconData,
    String? route,
    bool? isActive,
  }) {
    return NavItem(
      id: id ?? this.id,
      label: label ?? this.label,
      iconData: iconData ?? this.iconData,
      activeIconData: activeIconData ?? this.activeIconData,
      route: route ?? this.route,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [
    id,
    label,
    iconData,
    activeIconData,
    route,
    isActive,
  ];
}
