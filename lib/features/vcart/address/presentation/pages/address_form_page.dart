import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/vcart_colors.dart';
import '../../../core/utils/vcart_extensions.dart';
import '../../../core/widgets/vcart_button.dart';
import '../controllers/address_controller.dart';

class VCartAddressFormPage extends StatefulWidget {
  final String? addressId;

  const VCartAddressFormPage({super.key, this.addressId});

  @override
  State<VCartAddressFormPage> createState() => _VCartAddressFormPageState();
}

class _VCartAddressFormPageState extends State<VCartAddressFormPage> {
  VCartAddressController? controller;
  bool isInitializing = true;
  final _formKey = GlobalKey<FormState>();

  bool get isEditing => widget.addressId != null;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  Future<void> _initializeController() async {
    try {
      controller = Get.find<VCartAddressController>();
      if (mounted) {
        setState(() {
          isInitializing = false;
        });
      }
    } catch (e) {
      debugPrint('Failed to initialize address controller: $e');
      if (mounted) {
        setState(() {
          isInitializing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VCartColors.background,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: VCartColors.background,
      elevation: 0,
      centerTitle: false,
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: Container(
          height: 36,
          width: 36,
          decoration: BoxDecoration(
            border: Border.all(color: VCartColors.border, width: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.arrow_back,
            size: 18,
            color: VCartColors.textPrimary,
          ),
        ),
      ),
      title: Text(
        isEditing ? 'Edit Address' : 'Add New Address',
        style: const TextStyle(
          color: VCartColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (isInitializing || controller == null) {
      return const Center(
        child: CircularProgressIndicator(color: VCartColors.primary),
      );
    }

    return GetBuilder<VCartAddressController>(
      init: controller,
      builder: (addressController) {
        return Obx(() => _buildFormContent(addressController));
      },
    );
  }

  Widget _buildFormContent(VCartAddressController addressController) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: context.defaultPadding,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField(
                    controller: addressController.nameController,
                    label: 'Full Name',
                    hint: 'Enter your full name',
                    validator: _requiredValidator,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: addressController.phoneController,
                    label: 'Phone Number',
                    hint: 'Enter your phone number',
                    keyboardType: TextInputType.phone,
                    validator: _phoneValidator,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: addressController.addressController,
                    label: 'Address',
                    hint: 'House no, Building name, Street',
                    maxLines: 3,
                    validator: _requiredValidator,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: addressController.cityController,
                          label: 'City',
                          hint: 'Enter city',
                          validator: _requiredValidator,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          controller: addressController.stateController,
                          label: 'State',
                          hint: 'Enter state',
                          validator: _requiredValidator,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: addressController.pinCodeController,
                    label: 'Pin Code',
                    hint: 'Enter pin code',
                    keyboardType: TextInputType.number,
                    validator: _pinCodeValidator,
                  ),
                  const SizedBox(height: 100), // Space for bottom button
                ],
              ),
            ),
          ),
        ),
        _buildBottomSection(addressController),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: VCartColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          onTapOutside: (event) =>
              FocusManager.instance.primaryFocus?.unfocus(),
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          style: const TextStyle(color: VCartColors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: VCartColors.textSecondary),
            filled: true,
            fillColor: VCartColors.surface.withOpacity(0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: VCartColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: VCartColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: VCartColors.primary),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: VCartColors.error),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomSection(VCartAddressController addressController) {
    return Container(
      padding: context.defaultPadding,
      decoration: const BoxDecoration(
        color: VCartColors.background,
        border: Border(top: BorderSide(color: VCartColors.border, width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: VCartButton(
          text: isEditing ? "Update Address" : "Save Address",
          onPressed: () => _handleSubmit(addressController),
          isLoading: addressController.isLoading,
          isExpanded: true,
          height: 55,
        ),
      ),
    );
  }

  void _handleSubmit(VCartAddressController addressController) {
    if (_formKey.currentState?.validate() ?? false) {
      if (isEditing) {
        addressController.updateExistingAddress(context);
      } else {
        addressController.addNewAddress(context);
      }
    }
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? _phoneValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    if (value.length < 10) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  String? _pinCodeValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Pin code is required';
    }
    if (value.length != 6) {
      return 'Enter a valid 6-digit pin code';
    }
    return null;
  }
}
