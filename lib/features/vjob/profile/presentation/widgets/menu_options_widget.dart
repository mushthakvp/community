import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/route_constants.dart';
import '../../../../../core/utils/extensions.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../my_company/presentation/providers/my_company_provider.dart';

class MenuOptionsWidget extends StatelessWidget {
  const MenuOptionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildMenuTile(
          title: 'My Jobs',
          icon: Icons.work_outline,
          onTap: () {
            context.push(RouteConstants.vjobMyJobs);
          },
        ),
        const SizedBox(height: 20),
        _buildMenuTile(
          title: 'My Company',
          icon: Icons.business_outlined,
          onTap: () {
            context.push('/vjob/my-company');
          },
        ),
        const SizedBox(height: 20),
        _buildMenuTile(
          title: 'Create Job Post',
          icon: Icons.add_circle_outline,
          onTap: () => _handleCreateJobPost(context),
        ),
        const SizedBox(height: 20),
        _buildMenuTile(
          title: 'My Posts',
          icon: Icons.article_outlined,
          onTap: () {
            context.push('/vjob/my-posts');
          },
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildMenuTile({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xff161616),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, color: AppConstants.white, size: 20),
      ),
      title: CommonTextWidget(
        text: title,
        color: AppConstants.white,
        fontSize: 18,
        fontWeight: FontWeight.w400,
      ),
      trailing: const CircleAvatar(
        radius: 20,
        backgroundColor: Color(0xff161616),
        child: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 12,
          color: AppConstants.white,
        ),
      ),
    );
  }

  void _handleCreateJobPost(BuildContext context) async {
    final companyProvider = context.read<MyCompanyProvider>();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            AppConstants.appPrimaryColor,
          ),
        ),
      ),
    );
    try {
      await companyProvider.getMyCompany();
      if (context.mounted) {
        Navigator.of(context).pop();
      }
      if (companyProvider.company != null) {
        context.push(RouteConstants.vjobCreateJob);
      } else {
        if (context.mounted) {
          _showNoCompanyDialog(context);
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop();
        context.showErrorSnackBar('Failed to check company status');
      }
    }
  }

  void _showNoCompanyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const CommonTextWidget(
          text: 'Company Required',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppConstants.white,
        ),
        content: const CommonTextWidget(
          text:
              'You need to register a company first before creating job posts. Would you like to register your company now?',
          fontSize: 16,
          color: AppConstants.white,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const CommonTextWidget(
              text: 'Cancel',
              fontSize: 16,
              color: AppConstants.white,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context.push(RouteConstants.vjobCreateCompany);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.appPrimaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const CommonTextWidget(
              text: 'Register Company',
              fontSize: 16,
              color: AppConstants.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
