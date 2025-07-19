import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/vcart_colors.dart';
import '../controllers/search_controller.dart';
import 'recent_searches_dropdown.dart';

class SearchField extends StatefulWidget {
  final VCartSearchController controller;

  const SearchField({super.key, required this.controller});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _showDropdown = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    widget.controller.searchController.addListener(_onTextChange);
  }

  @override
  void dispose() {
    _removeOverlay();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus && widget.controller.recentSearches.isNotEmpty) {
      _showRecentSearches();
    } else {
      _hideRecentSearches();
    }
  }

  void _onTextChange() {
    widget.controller.checkIsClear();
    if (widget.controller.searchController.text.isEmpty &&
        _focusNode.hasFocus) {
      _showRecentSearches();
    } else {
      _hideRecentSearches();
    }
  }

  void _showRecentSearches() {
    if (_showDropdown) return;

    _showDropdown = true;
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideRecentSearches() {
    if (!_showDropdown) return;

    _showDropdown = false;
    _removeOverlay();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Size size = renderBox.size;
    Offset offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height,
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          child: Material(
            elevation: 4,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(6),
              bottomRight: Radius.circular(6),
            ),
            child: RecentSearchesDropdown(
              controller: widget.controller,
              onSearchTap: (searchTerm) {
                widget.controller.onRecentSearchTap(searchTerm);
                _hideRecentSearches();
                _focusNode.unfocus();
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: Container(
          decoration: BoxDecoration(
            color: VCartColors.surface,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: VCartColors.border, width: 0.3),
          ),
          child: TextField(
            controller: widget.controller.searchController,
            focusNode: _focusNode,
            textInputAction: TextInputAction.search,
            style: const TextStyle(
              color: VCartColors.textPrimary,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              hintText: "Find You Needed....",
              hintStyle: TextStyle(
                color: VCartColors.textPrimary.withOpacity(0.6),
                fontWeight: FontWeight.w300,
                fontSize: 14,
              ),
              prefixIcon: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Icon(
                  Icons.search,
                  size: 20,
                  color: VCartColors.textSecondary,
                ),
              ),
              suffixIcon: Obx(() {
                return widget.controller.searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.clear,
                          color: VCartColors.textSecondary,
                        ),
                        onPressed: () {
                          widget.controller.clearSearch();
                          _hideRecentSearches();
                        },
                      )
                    : const SizedBox.shrink();
              }),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            onSubmitted: (value) {
              widget.controller.performSearch();
              _hideRecentSearches();
              _focusNode.unfocus();
            },
            onTapOutside: (event) {
              _hideRecentSearches();
              _focusNode.unfocus();
            },
          ),
        ),
      ),
    );
  }
}
