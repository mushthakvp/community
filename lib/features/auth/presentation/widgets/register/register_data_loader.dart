import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterDataLoader extends StatefulWidget {
  final Widget child;

  const RegisterDataLoader({super.key, required this.child});

  @override
  State<RegisterDataLoader> createState() => _RegisterDataLoaderState();
}

class _RegisterDataLoaderState extends State<RegisterDataLoader> {
  List<String> _professions = [];
  List<Map<String, dynamic>> _countries = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final professionData = await rootBundle.loadString(
        'assets/data/profession.json',
      );
      final List<dynamic> professionList = json.decode(professionData);

      final stateData = await rootBundle.loadString(
        'assets/data/state_and_district.json',
      );
      final List<dynamic> locationData = json.decode(stateData);

      setState(() {
        _professions = professionList.cast<String>();
        _countries = locationData.cast<Map<String, dynamic>>();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading data: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return RegisterDataProvider(
      professions: _professions,
      countries: _countries,
      child: widget.child,
    );
  }
}

class RegisterDataProvider extends InheritedWidget {
  final List<String> professions;
  final List<Map<String, dynamic>> countries;

  const RegisterDataProvider({
    super.key,
    required this.professions,
    required this.countries,
    required super.child,
  });

  static RegisterDataProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<RegisterDataProvider>();
  }

  @override
  bool updateShouldNotify(RegisterDataProvider oldWidget) {
    return professions != oldWidget.professions ||
        countries != oldWidget.countries;
  }
}
