import 'package:fancy_shoes/data/repositories/auth_repository.dart';
import 'package:get/get.dart';

class SignUpVM extends GetxController {
  final AuthRepository authRepo = Get.find<AuthRepository>();
  // final SignUpVM signUpVM = Get.find();

  final isLoading = false.obs;

  Future<void> signup({
    emailVal,
     passVal,
     nameVal = "New User",
  }) async {

    try {
      isLoading.value = true;

      await authRepo.signup(
       email: emailVal,
        password: passVal,
        name: nameVal,
      );

      await authRepo.sendEmailVerification();

      Get.offAllNamed('/verify-email');

      Get.snackbar("Verify Email", "Verification link sent to ");
    } catch (e) {
      final msg = e is Exception ? e.toString() : 'Signup failed';
      Get.snackbar("Signup failed", msg);
    } finally {
      isLoading.value = false;
    }
  }

  // Future<void> signupUsingFields() => signup();
  //
  // void clear() {
  //   email.value = '';
  //   password.value = '';
  //   confirmPassword.value = '';
  //   name.value = '';
  // }
}
