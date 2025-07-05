import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/inputs/text_field.dart';

class FaqSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onSearch;

  const FaqSearchBar({
    super.key,
    required this.controller,
    required this.onSearch,
  });

  @override
  State<FaqSearchBar> createState() => _FaqSearchBarState();
}

class _FaqSearchBarState extends State<FaqSearchBar> {
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      widget.onSearch(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CommonTextField(
      controller: widget.controller,
      hintText: 'Search FAQs...',
      prefixIcon: const Icon(Icons.search, color: AppConstants.white),
      suffixIcon: widget.controller.text.isNotEmpty
          ? IconButton(
              onPressed: () {
                widget.controller.clear();
                widget.onSearch('');
              },
              icon: const Icon(Icons.clear, color: AppConstants.white),
            )
          : null,
      onChanged: _onSearchChanged,
    );
  }
}
