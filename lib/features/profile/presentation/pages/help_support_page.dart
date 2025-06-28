import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/common/app_bar.dart';
import '../widgets/ios_settings_item.dart';
import '../widgets/ios_settings_section.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: const CommonAppBar(title: 'Help & Support'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            IOSSettingsSection(
              title: 'Get Help',
              items: [
                IOSSettingsItem(
                  icon: Icons.help_outline,
                  title: 'FAQ',
                  subtitle: 'Frequently asked questions',
                  onTap: () => _showFAQBottomSheet(context),
                ),
                IOSSettingsItem(
                  icon: Icons.email_outlined,
                  title: 'Email Support',
                  subtitle: 'connect@liveraapp.com',
                  onTap: () => _launchEmail('connect@liveraapp.com'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            IOSSettingsSection(
              title: 'Resources',
              items: [
                IOSSettingsItem(
                  icon: Icons.article_outlined,
                  title: 'User Guide',
                  subtitle: 'Detailed app documentation',
                  onTap: () =>
                      _launchURL('https://www.liveraapp.com/vv-user-guide'),
                ),
              ],
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _launchEmail(String email) async {
    final Uri emailUri = Uri(scheme: 'mailto', path: email);
    if (!await launchUrl(emailUri)) {
      throw Exception('Could not launch email');
    }
  }

  void _showFAQBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Frequently Asked Questions',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: const [
                  FAQItem(
                    question:
                        'What is Livera & what type of services are covered by Livera Community App?',
                    answer:
                        'The Livera Community App is a dynamic platform designed to enhance community engagement and provide a variety of interactive services. Services include loyalty programs, daily Spin a Wheel, cooking contests, social media engagement, video viewing, e-commerce purchases, coupon access, and exclusive chat modules for members.',
                  ),
                  FAQItem(
                    question:
                        'How can I earn Loyalty Points on the Livera Community App?',
                    answer:
                        'You can earn Loyalty Points by participating in activities such as daily Spin a Wheel, cooking contests, subscribing to social media channels, viewing videos, and making purchases through the e-commerce platform.',
                  ),
                  FAQItem(
                    question: 'How do I participate in the Daily Spin a Wheel?',
                    answer:
                        'Log in to the Livera Community App and navigate to the "Spin a Wheel" section. You can spin the wheel once daily to earn Loyalty Points. Additional spins can be redeemed using Loyalty Points.',
                  ),
                  FAQItem(
                    question:
                        'What are the Cooking Contests and how can I join?',
                    answer:
                        'Cooking Contests allow you to showcase your culinary skills. To join, go to the "V_Cook" section in the app, select an ongoing contest, and follow the instructions to participate.',
                  ),
                  FAQItem(
                    question:
                        'How do I earn points by subscribing to Social Media channels?',
                    answer:
                        'Go to the "Social Media" section in the app, find the listed channels, and subscribe. Points will be credited to your account once the subscription is confirmed.',
                  ),
                  FAQItem(
                    question: 'How can I earn points by viewing videos?',
                    answer:
                        'Navigate to the "Promos" section in the app and watch videos posted. Points will be added to your account based on the duration and number of videos viewed.',
                  ),
                  FAQItem(
                    question:
                        'How do I earn points through e-commerce purchases?',
                    answer:
                        'Make purchases through the Livera Community App\'s e-commerce platform, V_Cart. Points will be awarded based on the amount spent and credited to your account after the purchase is completed.',
                  ),
                  FAQItem(
                    question: 'How can I redeem my Loyalty Points?',
                    answer:
                        'You can redeem your Loyalty Points while making purchases on the e-commerce platform or for additional Spin a Wheel challenges. During checkout, select the option to use your points, and the equivalent amount will be deducted from your total.',
                  ),
                  FAQItem(
                    question:
                        'Can I use my Loyalty Points for additional Spin a Wheel challenges?',
                    answer:
                        'Yes, you can use your Loyalty Points to gain additional spins on the Spin a Wheel challenge. Go to the "Spin a Wheel" section and select the option to use points for extra spins.',
                  ),
                  FAQItem(
                    question: 'Where can I check my Loyalty Points balance?',
                    answer:
                        'You can check your Loyalty Points balance in the "Profile" section of the app. Your total points and transaction history will be displayed there.',
                  ),
                  FAQItem(
                    question:
                        'Are there any limits on earning or redeeming Loyalty Points?',
                    answer:
                        'There are no specific limits on earning and redeeming points. Please refer to the "Terms and Conditions" section in the app for more detailed information.',
                  ),
                  FAQItem(
                    question: 'What about Data protection & Privacy?',
                    answer:
                        'Livera is committed to protecting your personal information. We use robust security measures to safeguard your data from misuse or unauthorized access. Your data is processed for payments, communications, and improving services, and is not sold to third parties. You have the right to access, correct, or delete your personal data.',
                  ),
                  FAQItem(
                    question: 'Do Loyalty Points Expire?',
                    answer:
                        'Yes, Loyalty Points have an expiration policy. Points typically expire after a certain period of inactivity. To keep your points active, participate in activities like the Spin a Wheel challenge, cooking contests, social media engagement, video viewing, or make purchases through the e-commerce platform.',
                  ),
                  SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FAQItem extends StatefulWidget {
  final String question;
  final String answer;

  const FAQItem({super.key, required this.question, required this.answer});

  @override
  State<FAQItem> createState() => _FAQItemState();
}

class _FAQItemState extends State<FAQItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF262626),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            widget.question,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          iconColor: Colors.white,
          collapsedIconColor: Colors.white,
          childrenPadding: EdgeInsets.zero,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                widget.answer,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
