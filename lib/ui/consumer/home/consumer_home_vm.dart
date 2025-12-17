import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/booking_repository.dart';
import '../../../data/repositories/place_repository.dart';
import '../../../models/booking_model.dart';
import '../../../models/place_model.dart';

class ConsumerHomeViewModel extends GetxController {
  final AuthRepository authRepository = Get.find();
  final PlaceRepository placeRepository = Get.find();
  final BookingRepository bookingRepository = Get.find();

  RxList<Place> places = <Place>[].obs;
  RxList<Place> filteredPlaces = <Place>[].obs;
  RxList<Booking> myBookings = <Booking>[].obs;
  RxBool isLoading = false.obs;
  RxString searchQuery = "".obs;
  RxInt selectedTab = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadPlaces();
    loadMyBookings();
  }

  void loadPlaces() {
    isLoading.value = true;
    placeRepository.loadPlaces().listen((placesList) {
      places.value = placesList;
      filterPlaces();
      isLoading.value = false;
    });
  }

  void loadMyBookings() {
    final user = authRepository.getLoggedInUser();
    if (user != null) {
      bookingRepository.loadBookingsByUser(user.uid).listen((bookingsList) {
        // Sort by status: pending first, then approved, then rejected
        bookingsList.sort((a, b) {
          int statusOrder(String status) {
            if (status == 'pending') return 0;
            if (status == 'approved') return 1;
            if (status == 'rejected') return 2;
            return 3;
          }
          return statusOrder(a.status).compareTo(statusOrder(b.status));
        });
        myBookings.value = bookingsList;
      });
    }
  }

  String getPlaceName(String placeId) {
    final place = places.firstWhereOrNull((p) => p.id == placeId);
    return place?.name ?? "Unknown Tour";
  }

  int getBookingPrice(Booking booking) {
    // Agar totalPrice 0 hai (purani booking), to place price * quantity use karo
    if (booking.totalPrice == 0) {
      final place = places.firstWhereOrNull((p) => p.id == booking.placeId);
      if (place != null) {
        return place.price * booking.quantity;
      }
    }
    return booking.totalPrice;
  }

  void changeTab(int index) {
    selectedTab.value = index;
  }

  void filterPlaces() {
    if (searchQuery.value.isEmpty) {
      filteredPlaces.value = places;
    } else {
      filteredPlaces.value = places.where((place) {
        return place.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
            place.description.toLowerCase().contains(searchQuery.value.toLowerCase());
      }).toList();
    }
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    filterPlaces();
  }

  Future<void> logout() async {
    await authRepository.signOut();
  }
}

