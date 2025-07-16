import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';

class CustomDropdownField extends StatefulWidget {
  final String? value;
  final List<String> items;
  final String hintText;
  final Function(String?)? onChanged;
  final Future<void> Function(String)? onCreateNew;

  const CustomDropdownField({
    super.key,
    this.value,
    required this.items,
    required this.hintText,
    this.onChanged,
    this.onCreateNew,
  });

  @override
  State<CustomDropdownField> createState() => _CustomDropdownFieldState();
}

class _CustomDropdownFieldState extends State<CustomDropdownField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isDropdownOpen = false;
  List<String> _filteredItems = [];
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.value ?? '';
    _filteredItems = widget.items;
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void didUpdateWidget(CustomDropdownField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _controller.text = widget.value ?? '';
    }
    if (widget.items != oldWidget.items) {
      _filteredItems = widget.items;
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    _controller.dispose();
    _closeDropdown();
    super.dispose();
  }

  void _onFocusChanged() {
    if (_isDisposed) return;

    if (_focusNode.hasFocus) {
      _openDropdown();
    } else {
      _closeDropdown();
    }
  }

  void _openDropdown() {
    if (_isDropdownOpen || _isDisposed) return;

    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 4),
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(8),
            color: const Color(0xff1A1A1A),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppConstants.white.withOpacity(0.1)),
              ),
              child: _buildDropdownContent(),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    if (!_isDisposed) {
      setState(() => _isDropdownOpen = true);
    }
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (!_isDisposed && mounted) {
      setState(() => _isDropdownOpen = false);
    }
  }

  Widget _buildDropdownContent() {
    if (_filteredItems.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: CommonTextWidget(
          text: 'No items found',
          color: AppConstants.white.withOpacity(0.6),
          fontSize: 14,
          align: TextAlign.center,
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: _filteredItems.length,
      itemBuilder: (context, index) {
        final item = _filteredItems[index];
        return InkWell(
          onTap: () => _selectItem(item),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: CommonTextWidget(
              text: item,
              color: AppConstants.white,
              fontSize: 14,
            ),
          ),
        );
      },
    );
  }

  void _selectItem(String item) {
    if (_isDisposed) return;

    _controller.text = item;
    widget.onChanged?.call(item);
    _closeDropdown();
    _focusNode.unfocus();
  }

  void _filterItems(String query) {
    if (_isDisposed) return;

    setState(() {
      if (query.isEmpty) {
        _filteredItems = widget.items;
      } else {
        _filteredItems = widget.items
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> _createNewItem() async {
    if (_isDisposed) return;

    final text = _controller.text.trim();
    if (text.isNotEmpty && widget.onCreateNew != null) {
      await widget.onCreateNew!(text);
      _closeDropdown();
      _focusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextFormField(
        controller: _controller,
        focusNode: _focusNode,
        style: const TextStyle(color: AppConstants.white, fontSize: 14),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: AppConstants.white.withOpacity(0.6),
            fontSize: 14,
          ),
          filled: true,
          fillColor: const Color(0xff1A1A1A),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppConstants.white.withOpacity(0.1)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppConstants.white.withOpacity(0.1)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppConstants.appPrimaryColor),
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_controller.text.isNotEmpty && widget.onCreateNew != null)
                GestureDetector(
                  onTap: _createNewItem,
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppConstants.appPrimaryColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      Icons.add,
                      color: AppConstants.black,
                      size: 16,
                    ),
                  ),
                ),
              Icon(
                _isDropdownOpen
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: AppConstants.white,
                size: 20,
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
        onChanged: (value) {
          _filterItems(value);
          widget.onChanged?.call(value);
        },
        onTap: _openDropdown,
      ),
    );
  }
}
