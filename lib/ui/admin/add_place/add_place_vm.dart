import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/repositories/media_repository.dart';
import '../../../data/repositories/place_repository.dart';
import '../../../models/place_model.dart';

class AddPlaceViewModel extends GetxController {
  final PlaceRepository placeRepository = Get.find();
  final MediaRepository mediaRepository = Get.find();

  RxBool isSaving = false.obs;
  Rxn<XFile> image = Rxn<XFile>();
  Rxn<Place> existingPlace = Rxn<Place>();

  @override
  void onInit() {
    super.onInit();
    existingPlace.value = Get.arguments as Place?;
  }

  Future<void> savePlace(
    String name,
    String price,
    String dateFrom,
    String dateTo,
    String description,
    String availableSlots,
  ) async {
    if (name.isEmpty) {
      Get.snackbar("Error", "Please enter place name");
      return;
    }

    if (price.isEmpty) {
      Get.snackbar("Error", "Please enter price");
      return;
    }

    if (dateFrom.isEmpty) {
      Get.snackbar("Error", "Please select start date");
      return;
    }

    if (dateTo.isEmpty) {
      Get.snackbar("Error", "Please select end date");
      return;
    }

    if (description.isEmpty) {
      Get.snackbar("Error", "Please enter description");
      return;
    }

    if (availableSlots.isEmpty) {
      Get.snackbar("Error", "Please enter available slots");
      return;
    }

    isSaving.value = true;

    try {
      Place place;

      if (existingPlace.value == null) {
        // Add new place
        place = Place(
          "",
          name,
          int.parse(price),
          dateFrom,
          dateTo,
          description,
          int.parse(availableSlots),
        );
      } else {
        // Edit existing place
        place = existingPlace.value!;
        place.name = name;
        place.price = int.parse(price);
        place.dateFrom = dateFrom;
        place.dateTo = dateTo;
        place.description = description;
        place.availableSlots = int.parse(availableSlots);
      }

      await uploadImage(place);

      if (existingPlace.value == null) {
        await placeRepository.addPlace(place);
        Get.snackbar("Success", "Place added successfully");
      } else {
        await placeRepository.updatePlace(place);
        Get.snackbar("Success", "Place updated successfully");
      }

      Get.back(result: true);
    } catch (e) {
      Get.snackbar("Error", "Error: ${e.toString()}");
    }

    isSaving.value = false;
  }

  Future<void> uploadImage(Place place) async {
    if (image.value != null) {
      var cloudImageUrl = await mediaRepository.uploadImage(image.value!.path);
      if (cloudImageUrl.isSuccessful) {
        place.image = cloudImageUrl.url;
      } else {
        Get.snackbar("Error", cloudImageUrl.error ?? "Could not upload image");
        return;
      }
    }
  }

  Future<void> imagePicker() async {
    final ImagePicker picker = ImagePicker();
    image.value = await picker.pickImage(source: ImageSource.gallery);
  }
}

