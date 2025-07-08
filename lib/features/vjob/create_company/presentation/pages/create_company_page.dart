import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:livera/core/utils/result.dart';
import 'package:livera/core/widgets/buttons/primary_button.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/utils/extensions.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../../../core/widgets/loading/loading_widget.dart';
import '../../domain/entities/company_entity.dart';
import '../providers/create_company_provider.dart';
import '../widgets/company_form_widget.dart';

class CreateCompanyPage extends StatefulWidget {
  final CompanyEntity? company; // For update mode

  const CreateCompanyPage({super.key, this.company});

  @override
  State<CreateCompanyPage> createState() => _CreateCompanyPageState();
}

class _CreateCompanyPageState extends State<CreateCompanyPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<CreateCompanyProvider>();
      if (widget.company != null) {
        provider.setUpdateMode(widget.company!);
      } else {
        provider.clearForm();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: _buildAppBar(),
      body: Consumer<CreateCompanyProvider>(
        builder: (context, provider, _) {
          return Stack(
            children: [
              _buildBody(provider),
              if (provider.isLoading) _buildLoadingOverlay(),
            ],
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppConstants.black,
      elevation: 0,
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: const Icon(Icons.arrow_back, color: AppConstants.white),
      ),
      title: Consumer<CreateCompanyProvider>(
        builder: (context, provider, _) {
          return CommonTextWidget(
            text: provider.isFromUpdate ? 'Update Company' : 'Create Company',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppConstants.white,
          );
        },
      ),
      centerTitle: false,
    );
  }

  Widget _buildBody(CreateCompanyProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(provider),
          const SizedBox(height: 32),
          _buildForm(),
          const SizedBox(height: 32),
          _buildSubmitButton(provider),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildHeader(CreateCompanyProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonTextWidget(
          text: provider.isFromUpdate
              ? 'Update Company Information'
              : 'Company Registration',
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: AppConstants.white,
        ),
        const SizedBox(height: 12),
        CommonTextWidget(
          text: provider.isFromUpdate
              ? 'Update your company details to keep your profile current.'
              : 'Streamline your recruitment process with efficient company registration.',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppConstants.white.withOpacity(0.7),
          maxLines: 2,
        ),
        if (provider.errorMessage.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildErrorMessage(provider.errorMessage),
        ],
      ],
    );
  }

  Widget _buildErrorMessage(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: CommonTextWidget(
              text: message,
              fontSize: 14,
              color: Colors.red,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return CompanyFormWidget(onLocationTap: () => _handleLocationTap());
  }

  Widget _buildSubmitButton(CreateCompanyProvider provider) {
    return PrimaryButton(
      width: double.infinity,
      onPressed: provider.isLoading ? null : () => _handleSubmit(provider),
      height: 56,
      borderRadius: 12,
      backgroundColor: AppConstants.appPrimaryColor,
      text: provider.isFromUpdate ? 'Update Company' : 'Register Company',
      isLoading: provider.isLoading,
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: const Center(
        child: LoadingWidget(
          message: 'Processing...',
          color: AppConstants.appPrimaryColor,
        ),
      ),
    );
  }

  void _handleLocationTap() {
    final provider = context.read<CreateCompanyProvider>();
    provider.setLocation(
      lat: 11.1203,
      lng: 76.1199,
      placeName: 'Kannur, Kerala, India',
    );
  }

  Future<void> _handleSubmit(CreateCompanyProvider provider) async {
    // Hide keyboard
    FocusScope.of(context).unfocus();

    final result = await provider.submitForm();

    if (!mounted) return;

    result.handle(
      onSuccess: (company) {
        context.showSuccessSnackBar(
          provider.isFromUpdate
              ? 'Company updated successfully!'
              : 'Company registered successfully!',
        );

        // Navigate back or to success page
        if (provider.isFromUpdate) {
          context.pop(company);
        } else {
          // Navigate to success page or dashboard
          context.pushReplacement('/vjob/company/success');
        }
      },
      onError: (error) {
        context.showErrorSnackBar(error);
      },
    );
  }
}
