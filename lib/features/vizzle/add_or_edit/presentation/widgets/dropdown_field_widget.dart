import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../../../core/widgets/inputs/text_field.dart';

class DropdownFieldWidget extends StatelessWidget {
  final String hintText;
  final String? value;
  final List<String> options;
  final Function(String) onChanged;
  final String? Function(String?)? validator;

  const DropdownFieldWidget({
    super.key,
    required this.hintText,
    required this.options,
    required this.onChanged,
    this.value,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showOptionsBottomSheet(context),
      child: CommonTextField(
        hintText: hintText,
        controller: TextEditingController(text: value ?? ''),
        readOnly: true,
        validator: validator,
        suffixIcon: Icon(
          Icons.keyboard_arrow_down,
          color: AppConstants.white.withOpacity(0.6),
        ),
      ),
    );
  }

  void _showOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppConstants.surfaceVariant,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonTextWidget(
                  text: hintText,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: AppConstants.white),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options[index];
                  final isSelected = option == value;

                  return ListTile(
                    title: CommonTextWidget(
                      text: option,
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: isSelected
                          ? AppConstants.appPrimaryColor
                          : AppConstants.white,
                    ),
                    trailing: isSelected
                        ? Icon(
                            Icons.check_circle,
                            color: AppConstants.appPrimaryColor,
                          )
                        : null,
                    onTap: () {
                      onChanged(option);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
