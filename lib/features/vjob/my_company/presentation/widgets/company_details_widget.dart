import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../domain/entities/company_entity.dart';

class CompanyDetailsWidget extends StatelessWidget {
  final CompanyEntity company;
  final String? placeName;
  final VoidCallback onEdit;

  const CompanyDetailsWidget({
    super.key,
    required this.company,
    this.placeName,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCompanyHeader(),
        const SizedBox(height: 20),
        _buildCompanyInfo(),
        const SizedBox(height: 20),
        if (placeName != null) _buildLocationInfo(),
        if (placeName != null) const SizedBox(height: 20),
        if (company.description != null && company.description!.isNotEmpty)
          _buildDescriptionInfo(),
      ],
    );
  }

  Widget _buildCompanyHeader() {
    return Row(
      children: [
        _buildCompanyImage(),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonTextWidget(
                text: company.name,
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppConstants.white,
              ),
              const SizedBox(height: 4),
              CommonTextWidget(
                text: company.email,
                fontSize: 16,
                color: AppConstants.white.withOpacity(0.6),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCompanyImage() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AppConstants.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppConstants.white.withOpacity(0.2),
          width: 2,
        ),
      ),
      child: company.image != null && company.image!.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                company.image!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholderImage();
                },
              ),
            )
          : _buildPlaceholderImage(),
    );
  }

  Widget _buildPlaceholderImage() {
    return Icon(
      Icons.business,
      size: 40,
      color: AppConstants.white.withOpacity(0.5),
    );
  }

  Widget _buildCompanyInfo() {
    return Row(
      children: [
        Expanded(
          child: _buildInfoContainer(
            title: 'Phone Number',
            subtitle: company.phone ?? 'N/A',
            icon: Icons.phone_outlined,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildInfoContainer(
            title: 'Website',
            subtitle: company.website ?? 'N/A',
            icon: Icons.language_outlined,
          ),
        ),
      ],
    );
  }

  Widget _buildLocationInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff161616).withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstants.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppConstants.appPrimaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.location_on_outlined,
              size: 24,
              color: AppConstants.black,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonTextWidget(
                  text: 'Location',
                  fontSize: 14,
                  color: AppConstants.white.withOpacity(0.6),
                ),
                const SizedBox(height: 4),
                CommonTextWidget(
                  text: placeName!,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppConstants.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff161616).withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstants.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CommonTextWidget(
            text: 'Company Description',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppConstants.white,
          ),
          const SizedBox(height: 12),
          CommonTextWidget(
            text: company.description!,
            fontSize: 16,
            color: AppConstants.white.withOpacity(0.8),
            align: TextAlign.left,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoContainer({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff161616).withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstants.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: AppConstants.appPrimaryColor),
          const SizedBox(height: 8),
          CommonTextWidget(
            text: title,
            fontSize: 14,
            color: AppConstants.white.withOpacity(0.6),
            align: TextAlign.center,
          ),
          const SizedBox(height: 4),
          CommonTextWidget(
            text: subtitle,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppConstants.white,
            align: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
