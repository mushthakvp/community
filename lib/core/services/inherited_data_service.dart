import 'package:flutter/material.dart';

class InheritedDataService extends InheritedWidget {
  final Map<String, dynamic> data;

  const InheritedDataService({
    super.key,
    required this.data,
    required super.child,
  });

  static InheritedDataService? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedDataService>();
  }

  @override
  bool updateShouldNotify(InheritedDataService oldWidget) {
    return data != oldWidget.data;
  }
}
