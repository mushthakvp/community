import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:livera/core/constants/app_constants.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class CustomTabService {
  static Future<void> openUrl(String url) async {
    if (url.isEmpty) {
      throw Exception('URL cannot be empty');
    }
    try {
      final String formattedUrl = _ensureUrlScheme(url);
      await launchUrl(
        Uri.parse(formattedUrl),
        customTabsOptions: CustomTabsOptions(showTitle: true),
        safariVCOptions: SafariViewControllerOptions(
          barCollapsingEnabled: true,
          preferredBarTintColor: AppConstants.black,
          preferredControlTintColor: Colors.white,
          dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        ),
      );
    } catch (e) {
      await _openInExternalBrowser(url);
    }
  }

  static Future<void> _openInExternalBrowser(String url) async {
    try {
      final String formattedUrl = _ensureUrlScheme(url);
      final Uri uri = Uri.parse(formattedUrl);
      if (!await url_launcher.launchUrl(
        uri,
        mode: url_launcher.LaunchMode.externalApplication,
      )) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      debugPrint('Error opening URL in external browser: $e');
      throw Exception('Could not launch $url');
    }
  }

  static Future<void> openUrlInExternalBrowser(String url) async {
    await _openInExternalBrowser(url);
  }

  static Future<void> openEmail(
    String email, {
    String? subject,
    String? body,
    List<String>? cc,
    List<String>? bcc,
  }) async {
    try {
      if (email.isEmpty) {
        throw Exception('Email address cannot be empty');
      }
      final Uri emailUri = Uri(
        scheme: 'mailto',
        path: email,
        query: _encodeEmailQuery(
          subject: subject,
          body: body,
          cc: cc,
          bcc: bcc,
        ),
      );
      if (!await url_launcher.launchUrl(emailUri)) {
        throw Exception('Could not launch email client');
      }
    } catch (e) {
      debugPrint('Error opening email: $e');
      throw Exception('Could not launch email client');
    }
  }

  static Future<void> openPhone(String phoneNumber) async {
    try {
      if (phoneNumber.isEmpty) {
        throw Exception('Phone number cannot be empty');
      }
      final String cleanedNumber = phoneNumber.replaceAll(
        RegExp(r'[^\d+]'),
        '',
      );
      final Uri phoneUri = Uri(scheme: 'tel', path: cleanedNumber);

      if (!await url_launcher.launchUrl(phoneUri)) {
        throw Exception('Could not launch phone dialer');
      }
    } catch (e) {
      debugPrint('Error opening phone: $e');
      throw Exception('Could not launch phone dialer');
    }
  }

  static Future<void> openSMS(String phoneNumber, {String? message}) async {
    try {
      if (phoneNumber.isEmpty) {
        throw Exception('Phone number cannot be empty');
      }

      final String cleanedNumber = phoneNumber.replaceAll(
        RegExp(r'[^\d+]'),
        '',
      );
      final Uri smsUri = Uri(
        scheme: 'sms',
        path: cleanedNumber,
        queryParameters: message != null ? {'body': message} : null,
      );

      if (!await url_launcher.launchUrl(smsUri)) {
        throw Exception('Could not launch SMS app');
      }
    } catch (e) {
      debugPrint('Error opening SMS: $e');
      throw Exception('Could not launch SMS app');
    }
  }

  static Future<void> openMaps(
    String address, {
    double? latitude,
    double? longitude,
  }) async {
    try {
      String mapsUrl;

      if (latitude != null && longitude != null) {
        // Use coordinates if provided
        mapsUrl =
            'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
      } else if (address.isNotEmpty) {
        // Use address
        mapsUrl =
            'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}';
      } else {
        throw Exception('Either address or coordinates must be provided');
      }

      await openUrl(mapsUrl);
    } catch (e) {
      debugPrint('Error opening maps: $e');
      throw Exception('Could not launch maps');
    }
  }

  /// Opens app store based on platform
  static Future<void> openAppStore({
    required String androidPackageId,
    required String iosAppId,
  }) async {
    try {
      String storeUrl;

      if (Platform.isAndroid) {
        storeUrl =
            'https://play.google.com/store/apps/details?id=$androidPackageId';
      } else if (Platform.isIOS) {
        storeUrl = 'https://apps.apple.com/app/id$iosAppId';
      } else {
        throw Exception('Unsupported platform');
      }
      await _openInExternalBrowser(storeUrl);
    } catch (e) {
      debugPrint('Error opening app store: $e');
      throw Exception('Could not launch app store');
    }
  }

  static Future<void> openWhatsApp(
    String phoneNumber, {
    String? message,
  }) async {
    try {
      if (phoneNumber.isEmpty) {
        throw Exception('Phone number cannot be empty');
      }

      final String cleanedNumber = phoneNumber.replaceAll(
        RegExp(r'[^\d+]'),
        '',
      );
      String whatsappUrl = 'https://wa.me/$cleanedNumber';

      if (message != null && message.isNotEmpty) {
        whatsappUrl += '?text=${Uri.encodeComponent(message)}';
      }

      await openUrl(whatsappUrl);
    } catch (e) {
      debugPrint('Error opening WhatsApp: $e');
      throw Exception('Could not launch WhatsApp');
    }
  }

  static Future<void> openSocialMedia({
    required SocialPlatform platform,
    required String username,
  }) async {
    try {
      String url;

      switch (platform) {
        case SocialPlatform.facebook:
          url = 'https://www.facebook.com/$username';
          break;
        case SocialPlatform.instagram:
          url = 'https://www.instagram.com/$username';
          break;
        case SocialPlatform.twitter:
          url = 'https://www.twitter.com/$username';
          break;
        case SocialPlatform.linkedin:
          url = 'https://www.linkedin.com/in/$username';
          break;
        case SocialPlatform.youtube:
          url = 'https://www.youtube.com/@$username';
          break;
        case SocialPlatform.tiktok:
          url = 'https://www.tiktok.com/@$username';
          break;
      }

      await openUrl(url);
    } catch (e) {
      debugPrint('Error opening social media: $e');
      throw Exception('Could not open social media platform');
    }
  }

  static Future<bool> canOpenUrl(String url) async {
    try {
      final String formattedUrl = _ensureUrlScheme(url);
      final Uri uri = Uri.parse(formattedUrl);
      return await url_launcher.canLaunchUrl(uri);
    } catch (e) {
      debugPrint('Error checking if URL can be launched: $e');
      return false;
    }
  }

  static String _ensureUrlScheme(String url) {
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    }
    return 'https://$url';
  }

  static String? _encodeEmailQuery({
    String? subject,
    String? body,
    List<String>? cc,
    List<String>? bcc,
  }) {
    final Map<String, String> params = {};

    if (subject != null && subject.isNotEmpty) {
      params['subject'] = subject;
    }
    if (body != null && body.isNotEmpty) {
      params['body'] = body;
    }
    if (cc != null && cc.isNotEmpty) {
      params['cc'] = cc.join(',');
    }
    if (bcc != null && bcc.isNotEmpty) {
      params['bcc'] = bcc.join(',');
    }

    if (params.isEmpty) return null;

    return params.entries
        .map(
          (e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');
  }
}

enum SocialPlatform { facebook, instagram, twitter, linkedin, youtube, tiktok }
