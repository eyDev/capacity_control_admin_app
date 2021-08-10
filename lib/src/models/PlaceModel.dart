class Places {
  List<Place> modelPlaceFromJson(dynamic response) => List<Place>.from(
        response.map(
          (x) => Place.fromJson(x),
        ),
      );
}

class Place {
  String uid;
  String address;
  String name;
  int maxCapacity;
  int maxCapacityPermited;
  int currentUsers;

  Place({
    required this.uid,
    required this.address,
    required this.name,
    required this.maxCapacity,
    required this.maxCapacityPermited,
    required this.currentUsers,
  });

  factory Place.fromJson(Map<String, dynamic> json) => Place(
        uid: json["uid"],
        address: json["address"],
        name: json["name"],
        maxCapacity: json["maxCapacity"],
        maxCapacityPermited: json["maxCapacityPermited"],
        currentUsers: json["currentUsers"],
      );
}
