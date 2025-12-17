import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/place_model.dart';

class PlaceRepository {
  late CollectionReference stored_places;

  PlaceRepository() {
    stored_places = FirebaseFirestore.instance.collection('places');
  }

  Future<void> addPlace(Place place) async {
    final doc = stored_places.doc();
    place.id = doc.id;
    return doc.set(place.toMap());
  }

  Future<void> updatePlace(Place place) async {
    var doc = stored_places.doc(place.id);
    return doc.set(place.toMap());
  }

  Stream<List<Place>> loadPlaces() {
    return stored_places.snapshots().map((snapshot) {
      List<Place> places = [];
      for (var snap in snapshot.docs) {
        Map<String, dynamic> map = snap.data() as Map<String, dynamic>;
        places.add(Place.fromMap(map));
      }
      return places;
    });
  }

  Future<List<Place>> loadPlacesOnce() async {
    var snapshot = await stored_places.get();
    List<Place> places = [];
    for (var snap in snapshot.docs) {
      Map<String, dynamic> map = snap.data() as Map<String, dynamic>;
      places.add(Place.fromMap(map));
    }
    return places;
  }

  Future<Place?> getPlaceById(String placeId) async {
    var doc = await stored_places.doc(placeId).get();
    if (doc.exists) {
      return Place.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> deletePlace(Place place) {
    return stored_places.doc(place.id).delete();
  }
}

