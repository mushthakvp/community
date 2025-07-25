import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/add_text_recipe_controller.dart';

class IngredientSectionCard extends StatelessWidget {
  final int index;
  final AddTextRecipeController controller;
  final bool isLast;

  const IngredientSectionCard({
    super.key,
    required this.index,
    required this.controller,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final section = controller.ingredientSections[index];
    final isEditingObs = section['isEditing'] as RxBool;
    final unitObs = section['unit'] as RxString;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xff0F0F0F),
          ),
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isEditingObs.value) _buildEditDeleteButtons(),
                _buildSectionTitle(),
                const SizedBox(height: 10),
                _buildIngredientNameField(section, isEditingObs),
                const SizedBox(height: 18),
                _buildAmountAndUnitFields(section, isEditingObs, unitObs),
                if (isEditingObs.value) ...[
                  const SizedBox(height: 25),
                  _buildSaveButton(isEditingObs),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        if (isLast && !isEditingObs.value) _buildAddIngredientButton(),
      ],
    );
  }

  Widget _buildEditDeleteButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildActionButton(
          'Edit',
          () => controller.editIngredientSection(index),
        ),
        const SizedBox(width: 10),
        _buildActionButton(
          'Delete',
          () => controller.deleteIngredientSection(index),
        ),
      ],
    );
  }

  Widget _buildActionButton(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xffC11D1D),
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSectionTitle() {
    return const Text(
      'Add Ingredients',
      style: TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildIngredientNameField(
    Map<String, dynamic> section,
    RxBool isEditing,
  ) {
    return TextFormField(
      controller: section['name'] as TextEditingController,
      readOnly: !isEditing.value,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: 'Enter your ingredient name',
        hintStyle: TextStyle(
          color: Colors.white.withOpacity(0.6),
          fontSize: 14,
        ),
        filled: true,
        fillColor: const Color(0xff1E1E1E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xff1E1E1E)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xff1E1E1E)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.amber),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 12,
        ),
      ),
    );
  }

  Widget _buildAmountAndUnitFields(
    Map<String, dynamic> section,
    RxBool isEditing,
    RxString unitObs,
  ) {
    return Row(
      children: [
        Expanded(child: _buildAmountField(section, isEditing)),
        const SizedBox(width: 10),
        Expanded(child: _buildUnitDropdown(unitObs, isEditing)),
      ],
    );
  }

  Widget _buildAmountField(Map<String, dynamic> section, RxBool isEditing) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Amount',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: section['amount'] as TextEditingController,
          readOnly: !isEditing.value,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Enter Amount',
            hintStyle: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 14,
            ),
            filled: true,
            fillColor: const Color(0xff1E1E1E),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xff1E1E1E)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xff1E1E1E)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.amber),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUnitDropdown(RxString unitObs, RxBool isEditing) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Unit',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xff1E1E1E)),
            borderRadius: BorderRadius.circular(8),
            color: const Color(0xff1E1E1E),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3.5),
          child: Obx(
            () => DropdownButton<String>(
              isExpanded: true,
              value: unitObs.value,
              onChanged: isEditing.value
                  ? (newValue) => unitObs.value = newValue!
                  : null,
              underline: const SizedBox.shrink(),
              dropdownColor: const Color(0xff1E1E1E),
              style: const TextStyle(color: Colors.white, fontSize: 14),
              items: controller.units
                  .map(
                    (unit) => DropdownMenuItem(value: unit, child: Text(unit)),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(RxBool isEditing) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (controller.saveIngredient(index)) {
            isEditing.value = false;
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: const Text(
          'Save changes',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildAddIngredientButton() {
    return GestureDetector(
      onTap: controller.addIngredientSection,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: const Text(
          'Add Ingredients',
          style: TextStyle(
            color: Colors.amber,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
