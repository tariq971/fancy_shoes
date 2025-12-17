import 'package:fancy_shoes/auth/signup/verify_email_vm.dart';
import 'package:fancy_shoes/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerifyEmailPage extends StatefulWidget {
  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  late VerifyEmailViewModel verifyEmailViewModel;

  @override
  void initState() {
    super.initState();
    verifyEmailViewModel = Get.find();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Verify Email"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.mark_email_unread, size: 60, color: AppTheme.primaryColor),
            ),
            const SizedBox(height: 24),
            const Text(
              "Verify Your Email",
              style: AppTheme.headingLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              "We've sent a verification link to your email address. Please check your inbox and spam folder.",
              style: AppTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Check Verification Button
            Obx(() {
              return verifyEmailViewModel.isChecking.value
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: () {
                          verifyEmailViewModel.checkVerification();
                        },
                        style: AppTheme.primaryButtonStyle,
                        child: const Text(
                          "I've Verified My Email",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
            }),
            const SizedBox(height: 16),

            // Resend Email Button
            Obx(() {
              return verifyEmailViewModel.isSending.value
                  ? const CircularProgressIndicator()
                  : TextButton(
                      onPressed: verifyEmailViewModel.cooldown.value > 0
                          ? null
                          : () {
                              verifyEmailViewModel.resendEmail();
                            },
                      child: Text(
                        verifyEmailViewModel.cooldown.value > 0
                            ? "Resend in ${verifyEmailViewModel.cooldown.value}s"
                            : "Resend Verification Email",
                        style: TextStyle(
                          fontSize: 14,
                          color: verifyEmailViewModel.cooldown.value > 0
                              ? AppTheme.textLight
                              : AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
            }),
            const SizedBox(height: 24),

            // Tips Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                border: Border.all(color: AppTheme.borderColor),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Email not received?",
                    style: AppTheme.labelStyle,
                  ),
                  SizedBox(height: 8),
                  Text(
                    "• Check your spam/junk folder\n• Make sure you entered correct email\n• Wait a few minutes and try resending",
                    style: AppTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Logout Button
            TextButton(
              onPressed: () async {
                await verifyEmailViewModel.logout();
              },
              child: const Text(
                "Cancel / Logout",
                style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
