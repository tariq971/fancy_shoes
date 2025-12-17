class Booking {
  String id;
  String userId;
  String placeId;
  String phoneNumber;
  String address;
  String status; // pending, approved, rejected
  int quantity;
  int totalPrice;

  Booking(
    this.id,
    this.userId,
    this.placeId,
    this.phoneNumber,
    this.address,
    this.status,
    this.quantity,
    this.totalPrice,
  );

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "userId": userId,
      "placeId": placeId,
      "phoneNumber": phoneNumber,
      "address": address,
      "status": status,
      "quantity": quantity,
      "totalPrice": totalPrice,
    };
  }

  static Booking fromMap(Map<String, dynamic> map) {
    return Booking(
      map['id'] ?? '',
      map['userId'] ?? '',
      map['placeId'] ?? '',
      map['phoneNumber'] ?? '',
      map['address'] ?? '',
      map['status'] ?? 'pending',
      map['quantity'] ?? 1,
      map['totalPrice'] ?? 0,
    );
  }
}

