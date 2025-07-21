import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/error/failures.dart';
import '../../../core/router/vcart_router.dart';
import '../../../core/utils/vcart_extensions.dart';
import '../../domain/entities/address.dart';
import '../../domain/entities/address_form_data.dart';
import '../../domain/entities/address_list_data.dart';
import '../../domain/usecases/manage_addresses.dart';

class VCartAddressController extends GetxController {
  final GetAddresses getAddressesUseCase;
  final AddAddress addAddressUseCase;
  final UpdateAddress updateAddressUseCase;
  final DeleteAddress deleteAddressUseCase;
  final GetCachedSelectedAddress getCachedSelectedAddressUseCase;
  final CacheSelectedAddress cacheSelectedAddressUseCase;

  VCartAddressController({
    required this.getAddressesUseCase,
    required this.addAddressUseCase,
    required this.updateAddressUseCase,
    required this.deleteAddressUseCase,
    required this.getCachedSelectedAddressUseCase,
    required this.cacheSelectedAddressUseCase,
  });

  // Observable variables
  final _isLoading = false.obs;
  final _addressListData = Rxn<AddressListData>();
  final _errorMessage = ''.obs;
  final _hasError = false.obs;
  final _isLoadingMore = false.obs;

  // Form variables
  final _addressFormData = Rxn<AddressFormData>();
  final _editingAddress = Rxn<Address>();

  // Form controllers
  final titleController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final pinCodeController = TextEditingController();

  // Getters
  bool get isLoading => _isLoading.value;
  bool get isLoadingMore => _isLoadingMore.value;
  AddressListData? get addressListData => _addressListData.value;
  String get errorMessage => _errorMessage.value;
  bool get hasError => _hasError.value;
  AddressFormData? get addressFormData => _addressFormData.value;
  Address? get editingAddress => _editingAddress.value;

  // Computed properties
  List<Address> get addresses => addressListData?.addresses ?? [];
  bool get isEmpty => addressListData?.isEmpty ?? true;
  bool get isNotEmpty => addressListData?.isNotEmpty ?? false;
  bool get hasMoreData => addressListData?.hasMoreData ?? false;
  bool get isEditing => editingAddress != null;

  @override
  void onInit() {
    super.onInit();
    loadAddresses();
  }

  @override
  void onClose() {
    _disposeControllers();
    super.onClose();
  }

  void _disposeControllers() {
    titleController.dispose();
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    cityController.dispose();
    stateController.dispose();
    pinCodeController.dispose();
  }

  Future<void> loadAddresses({bool isRefresh = false}) async {
    try {
      if (isRefresh) {
        _setLoading(true);
      } else {
        _setLoading(true);
      }
      _clearError();

      final result = await getAddressesUseCase(
        const GetAddressesParams(page: 1, limit: 20),
      );

      result.fold((failure) => _handleFailure(failure), (data) {
        _addressListData.value = data;
        _setLoading(false);
      });
    } catch (e) {
      _handleError('Unexpected error occurred: $e');
    }
  }

  Future<void> loadMoreAddresses() async {
    if (_isLoadingMore.value || !hasMoreData) return;

    try {
      _setLoadingMore(true);

      final currentPage = addressListData?.currentPage ?? 1;
      final result = await getAddressesUseCase(
        GetAddressesParams(page: currentPage + 1, limit: 10),
      );

      result.fold((failure) => _setLoadingMore(false), (data) {
        final currentAddresses = addresses;
        final newAddresses = [...currentAddresses, ...data.addresses];

        _addressListData.value = data.copyWith(addresses: newAddresses);
        _setLoadingMore(false);
      });
    } catch (e) {
      _setLoadingMore(false);
    }
  }

