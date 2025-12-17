import 'package:fancy_shoes/data/repositories/auth_repository.dart';
import 'package:get/get.dart';
import 'verify_email_vm.dart';

class VerifyEmailBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthRepository());
    Get.put(VerifyEmailViewModel());
  }
}

