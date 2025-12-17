// lib/auth/forgot_password_view.dart

import 'package:fancy_shoes/data/repositories/auth_repository.dart';
import 'package:fancy_shoes/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController emailC = TextEditingController();
  final AuthRepository authRepo = Get.find<AuthRepository>();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  Future<void> _sendResetEmail() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => isLoading = true);
    try {
      final email = emailC.text.trim();
      await authRepo.sendPasswordResetEmail(email: email);

      Get.snackbar(
        "Success",
        "Password reset link sent to $email. Check your inbox!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.successColor.withValues(alpha: 0.1),
        colorText: AppTheme.successColor,
      );
      // Optional: navigate back to login page after success
      await Future.delayed(const Duration(seconds: 3));
      Get.offAllNamed('/login');

    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.errorColor.withValues(alpha: 0.1),
        colorText: AppTheme.errorColor,
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(title: const Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock_reset,
                  size: 50,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                "Enter your email address to receive a password reset link.",
                textAlign: TextAlign.center,
                style: AppTheme.bodyMedium,
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: emailC,
                decoration: AppTheme.inputDecoration(
                  label: 'Email Address',
                  hint: 'user@example.com',
                  icon: Icons.email_outlined,
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Email is required';
                  if (!GetUtils.isEmail(v.trim())) return 'Enter a valid email';
                  return null;
                },
              ),
              const SizedBox(height: 32),
              isLoading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _sendResetEmail,
                        style: AppTheme.primaryButtonStyle,
                        child: const Text(
                          'Send Reset Link',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Back to Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}