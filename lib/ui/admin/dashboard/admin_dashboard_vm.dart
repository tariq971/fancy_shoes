import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/booking_repository.dart';
import '../../../data/repositories/place_repository.dart';
import '../../../models/booking_model.dart';
import '../../../models/place_model.dart';

class AdminDashboardViewModel extends GetxController {
  final AuthRepository authRepository = Get.find();
  final PlaceRepository placeRepository = Get.find();
  final BookingRepository bookingRepository = Get.find();

  RxList<Place> places = <Place>[].obs;
  RxList<Booking> bookings = <Booking>[].obs;
  RxMap<String, String> userNames = <String, String>{}.obs;
  RxBool isLoading = false.obs;
  RxInt selectedTab = 0.obs;

  @override
  void onInit() {
    super.onInit();
    print(" AdminDashboardViewModel onInit called");
    loadPlaces();
    loadBookings(); // Using stream for real-time updates
  }

  void loadPlaces() {
    isLoading.value = true;
    placeRepository.loadPlaces().listen((placesList) {
      places.value = placesList;
      isLoading.value = false;
    });
  }

  void loadBookings() {
    bookingRepository.loadAllBookings().listen(
          (bookingsList) {
        bookings.value = bookingsList;
        print(" Loaded ${bookingsList.length} bookings");
      },
      onError: (error) {
        print(" Error loading bookings: $error");
      },
    );
  }

  Future<void> loadBookingsOnce() async {
    try {
      print(" Loading bookings once...");
      List<Booking> bookingsList = await bookingRepository
          .loadAllBookingsOnce();
      bookings.value = bookingsList;
      print(" Loaded ${bookingsList.length} bookings (once)");
      for (var booking in bookingsList) {
        print(
            "Booking: ${booking.id}, Status: ${booking.status}, User: ${booking
                .userId}");
      }
    } catch (e) {
      print(" Error loading bookings: $e");
    }
  }

  Future<void> deletePlace(Place place) async {
    try {
      await placeRepository.deletePlace(place);
      Get.snackbar("Success", "Place deleted successfully");
    } catch (e) {
      Get.snackbar("Error", "Error: ${e.toString()}");
    }
  }

  Future<void> updateBookingStatus(String bookingId, String status) async {
    try {
      await bookingRepository.updateBookingStatus(bookingId, status);
      Get.snackbar("Success", "Booking $status");
    } catch (e) {
      Get.snackbar("Error", "Error: ${e.toString()}");
    }
  }

  void changeTab(int index) {
    selectedTab.value = index;
  }

  String getPlaceName(String placeId) {
    final place = places.firstWhereOrNull((p) => p.id == placeId);
    return place?.name ?? "Unknown Tour";
  }

  int getBookingPrice(Booking booking) {
    // Agar totalPrice 0 hai (purani booking), to place price * quantity
    if (booking.totalPrice == 0) {
      final place = places.firstWhereOrNull((p) => p.id == booking.placeId);
      if (place != null) {
        return place.price * booking.quantity;
      }
    }
    return booking.totalPrice;
  }

  String getUserDisplayName(String oderId, String userId) {
    return "Order#${oderId.length > 6
        ? oderId.substring(0, 6).toUpperCase()
        : oderId.toUpperCase()}";
  }

  Future<void> logout() async {
    await authRepository.signOut();
  }
}

