import 'package:chatter_hive/data/providers/auth_provider.dart';
import 'package:chatter_hive/features/auth/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;

  const AuthGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    if (authProvider.user == null) {
      return const LoginScreen(); // Redirect if not logged in
    }
    return child; // Render the protected page
  }
}
