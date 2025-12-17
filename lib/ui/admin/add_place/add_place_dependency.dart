import 'package:get/get.dart';
import '../../../data/repositories/media_repository.dart';
import '../../../data/repositories/place_repository.dart';
import 'add_place_vm.dart';

class AddPlaceBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PlaceRepository());
    Get.put(MediaRepository());
    Get.put(AddPlaceViewModel());
  }
}

