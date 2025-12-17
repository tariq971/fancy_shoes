import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../data/repositories/auth_repository.dart';

class LoginVM extends GetxController {
  RxBool isLoading = false.obs;
  AuthRepository authRepository = Get.find();
  // Rx<UserProfile?>currentUser = Rx<UserProfile?>(null);
  Future<void> login(String email, String password) async {
    if (!email.contains("@")) {
      Get.snackbar("Error", "Your Email do not contain @");
      return;
    }

    if (password.length < 6) {
      Get.snackbar("Error", "Password length is less than 6");
      return;
    }

    isLoading.value = true;

    try {
      UserCredential userData = await authRepository.login(
        email: email,
        password: password,
      );

      if (userData.user != null) {
        Get.snackbar("Success", "User is SignedIn");

        // Check if admin
        if (email == "yousifkhan.edu.pk@gmail.com") {
          Get.offAllNamed("/admin_dashboard");
        } else {
          Get.offAllNamed("/customer_home");
        }
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message ?? "Login Failed");
    }

    isLoading.value = false;
  }

  bool isUserLoggedIn() {
    return authRepository.getLoggedInUser() != null;
  }

  User? getLoggedInUser() {
    return authRepository.getLoggedInUser();
  }
}
