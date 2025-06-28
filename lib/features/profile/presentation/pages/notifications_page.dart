import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/common/app_bar.dart';
import '../widgets/ios_settings_item.dart';
import '../widgets/ios_settings_section.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  bool _promotionalOffers = true;
  bool _loyaltyUpdates = true;
  bool _securityAlerts = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: const CommonAppBar(title: 'Notifications'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            IOSSettingsSection(
              title: 'Notification Methods',
              items: [
                IOSSettingsItem(
                  icon: Icons.notifications_outlined,
                  title: 'Push Notifications',
                  subtitle: 'Receive notifications on your device',
                  trailing: Switch(
                    value: _pushNotifications,
                    onChanged: (value) =>
                        setState(() => _pushNotifications = value),
                    activeColor: AppConstants.appPrimaryColor,
                  ),
                  onTap: () =>
                      setState(() => _pushNotifications = !_pushNotifications),
                ),
                IOSSettingsItem(
                  icon: Icons.email_outlined,
                  title: 'Email Notifications',
                  subtitle: 'Receive notifications via email',
                  trailing: Switch(
                    value: _emailNotifications,
                    onChanged: (value) =>
                        setState(() => _emailNotifications = value),
                    activeColor: AppConstants.appPrimaryColor,
                  ),
                  onTap: () => setState(
                    () => _emailNotifications = !_emailNotifications,
                  ),
                ),
                IOSSettingsItem(
                  icon: Icons.sms_outlined,
                  title: 'SMS Notifications',
                  subtitle: 'Receive notifications via text message',
                  trailing: Switch(
                    value: _smsNotifications,
                    onChanged: (value) =>
                        setState(() => _smsNotifications = value),
                    activeColor: AppConstants.appPrimaryColor,
                  ),
                  onTap: () =>
                      setState(() => _smsNotifications = !_smsNotifications),
                ),
              ],
            ),
            const SizedBox(height: 20),
            IOSSettingsSection(
              title: 'Notification Types',
              items: [
                IOSSettingsItem(
                  icon: Icons.local_offer_outlined,
                  title: 'Promotional Offers',
                  subtitle: 'Deals, discounts, and special offers',
                  trailing: Switch(
                    value: _promotionalOffers,
                    onChanged: (value) =>
                        setState(() => _promotionalOffers = value),
                    activeColor: AppConstants.appPrimaryColor,
                  ),
                  onTap: () =>
                      setState(() => _promotionalOffers = !_promotionalOffers),
                ),
                IOSSettingsItem(
                  icon: Icons.stars_outlined,
                  title: 'Loyalty Updates',
                  subtitle: 'Points earned, rewards available',
                  trailing: Switch(
                    value: _loyaltyUpdates,
                    onChanged: (value) =>
                        setState(() => _loyaltyUpdates = value),
                    activeColor: AppConstants.appPrimaryColor,
                  ),
                  onTap: () =>
                      setState(() => _loyaltyUpdates = !_loyaltyUpdates),
                ),
                IOSSettingsItem(
                  icon: Icons.security_outlined,
                  title: 'Security Alerts',
                  subtitle: 'Account security and login alerts',
                  trailing: Switch(
                    value: _securityAlerts,
                    onChanged: (value) =>
                        setState(() => _securityAlerts = value),
                    activeColor: AppConstants.appPrimaryColor,
                  ),
                  onTap: () =>
                      setState(() => _securityAlerts = !_securityAlerts),
                ),
              ],
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
