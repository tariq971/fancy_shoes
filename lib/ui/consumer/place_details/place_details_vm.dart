import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/booking_repository.dart';
import '../../../data/repositories/place_repository.dart';
import '../../../models/booking_model.dart';
import '../../../models/place_model.dart';

class PlaceDetailsViewModel extends GetxController {
  final AuthRepository authRepository = Get.find();
  final BookingRepository bookingRepository = Get.find();
  final PlaceRepository placeRepository = Get.find();

  RxBool isBooking = false.obs;
  Rxn<Place> place = Rxn<Place>();

  // Quantity and total price
  RxInt quantity = 1.obs;
  RxInt totalPrice = 0.obs;

  @override
  void onInit() {
    super.onInit();
    place.value = Get.arguments as Place?;
    _calculateTotalPrice();
  }

  void _calculateTotalPrice() {
    if (place.value != null) {
      totalPrice.value = place.value!.price * quantity.value;
    }
  }

  bool get canIncrement => place.value != null && quantity.value < place.value!.availableSlots;
  bool get canDecrement => quantity.value > 1;

  void incrementQuantity() {
    if (!canIncrement) {
      Get.snackbar("Error", "Cannot exceed available slots (${place.value!.availableSlots})");
      return;
    }
    quantity.value++;
    _calculateTotalPrice();
  }

  void decrementQuantity() {
    if (!canDecrement) {
      Get.snackbar("Error", "Quantity cannot be less than 1");
      return;
    }
    quantity.value--;
    _calculateTotalPrice();
  }

  Future<void> bookPlace(String phoneNumber, String address) async {
    if (place.value == null) {
      Get.snackbar("Error", "Place not found");
      return;
    }

    if (phoneNumber.isEmpty) {
      Get.snackbar("Error", "Please enter phone number");
      return;
    }

    if (phoneNumber.length < 10) {
      Get.snackbar("Error", "Phone number must be at least 10 digits");
      return;
    }

    if (address.isEmpty) {
      Get.snackbar("Error", "Please enter your address");
      return;
    }

    if (place.value!.availableSlots <= 0) {
      Get.snackbar("Error", "No slots available");
      return;
    }

    if (quantity.value > place.value!.availableSlots) {
      Get.snackbar("Error", "Selected quantity exceeds available slots");
      return;
    }

    isBooking.value = true;

    try {
      final user = authRepository.getLoggedInUser();
      if (user == null) {
        Get.snackbar("Error", "User not logged in");
        isBooking.value = false;
        return;
      }

      Booking booking = Booking(
        "",
        user.uid,
        place.value!.id,
        phoneNumber,
        address,
        "pending",
        quantity.value,
        totalPrice.value,
      );

      await bookingRepository.addBooking(booking);
      print("✅ Booking created: ${booking.id}");
      print("User ID: ${booking.userId}");
      print("Place ID: ${booking.placeId}");
      print("Quantity: ${booking.quantity}");
      print("Total Price: ${booking.totalPrice}");
      print("Status: ${booking.status}");

      // Decrease available slots by quantity
      place.value!.availableSlots = place.value!.availableSlots - quantity.value;
      await placeRepository.updatePlace(place.value!);

      Get.snackbar("Success", "Booking created! Waiting for admin approval.");
      Get.back();
    } catch (e) {
      Get.snackbar("Error", "Error: ${e.toString()}");
    }

    isBooking.value = false;
  }
}
