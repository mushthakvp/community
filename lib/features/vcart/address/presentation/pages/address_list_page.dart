import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:livera/features/vcart/core/router/vcart_router_extensions.dart';

import '../../../core/constants/vcart_colors.dart';
import '../../../core/utils/vcart_extensions.dart';
import '../../../shared/presentation/widgets/error_widget.dart';
import '../../../shared/presentation/widgets/maintenance_widget.dart';
import '../controllers/address_controller.dart';
import '../widgets/address_list_item.dart';

class VCartAddressListPage extends StatefulWidget {
  const VCartAddressListPage({super.key});

  @override
  State<VCartAddressListPage> createState() => _VCartAddressListPageState();
}

class _VCartAddressListPageState extends State<VCartAddressListPage> {
  VCartAddressController? controller;
  bool isInitializing = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeController();
    _setupScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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

  void _setupScrollController() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        controller?.loadMoreAddresses();
      }
    });
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
      title: const Text(
        'Saved Addresses',
        style: TextStyle(
          color: VCartColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        TextButton.icon(
          onPressed: () => context.goToVCartAddAddress(),
          icon: const Icon(Icons.add, color: VCartColors.primary, size: 20),
          label: const Text(
            'Add New',
            style: TextStyle(
              color: VCartColors.primary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
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
        return Obx(() => _buildAddressContent(addressController));
      },
    );
  }

  Widget _buildAddressContent(VCartAddressController addressController) {
    if (addressController.hasError) {
      return VCartErrorWidget(
        message: addressController.errorMessage,
        onRetry: () => addressController.loadAddresses(isRefresh: true),
      );
    }

    if (addressController.isEmpty && !addressController.isLoading) {
      return const VCartMaintenanceWidget(
        imageUrl: 'https://via.placeholder.com/200x200/E5E7EB/',
        title: 'No Saved Addresses Yet',
        subtitle:
            'Add a new address to make checkout faster and more convenient.',
      );
    }

    return RefreshIndicator(
      onRefresh: () => addressController.loadAddresses(isRefresh: true),
      color: VCartColors.primary,
      child: ListView.separated(
        controller: _scrollController,
        padding: context.defaultPadding,
        itemCount:
            addressController.addresses.length +
            (addressController.hasMoreData ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == addressController.addresses.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(color: VCartColors.primary),
              ),
            );
          }

          final address = addressController.addresses[index];
          return AddressListItem(
            address: address,
            onEdit: () =>
                addressController.navigateToEditAddress(context, address),
            onDelete: () =>
                _showDeleteConfirmation(addressController, address.id!),
            isLoading: addressController.isLoading,
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 12),
      ),
    );
  }

  void _showDeleteConfirmation(
    VCartAddressController controller,
    String addressId,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: VCartColors.surface,
          title: const Text(
            'Delete Address',
            style: TextStyle(color: VCartColors.textPrimary),
          ),
          content: const Text(
            'Are you sure you want to delete this address?',
            style: TextStyle(color: VCartColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: VCartColors.textSecondary),
              ),
            ),
            TextButton(
              onPressed: () {
                context.pop();
                controller.deleteExistingAddress(addressId, this.context);
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: VCartColors.error),
              ),
            ),
          ],
        );
      },
    );
  }
}
