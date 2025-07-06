import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../providers/create_job_provider.dart';

class CompanySelector extends StatelessWidget {
  const CompanySelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateJobProvider>(
      builder: (context, provider, child) {
        if (provider.companies.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.withOpacity(0.5)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.orange, size: 20),
                const SizedBox(width: 12),
                const Expanded(
                  child: CommonTextWidget(
                    text: 'Please register your company first to create job posts',
                    color: Colors.orange,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CommonTextWidget(
              text: 'Select Company',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppConstants.white,
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 80,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: provider.companies.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final company = provider.companies[index];
                  final isSelected = company.id == provider.selectedCompanyId;

                  return GestureDetector(
                    onTap: () => provider.setCompanyId(company.id),
                    child: Container(
                      width: 80,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppConstants.appPrimaryColor
                              : AppConstants.white.withOpacity(0.2),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: company.image,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                placeholder: (context, url) => Container(
                                  color: const Color(0xFF2A2A2A),
                                  child: const Icon(
                                    Icons.business,
                                    color: AppConstants.white,
                                    size: 20,
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: const Color(0xFF2A2A2A),
                                  child: const Icon(
                                    Icons.business,
                                    color: AppConstants.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          CommonTextWidget(
                            text: company.name,
                            fontSize: 10,
                            fontWeight: FontWeight.w300,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

}