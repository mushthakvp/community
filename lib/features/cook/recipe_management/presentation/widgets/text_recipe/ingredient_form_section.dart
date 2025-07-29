import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_constants.dart';
import '../../../domain/entities/ingredient.dart';
import '../common/recipe_button.dart';
import '../common/recipe_text_field.dart';

class IngredientFormSection extends StatefulWidget {
  final Ingredient? ingredient;
  final Function(Ingredient) onSave;
  final VoidCallback? onDelete;
  final bool canDelete;
  final bool isNewIngredient;

  const IngredientFormSection({
    super.key,
    this.ingredient,
    required this.onSave,
    this.onDelete,
    this.canDelete = true,
    this.isNewIngredient = false,
  });

  @override
  State<IngredientFormSection> createState() => _IngredientFormSectionState();
}

class _IngredientFormSectionState extends State<IngredientFormSection> {
  late TextEditingController nameController;
  late TextEditingController amountController;
  late String selectedUnit;
  bool isEditing = false;

  final List<String> units = [
    'grams',
    'kg',
    'ml',
    'liters',
    'cups',
    'tablespoons',
    'pieces',
  ];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    amountController = TextEditingController();
    selectedUnit = units.first;

    if (widget.ingredient != null) {
      nameController.text = widget.ingredient!.name;
      amountController.text = widget.ingredient!.amount;
      selectedUnit = widget.ingredient!.unit;
    } else {
      isEditing = widget.isNewIngredient;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppConstants.darkBlack,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isEditing && widget.ingredient != null)
            _buildEditDeleteButtons(),
          _buildSectionTitle(),
          const SizedBox(height: 10),
          _buildIngredientNameField(),
          const SizedBox(height: 18),
          _buildAmountAndUnitFields(),
          const SizedBox(height: 25),
          if (isEditing) _buildSaveButton(),
        ],
      ),
    );
  }

  Widget _buildEditDeleteButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildActionButton('Edit', () {
          setState(() {
            isEditing = true;
          });
        }),
        const SizedBox(width: 10),
        if (widget.canDelete)
          _buildActionButton('Delete', widget.onDelete ?? () {}),
      ],
    );
  }

  Widget _buildActionButton(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 12),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xffC11D1D),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle() {
    return const Text(
      'Add Ingredients',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );
  }

  Widget _buildIngredientNameField() {
    return RecipeTextField(
      controller: nameController,
      hintText: 'Enter your ingredient name',
      backgroundColor: AppConstants.darkBlack,
      borderColor: const Color(0xff1E1E1E),
      readOnly: !isEditing,
    );
  }

  Widget _buildAmountAndUnitFields() {
    return Row(
      children: [
        Expanded(child: _buildAmountField()),
        const SizedBox(width: 10),
        Expanded(child: _buildUnitDropdown()),
      ],
    );
  }

  Widget _buildAmountField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Amount',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        RecipeTextField(
          controller: amountController,
          hintText: 'Enter Amount',
          keyboardType: TextInputType.number,
          backgroundColor: AppConstants.darkBlack,
          borderColor: const Color(0xff1E1E1E),
          readOnly: !isEditing,
        ),
      ],
    );
  }

  Widget _buildUnitDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Unit',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xff1E1E1E), width: 1.0),
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3.5),
          child: DropdownButton<String>(
            isExpanded: true,
            value: selectedUnit,
            onChanged: isEditing
                ? (newValue) {
                    setState(() {
                      selectedUnit = newValue!;
                    });
                  }
                : null,
            underline: const SizedBox.shrink(),
            dropdownColor: AppConstants.darkBlack,
            items: units
                .map(
                  (item) => DropdownMenuItem(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'HelveticaNeue',
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return RecipeButton(
      text: 'Save changes',
      onPressed: _saveIngredient,
      textColor: Colors.black,
      height: 49,
    );
  }

  void _saveIngredient() {
    if (!_validateForm()) return;
    final ingredient = Ingredient(
      id:
          widget.ingredient?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      name: nameController.text.trim(),
      amount: amountController.text.trim(),
      unit: selectedUnit,
    );
    widget.onSave(ingredient);
    if (widget.isNewIngredient) {
      nameController.clear();
      amountController.clear();
      selectedUnit = units.first;
    } else {
      setState(() {
        isEditing = false;
      });
    }
  }

  bool _validateForm() {
    if (nameController.text.trim().isEmpty) {
      _showErrorSnackbar('Please enter ingredient name');
      return false;
    }

    if (amountController.text.trim().isEmpty) {
      _showErrorSnackbar('Please enter ingredient amount');
      return false;
    }

    return true;
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
