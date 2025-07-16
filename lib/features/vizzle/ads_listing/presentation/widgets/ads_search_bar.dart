import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';

class AdsSearchBar extends StatefulWidget {
  final Function(String) onSearch;
  final String? currentKeyword;
  final String? hint;

  const AdsSearchBar({
    super.key,
    required this.onSearch,
    this.currentKeyword,
    this.hint,
  });

  @override
  State<AdsSearchBar> createState() => _AdsSearchBarState();
}

class _AdsSearchBarState extends State<AdsSearchBar> {
  late TextEditingController _controller;
  Timer? _debouncer;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentKeyword);
  }

  @override
  void dispose() {
    _controller.dispose();
    _debouncer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debouncer?.cancel();
    _debouncer = Timer(const Duration(milliseconds: 300), () {
      widget.onSearch(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppConstants.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: TextField(
        controller: _controller,
        onChanged: _onSearchChanged,
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
        style: const TextStyle(color: AppConstants.white),
        decoration: InputDecoration(
          hintText: widget.hint ?? 'Search ads...',
          hintStyle: TextStyle(
            color: AppConstants.white.withOpacity(0.6),
            fontSize: 14,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: AppConstants.white.withOpacity(0.6),
            size: 20,
          ),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _controller.clear();
                    widget.onSearch('');
                  },
                  icon: Icon(
                    Icons.clear,
                    color: AppConstants.white.withOpacity(0.6),
                    size: 20,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
