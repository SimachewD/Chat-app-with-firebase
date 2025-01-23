import 'package:chatter_hive/core/constants/app_colors.dart';
import 'package:chatter_hive/core/constants/app_strings.dart';
import 'package:chatter_hive/data/providers/auth_provider.dart';
import 'package:chatter_hive/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthForm extends StatefulWidget {
  final bool isLogin;

  const AuthForm({super.key, required this.isLogin});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLoading = false;

  void _submitAuthForm() async {
    try {
      setState(() {
        _isLoading = true; // Show a loading spinner
      });

      if (widget.isLogin) {
        // Sign in
        await context.read<AuthProvider>().signIn(
              _emailController.text,
              _passwordController.text,
            );
      } else {
        // Register
        await context.read<AuthProvider>().register(
              _emailController.text,
              _passwordController.text,
              _nameController.text,
            );
      }

      // Navigate to the home page after successful login or registration
      Navigator.of(context).pushReplacementNamed(AppRoutes.feed);
    } catch (error) {
      // Handle any errors and display them
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    } finally {
      setState(() {
        _isLoading = false; // Hide the loading spinner
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Card(
        margin: const EdgeInsets.all(16),
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.isLogin ? 'Welcome Back!' : 'Create an Account',
                style: theme.textTheme.displayMedium,
              ),
              const SizedBox(height: 20),
              if(!widget.isLogin)
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              const SizedBox(height: 12),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submitAuthForm,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: AppColors.buttonColor,
                        foregroundColor: AppColors.whiteColor
                      ),
                      child: Text(widget.isLogin ? 'Login' : 'Sign Up'),
                    ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AuthForm(isLogin: !widget.isLogin),
                    ),
                  );
                },
                child: Text(
                  widget.isLogin
                      ? AppStrings.noAccount
                      : AppStrings.alreadyHaveAccount,
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.primaryColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
