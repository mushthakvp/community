import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/app_bar.dart';
import '../../../../../core/widgets/common/image_widget.dart';
import '../../../../../core/widgets/common/spacer_widget.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../../../core/widgets/loading/loading_widget.dart';
import '../../domain/entities/seller_profile.dart';
import '../providers/seller_details_provider.dart';

class SellerDetailsPage extends StatefulWidget {
  final String sellerId;

  const SellerDetailsPage({super.key, required this.sellerId});

  @override
  State<SellerDetailsPage> createState() => _SellerDetailsPageState();
}

class _SellerDetailsPageState extends State<SellerDetailsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SellerDetailsProvider>().getSellerProfile(widget.sellerId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: const CommonAppBar(title: 'Seller Details', showBackButton: true),
      body: Consumer<SellerDetailsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: LoadingWidget(message: 'Loading seller details...'),
            );
          }

          final result = provider.sellerProfileResult;
          if (result == null) {
            return const Center(
              child: CommonTextWidget(text: 'No data available', fontSize: 16),
            );
          }

          if (result.isError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: AppConstants.error,
                    size: 64,
                  ),
                  AppSpacing.verticalMD,
                  CommonTextWidget(
                    text: result.errorMessage ?? 'Something went wrong',
                    fontSize: 16,
                    align: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          final profile = provider.sellerProfile!;
          return _buildSellerProfile(profile);
        },
      ),
    );
  }

  Widget _buildSellerProfile(SellerProfile profile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileHeader(profile),
          AppSpacing.verticalXL,
          _buildAdsSection(profile),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(SellerProfile profile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppConstants.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          CommonImageWidget(
            imageUrl: profile.profileImage,
            width: 100,
            height: 100,
            borderRadius: BorderRadius.circular(50),
          ),
          AppSpacing.verticalMD,
          CommonTextWidget(
            text: profile.name,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
          AppSpacing.verticalSM,
          CommonTextWidget(
            text: 'Joined on ${_formatDate(profile.joinedDate)}',
            fontSize: 14,
            color: AppConstants.onSurfaceVariant,
          ),
        ],
      ),
    );
  }

  Widget _buildAdsSection(SellerProfile profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppConstants.appPrimaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const CommonTextWidget(
            text: 'Ads',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppConstants.black,
          ),
        ),
        AppSpacing.verticalMD,
        CommonTextWidget(
          text: '${profile.advertisements.length} Items live',
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: AppConstants.appPrimaryColor,
        ),
        AppSpacing.verticalMD,
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: profile.advertisements.length,
          separatorBuilder: (context, index) => AppSpacing.verticalMD,
          itemBuilder: (context, index) {
            final ad = profile.advertisements[index];
            return _buildAdItem(ad);
          },
        ),
      ],
    );
  }

  Widget _buildAdItem(Advertisement ad) {
    return Container(
      decoration: BoxDecoration(
        color: AppConstants.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CommonImageWidget(
            imageUrl: ad.images.isNotEmpty ? ad.images.first : null,
            width: 120,
            height: 100,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonTextWidget(
                    text: 'INR ${ad.price.toStringAsFixed(2)}',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppConstants.appPrimaryColor,
                  ),
                  AppSpacing.verticalSM,
                  CommonTextWidget(
                    text: ad.title,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    maxLines: 2,
                  ),
                  AppSpacing.verticalSM,
                  if (ad.year != null) ...[
                    CommonTextWidget(
                      text: 'Age: ${ad.year}',
                      fontSize: 14,
                      color: AppConstants.onSurfaceVariant,
                    ),
                    AppSpacing.verticalXS,
                  ],
                  if (ad.brand != null) ...[
                    CommonTextWidget(
                      text: 'Brand: ${ad.brand}',
                      fontSize: 12,
                      color: AppConstants.onSurfaceVariant,
                    ),
                    AppSpacing.verticalXS,
                  ],
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: AppConstants.appPrimaryColor,
                        size: 14,
                      ),
                      AppSpacing.horizontalXS,
                      Expanded(
                        child: CommonTextWidget(
                          text: ad.location,
                          fontSize: 12,
                          color: AppConstants.onSurfaceVariant,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMMM dd, yyyy').format(date);
  }
}
