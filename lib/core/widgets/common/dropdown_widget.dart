import 'package:flutter/material.dart';

import '../../constants/app_constants.dart';
import 'text_widget.dart';

class CommonDropdown<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final String hintText;
  final Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final bool isExpanded;
  final Widget? prefixIcon;
  final Color? fillColor;
  final Color? borderColor;
  final double borderRadius;
  final EdgeInsetsGeometry? contentPadding;

  const CommonDropdown({
    super.key,
    this.value,
    required this.items,
    required this.hintText,
    this.onChanged,
    this.validator,
    this.isExpanded = true,
    this.prefixIcon,
    this.fillColor,
    this.borderColor,
    this.borderRadius = 8.0,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      validator: validator,
      isExpanded: isExpanded,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: AppConstants.white.withOpacity(0.6),
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: prefixIcon,
        filled: true,
        fillColor: fillColor ?? const Color(0xff1A1A1A),
        contentPadding:
            contentPadding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: borderColor ?? AppConstants.white.withOpacity(0.1),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: borderColor ?? AppConstants.white.withOpacity(0.1),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(
            color: AppConstants.appPrimaryColor,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
      dropdownColor: const Color(0xff1A1A1A),
      icon: Icon(
        Icons.keyboard_arrow_down,
        color: AppConstants.white.withOpacity(0.7),
        size: 20,
      ),
      style: const TextStyle(
        color: AppConstants.white,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

// Alternative Dropdown with custom styling
class StyledDropdown<T> extends StatefulWidget {
  final T? value;
  final List<T> items;
  final String hintText;
  final Function(T?)? onChanged;
  final String Function(T) itemLabel;
  final Widget? prefixIcon;
  final bool enabled;

  const StyledDropdown({
    super.key,
    this.value,
    required this.items,
    required this.hintText,
    this.onChanged,
    required this.itemLabel,
    this.prefixIcon,
    this.enabled = true,
  });

  @override
  State<StyledDropdown<T>> createState() => _StyledDropdownState<T>();
}

class _StyledDropdownState<T> extends State<StyledDropdown<T>> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: widget.enabled ? _toggleDropdown : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xff1A1A1A),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _isExpanded
                    ? AppConstants.appPrimaryColor
                    : AppConstants.white.withOpacity(0.1),
              ),
            ),
            child: Row(
              children: [
                if (widget.prefixIcon != null) ...[
                  widget.prefixIcon!,
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: CommonTextWidget(
                    text: widget.value != null
                        ? widget.itemLabel(widget.value as T)
                        : widget.hintText,
                    color: widget.value != null
                        ? AppConstants.white
                        : AppConstants.white.withOpacity(0.6),
                    fontSize: 14,
                  ),
                ),
                AnimatedRotation(
                  turns: _isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: AppConstants.white.withOpacity(0.7),
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_isExpanded) _buildDropdownItems(),
      ],
    );
  }

  Widget _buildDropdownItems() {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        color: const Color(0xff1A1A1A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppConstants.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: widget.items.map((item) {
          final isSelected = widget.value == item;
          return InkWell(
            onTap: () => _selectItem(item),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppConstants.appPrimaryColor.withOpacity(0.1)
                    : Colors.transparent,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: CommonTextWidget(
                      text: widget.itemLabel(item),
                      color: isSelected
                          ? AppConstants.appPrimaryColor
                          : AppConstants.white,
                      fontSize: 14,
                    ),
                  ),
                  if (isSelected)
                    const Icon(
                      Icons.check,
                      color: AppConstants.appPrimaryColor,
                      size: 16,
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _toggleDropdown() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _selectItem(T item) {
    widget.onChanged?.call(item);
    setState(() {
      _isExpanded = false;
    });
  }
}
