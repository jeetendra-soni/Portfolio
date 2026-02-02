import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void urlLauncher({required String url}) async {
  try {
    String finalUrl = url.trim();
    if (finalUrl.isEmpty) {
      debugPrint('URL is empty');
      return;
    } else {
      // Add scheme if missing
      if (!finalUrl.startsWith('http://') && !finalUrl.startsWith('https://')) {
        finalUrl = 'https://$finalUrl';
      }

      // Parse URI safely
      final Uri uri = Uri.tryParse(finalUrl) ?? Uri();

      if (!uri.hasScheme) {
        debugPrint('Invalid URL: $finalUrl');
        return;
      }

      // Check if device can launch
      if (!await canLaunchUrl(uri)) {
        debugPrint('Cannot launch URL: $finalUrl');
        return;
      }

      if (Platform.isIOS || Platform.isAndroid) {
        await launchUrl(
          uri,
          mode: LaunchMode.platformDefault,
        );
      } else {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      }
    }
  } catch (e, stackTrace) {
    debugPrint('Error launching URL: $e');
    debugPrint('$stackTrace');
  }
}

Future<void> openPhoneDialer({
  required BuildContext context,
  required String phoneNumber,
}) async {
  try {
    // 1️⃣ Validate number
    if (phoneNumber.trim().isEmpty) {
      _showError(context, 'Phone number is empty');
      return;
    }

    // 2️⃣ Clean number (remove spaces, dashes, etc.)
    final sanitizedNumber = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');

    // 3️⃣ Platform check
    if (!(Platform.isAndroid || Platform.isIOS)) {
      _showError(context, 'Calling is not supported on this platform');
      return;
    }

    // 4️⃣ Create URI
    final Uri uri = Uri(
      scheme: 'tel',
      path: sanitizedNumber,
    );

    // 5️⃣ Check if device can launch
    if (!await canLaunchUrl(uri)) {
      _showError(context, 'No dialer app found');
      return;
    }

    // 6️⃣ Launch dialer
    final bool launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!launched) {
      _showError(context, 'Failed to open dialer');
    }
  } catch (e) {
    // 7️⃣ Catch any unexpected crash
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
