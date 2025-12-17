import 'package:get/get.dart';
import '../../data/repositories/auth_repository.dart';
import 'login_vm.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthRepository());
    Get.put(LoginVM());
  }
}

