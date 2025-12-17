import 'dart:async';
import 'package:fancy_shoes/data/repositories/auth_repository.dart';
import 'package:get/get.dart';

class VerifyEmailViewModel extends GetxController {
  final AuthRepository authRepository = Get.find();

  RxBool isChecking = false.obs;
  RxBool isSending = false.obs;
  RxInt cooldown = 0.obs;
  Timer? _timer;

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void startCooldown(int seconds) {
    cooldown.value = seconds;
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (t) {
      cooldown.value--;
      if (cooldown.value <= 0) {
        _timer?.cancel();
      }
    });
  }

  Future<void> resendEmail() async {
    if (cooldown.value > 0) return;

    isSending.value = true;
    try {
      await authRepository.sendEmailVerification();
      Get.snackbar(
        "Email Sent",
        "Verification email sent! Check inbox and spam folder.",
      );
      startCooldown(60);
    } catch (e) {
      Get.snackbar("Error", "Failed to send email: ${e.toString()}");
    }
    isSending.value = false;
  }

  Future<void> checkVerification() async {
    isChecking.value = true;
    try {
      final verified = await authRepository.isEmailVerified();
      if (verified) {
        Get.offAllNamed('/customer_home');
        Get.snackbar("Success!", "Email verified successfully — welcome!");
      } else {
        Get.snackbar(
          "Not Verified Yet",
          "Check email inbox and spam, then click verification link.",
        );
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
    isChecking.value = false;
  }

  Future<void> logout() async {
    await authRepository.logout();
  }
}

