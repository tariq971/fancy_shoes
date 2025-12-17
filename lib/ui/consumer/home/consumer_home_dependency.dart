import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/booking_repository.dart';
import '../../../data/repositories/place_repository.dart';
import 'consumer_home_vm.dart';

class ConsumerHomeBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AuthRepository>()) {
      Get.put(AuthRepository());
    }
    if (!Get.isRegistered<PlaceRepository>()) {
      Get.put(PlaceRepository());
    }
    if (!Get.isRegistered<BookingRepository>()) {
      Get.put(BookingRepository());
    }
    Get.put(ConsumerHomeViewModel());
  }
}

