import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/booking_repository.dart';
import '../../../data/repositories/place_repository.dart';
import 'place_details_vm.dart';

class PlaceDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthRepository());
    Get.put(BookingRepository());
    Get.put(PlaceRepository());
    Get.put(PlaceDetailsViewModel());
  }
}

