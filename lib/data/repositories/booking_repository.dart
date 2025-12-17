import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/booking_model.dart';

class BookingRepository {
  late CollectionReference bookings;

  BookingRepository() {
    bookings = FirebaseFirestore.instance.collection('bookings');
  }

  Future<void> addBooking(Booking booking) async {
    final doc = bookings.doc();
    booking.id = doc.id;
    return doc.set(booking.toMap());
  }

  Future<void> updateBooking(Booking booking) async {
    var doc = bookings.doc(booking.id);
    return doc.set(booking.toMap());
  }

  Stream<List<Booking>> loadBookingsByUser(String userId) {
    return bookings.where("userId", isEqualTo: userId).snapshots().map((snapshot) {
      List<Booking> bookingsList = [];
      for (var snap in snapshot.docs) {
        Map<String, dynamic> map = snap.data() as Map<String, dynamic>;
        bookingsList.add(Booking.fromMap(map));
      }
      return bookingsList;
    });
  }

  Stream<List<Booking>> loadAllBookings() {
    return bookings.snapshots().map((snapshot) {
      List<Booking> bookingsList = [];
      for (var snap in snapshot.docs) {
        Map<String, dynamic> map = snap.data() as Map<String, dynamic>;
        print("Document data: $map");
        bookingsList.add(Booking.fromMap(map));
      }
      return bookingsList;
    });
  }

  Future<List<Booking>> loadAllBookingsOnce() async {
    var snapshot = await bookings.get();
    List<Booking> bookingsList = [];
    for (var snap in snapshot.docs) {
      Map<String, dynamic> map = snap.data() as Map<String, dynamic>;
      bookingsList.add(Booking.fromMap(map));
    }
    return bookingsList;
  }

  Future<void> updateBookingStatus(String bookingId, String status) async {
    await bookings.doc(bookingId).update({'status': status});
  }

  Future<void> deleteBooking(String bookingId) {
    return bookings.doc(bookingId).delete();
  }
}

