import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Professional URL Launcher utility that is Web-safe.
/// Avoids 'dart:io' to prevent "Unsupported operation: Platform._operatingSystem" on Web.
void urlLauncher({required String url}) async {
  try {
    String finalUrl = url.trim();
    if (finalUrl.isEmpty) {
      debugPrint('URL is empty');
      return;
    }

    // Add scheme if missing
    if (!finalUrl.startsWith('http://') && !finalUrl.startsWith('https://')) {
      finalUrl = 'https://$finalUrl';
    }

    final Uri uri = Uri.parse(finalUrl);

    // Check if device can launch
    if (await canLaunchUrl(uri)) {
      // For Web, platformDefault is usually the best choice as it lets the browser handle it.
      // For Mobile, we can specify externalApplication if we want to ensure it opens in a real browser.
      await launchUrl(
        uri,
        mode: kIsWeb ? LaunchMode.platformDefault : LaunchMode.externalApplication,
      );
    } else {
      debugPrint('Cannot launch URL: $finalUrl');
    }
  } catch (e, stackTrace) {
    debugPrint('Error launching URL: $e');
    debugPrint('$stackTrace');
  }
}

Future<void> openWhatsApp() async {
  final Uri url = Uri.parse("https://wa.me/7509005537"); // replace with your number

  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch WhatsApp';
  }
}

Future<void> openPhoneDialer({
  required BuildContext context,
  required String phoneNumber,
}) async {
  try {
    if (phoneNumber.trim().isEmpty) {
      _showError(context, 'Phone number is empty');
      return;
    }

    // Clean number
    final sanitizedNumber = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');

    // Web-safe platform check using foundation's defaultTargetPlatform
    final bool isMobile = defaultTargetPlatform == TargetPlatform.android || 
                         defaultTargetPlatform == TargetPlatform.iOS;

    if (!isMobile) {
      _showError(context, 'Calling is not supported on this platform');
      return;
    }

    final Uri uri = Uri(
      scheme: 'tel',
      path: sanitizedNumber,
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      _showError(context, 'No dialer app found');
    }
  } catch (e) {
    _showError(context, 'Something went wrong');
  }
}

void _showError(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
    ),
  );
}