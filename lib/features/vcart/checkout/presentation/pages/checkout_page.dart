import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../cart/domain/entities/cart_data.dart';
import '../../../core/constants/vcart_colors.dart';
import '../../../core/utils/vcart_extensions.dart';
import '../../../core/widgets/vcart_button.dart';
import '../../../shared/presentation/widgets/error_widget.dart';
import '../../../shared/presentation/widgets/maintenance_widget.dart';
import '../controllers/checkout_controller.dart';
import '../widgets/address_section_widget.dart';
import '../widgets/order_summary_widget.dart';
import '../widgets/payment_method_selector.dart';

class VCartCheckoutPage extends StatefulWidget {
  final CartData cartData;

  const VCartCheckoutPage({super.key, required this.cartData});

  @override
  State<VCartCheckoutPage> createState() => _VCartCheckoutPageState();
}

class _VCartCheckoutPageState extends State<VCartCheckoutPage> {
  VCartCheckoutController? controller;
  bool isInitializing = true;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  Future<void> _initializeController() async {
    try {
      // Get controller from DI
      controller = Get.find<VCartCheckoutController>();
      await controller!.loadCheckoutData(widget.cartData);

      if (mounted) {
        setState(() {
          isInitializing = false;
        });
      }
    } catch (e) {
      debugPrint('Failed to initialize checkout controller: $e');
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
            border: Border.all(color: VCartColors.border, width: 0.2),
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
        "Checkout",
        style: TextStyle(
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

    return GetBuilder<VCartCheckoutController>(
      init: controller,
      builder: (checkoutController) {
        return Obx(() => _buildCheckoutContent(checkoutController));
      },
    );
  }

  Widget _buildCheckoutContent(VCartCheckoutController checkoutController) {
    if (checkoutController.hasError) {
      return VCartErrorWidget(
        message: checkoutController.errorMessage,
        onRetry: () => checkoutController.loadCheckoutData(widget.cartData),
      );
    }

    if (!checkoutController.hasAddresses && !checkoutController.isLoading) {
      return VCartMaintenanceWidget(
        imageUrl:
            'https://via.placeholder.com/200x200/E5E7EB/9CA3AF?text=No+Address',
        title: 'No Addresses Found',
        subtitle: 'Add a delivery address to continue with your order',
      );
    }

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: context.defaultPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AddressSectionWidget(
                  addresses: checkoutController.addresses,
                  selectedAddress: checkoutController.selectedAddress,
                  onAddressSelected: checkoutController.selectAddress,
                  onAddNewAddress: () =>
                      checkoutController.navigateToAddAddress(context),
                  isLoading: checkoutController.isLoading,
                ),
                const SizedBox(height: 24),
                OrderSummaryWidget(cartData: widget.cartData),
                const SizedBox(height: 24),
                PaymentMethodSelector(
                  paymentMethods:
                      checkoutController.checkoutData?.paymentMethods ?? [],
                  selectedPaymentMethod:
                      checkoutController.selectedPaymentMethod,
                  onPaymentMethodSelected:
                      checkoutController.selectPaymentMethod,
                ),
                const SizedBox(height: 100), // Space for bottom button
              ],
            ),
          ),
        ),
        _buildBottomSection(checkoutController),
      ],
    );
  }

  Widget _buildBottomSection(VCartCheckoutController checkoutController) {
    return Container(
      padding: context.defaultPadding,
      decoration: const BoxDecoration(
        color: VCartColors.background,
        border: Border(top: BorderSide(color: VCartColors.border, width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: VCartButton(
          text: "Proceed to Payment",
          onPressed: checkoutController.canProceedToPayment
              ? () => checkoutController.processPayment(context)
              : null,
          isLoading: checkoutController.isLoading,
          isExpanded: true,
          height: 55,
        ),
      ),
    );
  }
}
