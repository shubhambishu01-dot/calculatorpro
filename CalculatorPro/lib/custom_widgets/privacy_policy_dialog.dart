import 'package:flutter/material.dart';

Future<void> showPrivacyPolicyDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'CalculatorPro respects your privacy. The app stores preferences '
            'and calculation history locally on your device to provide its '
            'features. It does not sell your personal information.\n\n'
            'App made by Shubham',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}