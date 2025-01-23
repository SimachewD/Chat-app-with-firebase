import 'package:flutter/material.dart';

class SocialLoginButtons extends StatelessWidget {
  final Function onGoogleLogin;

  const SocialLoginButtons({super.key, required this.onGoogleLogin});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () => onGoogleLogin(),
          icon: const Icon(Icons.golf_course),
          label: const Text('Login with Google'),
        ),
        // Add more social buttons as needed
      ],
    );
  }
}