  Future<void> addNewAddress(BuildContext context) async {
    if (!_validateForm()) {
      context.showVCartSnackBar(
        'Please fill all required fields',
        isError: true,
      );
      return;
    }

    try {
      _setLoading(true);
      final formData = AddressFormData(
        title: "home",
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
        address: addressController.text.trim(),
        city: cityController.text.trim(),
        state: stateController.text.trim(),
        pinCode: pinCodeController.text.trim(),
      );
      final result = await addAddressUseCase(
        AddAddressParams(formData: formData),
      );
      result.fold(
        (failure) {
          _setLoading(false);
        },
        (address) {
          _setLoading(false);
          _clearForm();
          loadAddresses();
          context.pop();
        },
      );
    } catch (e) {
      _setLoading(false);
    }
  }

  Future<void> updateExistingAddress(BuildContext context) async {
    if (editingAddress == null || !_validateForm()) {
      context.showVCartSnackBar(
        'Please fill all required fields',
        isError: true,
      );
      return;
    }

    try {
      _setLoading(true);

      final formData = AddressFormData(
        title: titleController.text.trim(),
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
        address: addressController.text.trim(),
        city: cityController.text.trim(),
        state: stateController.text.trim(),
        pinCode: pinCodeController.text.trim(),
      );

      final result = await updateAddressUseCase(
        UpdateAddressParams(id: editingAddress!.id!, formData: formData),
      );

      result.fold(
        (failure) {
          _setLoading(false);
          context.showVCartSnackBar(failure.message, isError: true);
        },
        (address) {
          _setLoading(false);
          context.showVCartSnackBar('Address updated successfully');
          _clearForm();
          _editingAddress.value = null;
          loadAddresses();
          context.pop();
        },
      );
    } catch (e) {
      _setLoading(false);
      context.showVCartSnackBar('Failed to update address', isError: true);
    }
  }

  Future<void> deleteExistingAddress(
    String addressId,
    BuildContext context,
  ) async {
    try {
      _setLoading(true);

      final result = await deleteAddressUseCase(
        DeleteAddressParams(id: addressId),
      );

      result.fold(
        (failure) {
          _setLoading(false);
          context.showVCartSnackBar(failure.message, isError: true);
        },
        (success) {
          _setLoading(false);
          if (success) {
            context.showVCartSnackBar('Address deleted successfully');
            loadAddresses();
          } else {
            context.showVCartSnackBar(
              'Failed to delete address',
              isError: true,
            );
          }
        },
      );
    } catch (e) {
      _setLoading(false);
      context.showVCartSnackBar('Failed to delete address', isError: true);
    }
  }

  void setEditingAddress(Address address) {
    _editingAddress.value = address;
    _populateForm(address);
  }

  void _populateForm(Address address) {
    titleController.text = address.title;
    nameController.text = address.name;
    phoneController.text = address.phone;
    addressController.text = address.address;
    cityController.text = address.city;
    stateController.text = address.state;
    pinCodeController.text = address.pinCode;
  }

  void _clearForm() {
    titleController.clear();
    nameController.clear();
    phoneController.clear();
    addressController.clear();
    cityController.clear();
    stateController.clear();
    pinCodeController.clear();
    _editingAddress.value = null;
  }

  bool _validateForm() {
    return titleController.text.trim().isNotEmpty &&
        nameController.text.trim().isNotEmpty &&
        phoneController.text.trim().isNotEmpty &&
        addressController.text.trim().isNotEmpty &&
        cityController.text.trim().isNotEmpty &&
        stateController.text.trim().isNotEmpty &&
        pinCodeController.text.trim().isNotEmpty;
  }

  void navigateToAddAddress(BuildContext context) {
    _clearForm();
    context.push(VCartRouterClass.addAddress);
  }

  void navigateToEditAddress(BuildContext context, Address address) {
    setEditingAddress(address);
    context.push('${VCartRouterClass.editAddress}/${address.id}');
  }

  // Helper methods
  void _setLoading(bool value) {
    _isLoading.value = value;
  }

  void _setLoadingMore(bool value) {
    _isLoadingMore.value = value;
  }

  void _clearError() {
    _hasError.value = false;
    _errorMessage.value = '';
  }

  void _handleFailure(Failure failure) {
    _setLoading(false);
    _handleError(failure.message);
  }

  void _handleError(String message) {
    _hasError.value = true;
    _errorMessage.value = message;
    _setLoading(false);
  }
}
