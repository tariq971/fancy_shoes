class Place {
  String id;
  String name;
  String? image;
  int price;
  String dateFrom;
  String dateTo;
  String description;
  int availableSlots;

  Place(
    this.id,
    this.name,
    this.price,
    this.dateFrom,
    this.dateTo,
    this.description,
    this.availableSlots,
  );

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "image": image,
      "price": price,
      "dateFrom": dateFrom,
      "dateTo": dateTo,
      "description": description,
      "availableSlots": availableSlots,
    };
  }

  static Place fromMap(Map<String, dynamic> map) {
    Place p = Place(
      map['id'],
      map['name'],
      map['price'],
      map['dateFrom'],
      map['dateTo'],
      map['description'],
      map['availableSlots'],
    );
    p.image = map['image'];
    return p;
  }
}

