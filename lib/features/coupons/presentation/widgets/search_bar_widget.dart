import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/common_text_form_field.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CommonTextFormField(
      controller: controller,
      onChanged: onChanged,
      borderSide: const BorderSide(color: AppConstants.black),
      bgColor: const Color(0xffFFFFFF).withOpacity(0.2),
      keyboardType: TextInputType.text,
      hintText: 'Search coupons...',
      prefixIcon: const Icon(Icons.search, color: AppConstants.white),
      suffixIcon: controller.text.isNotEmpty
          ? IconButton(
              onPressed: () {
                controller.clear();
                onChanged('');
              },
              icon: const Icon(Icons.clear, color: AppConstants.white),
            )
          : null,
    );
  }
}
