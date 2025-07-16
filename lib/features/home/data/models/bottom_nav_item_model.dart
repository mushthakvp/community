class BottomNavItemModel {
  final int itemId;
  final String icon;
  final String label;

  BottomNavItemModel({
    required this.icon,
    required this.label,
    required this.itemId,
  });

  factory BottomNavItemModel.fromJson(Map<String, dynamic> json) {
    return BottomNavItemModel(
      itemId: json['itemId'],
      icon: json['icon'],
      label: json['label'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'itemId': itemId, 'icon': icon, 'label': label};
  }
}
