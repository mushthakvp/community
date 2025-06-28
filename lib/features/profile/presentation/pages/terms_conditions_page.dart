import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/common/app_bar.dart';

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: const CommonAppBar(title: 'Terms & Conditions'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection('EFFECTIVE ON: 01 JULY 2024', null),
            _buildSection(
              'RECITAL',
              'Livera Mobile Application is operated by Livera Infocomm Limited ("Livera") for the Livera Community. The LIVERA LOYALTY rewards mobile application ("LIVERA LOYALTY App") that can be available on App Store, Google Play and any other platforms and the LIVERA LOYALTY website which is the LIVERA LOYALTY rewards programme website at: www.liveraapp.com are offered to the Member / you conditional upon the Member\'s acceptance of these Terms and Conditions ("Terms") as modified from time to time. By accessing and using the LIVERA LOYALTY App and / or the LIVERA LOYALTY website, you have agreed to all Terms.',
            ),

            _buildSection(
              '1. DEFINITIONS',
              'The following binding definitions shall apply:\n\n'
                  '"Account" means the account where Points of a Member will be Earned/Redeemed accessible on the LIVERA LOYALTY App.\n\n'
                  '"Earn" or "Earning" is when a Member is rewarded with Points for making a Qualifying Transaction.\n\n'
                  '"Enrollment Date" means the date the Member successfully registered with LIVERA LOYALTY.\n\n'
                  '"Gift" means moving points from one LIVERA LOYALTY Account to another as covered in clause 9.0.\n\n'
                  '"Member" or "You" means a person who has successfully registered on LIVERA LOYALTY Account in accordance with these Terms.\n\n'
                  '"Partner Programmes" means other rewards programmes of related companies or external to LIVERA LOYALTY, with whom LIVERA LOYALTY has an agreement to enhance Earning and Redeeming opportunities for Members.\n\n'
                  '"Points" means the value of the LIVERA LOYALTY rewards programme currency which are accrued by Members of LIVERA LOYALTY in consideration of duly making a Qualifying Transaction.\n\n'
                  'The "Minimum Redemption Amount" is 100 LIVERA LOYALTY Points to be used against a purchase.\n\n'
                  '"Privacy Policy" means the terms and conditions describing how LIVERA gathers, uses, discloses, and manages its private customer\'s data.\n\n'
                  '"Qualifying Transaction" means a successful transaction within a Participating Brand or a Partner Programme that is carried out in accordance with the Terms and with applicable laws & regulations after the LIVERA LOYALTY Operational Date.\n\n'
                  '"Redeem" or "Redeeming" is when a Member uses their Points to convert to LIVERA to pay for goods or services in part or in full.\n\n'
                  '"LIVERA LOYALTY ID" means the community ID within the LIVERA LOYALTY App.\n\n'
                  '"LIVERA LOYALTY Pay" means the LIVERA mobile wallet function within the LIVERA LOYALTY App, governed by the LIVERA LOYALTY Pay Terms and Conditions which constitute an integral part of these Terms.\n\n'
                  '"Transfer" means moving points to or from a Member\'s LIVERA LOYALTY Account and a Partner Programme as covered in clause 8.0, or between Family Members.',
            ),

            _buildSection(
              '2. GENERAL',
              'LIVERA reserves the right to change, modify or amend any part of LIVERA LOYALTY at any time. This right includes, but is not limited to, the Terms, Partner Programmes, LIVERA partner affiliation, rules for Earning and Redeeming points, Minimum Redemption Amount, rules for use of rewards, benefits, procedures, Participating Brands, and specific features of promotional offers.\n\n'
                  'The Member\'s use of LIVERA LOYALTY any time or after any change or variation to the Terms or otherwise will be deemed to be an acceptance by the Member to any modification or update. The Member is solely responsible for remaining knowledgeable of the Terms.\n\n'
                  'LIVERA may change, restrict access to, suspend, or discontinue LIVERA LOYALTY or the LIVERA LOYALTY App, or any portion of LIVERA LOYALTY or the LIVERA Loyalty App, at any time without notice, refusing any liability of whatsoever nature.',
            ),

            _buildSection(
              '3. MEMBERSHIP – REGISTRATION & JOINING',
              'LIVERA LOYALTY is available to any person over the age of Eighteen (18) years old. However, if the user is under the age of 18, their membership and all dealings within should be made under the supervision of a parent or legal guardian who agrees to be bound and bound the underage user by these Terms.\n\n'
                  'LIVERA reserves the right to accept or reject any application for membership in LIVERA LOYALTY at its absolute discretion.\n\n'
                  'LIVERA LOYALTY is available by downloading the LIVERA LOYALTY App and completing the required registration details.\n\n'
                  'Members must complete the registration process by providing current, complete and accurate information as prompted by the applicable registration form. As a minimum, the member will need to provide their full name, email address and mobile number.\n\n'
                  'Membership is not transferable, and any benefits / Points cannot be assigned or transferred to any other Member, unless otherwise in accordance with these Terms.',
            ),

            _buildSection(
              '4. EARNING POINTS',
              'A Member may Earn Points on Qualifying Transactions on or after their Enrollment Date.\n\n'
                  'To Earn Points, the Member must have downloaded the LIVERA LOYALTY App and fill in the required registration details in order to activate their Account.\n\n'
                  'For Earning in-store at Participating Brands the Member must make available the LIVERA LOYALTY App on a mobile device and be logged in to their Account.\n\n'
                  'The number of Points Earned by the Member shall be based on the total Qualifying Transaction amount.\n\n'
                  'Points may take up to 1 week to be credited to a Member\'s Account. Points Earned by a Member may only be Redeemed by that Member in accordance with these Terms once they have been credited to the relevant Account.',
            ),

            _buildSection(
              '5. REDEEMING POINTS',
              'Members can redeem Points earned in LIVERA and use the same to pay in Participating Brands by purchasing good and services or programs by LIVERA.\n\n'
                  'The minimum redemption amount is 100 points (current equivalent value of 1 INR).\n\n'
                  'For redemption in-store at Participating Brands the Member must produce the LIVERA LOYALTY App on a mobile device and be logged in to their Account.\n\n'
                  'The Redeemed Points will automatically be deducted from the Member\'s Account at the time of redemption.\n\n'
                  'Points have a validity of 12 months from the date of Earning, after which, they will expire.\n\n'
                  'If there is no Account Earning or Redeeming activity for 12 months then all points will expire.',
            ),

            _buildSection(
              '6. CLOSURE & TERMINATION',
              'LIVERA may in its absolute discretion suspend, close or terminate a membership or a Member\'s accumulated Points at any time with or without cause or justification to the Member as LIVERA deems fit at its sole discretion.\n\n'
                  'When Member does not transact for 12 months their Account is set to "Lapsed" status.\n\n'
                  'Any time between 12 and 24 months, if a member transacts, their Account will be moved from Lapsed back to the "Active" and login credentials will remain valid, but Points will expire.\n\n'
                  'When the Member does not transact for 24 months, he/she would be moved to "Archived" stage at which point the Member would need to register again, as previous login credentials would no longer be valid.\n\n'
                  'The member may cancel his/her membership at any time by calling mailing to connect@liveraapp.com.\n\n'
                  'LIVERA LOYALTY membership will terminate immediately on notification of death or bankruptcy of a Member.',
            ),

            _buildSection(
              '7. FAIR USE',
              'LIVERA LOYALTY is intended to reward and benefit individual customers who participate with the Participating Brands.\n\n'
                  'No collective group use is permitted of LIVERA LOYALTY, expect where specifically included in the Terms.\n\n'
                  'No corporate use is permitted i.e. collection or use of Points or benefits for business purposes is not permitted.\n\n'
                  'Any misuse of LIVERA LOYALTY from its original intention and any action or omission against the fair use terms as decided by LIVERA at its discretion may lead to permanent deletion of the related LIVERA LOYALTY Account and forfeiture of any Points outstanding.\n\n'
                  'LIVERA reserves the right to legally pursue individuals, companies or other organizations for legal recourse if LIVERA LOYALTY is mis-used.\n\n'
                  'LIVERA reserves the right to suspend, delete or otherwise modify any Member\'s Account, or the entire LIVERA LOYALTY programme at any time at its sole discretion, with or without prior notification.',
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String? content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppConstants.appPrimaryColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (content != null) ...[
            const SizedBox(height: 12),
            Text(
              content,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
                height: 1.6,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
