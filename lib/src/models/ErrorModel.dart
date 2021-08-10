class DataErrors {
  List<DataError> modelPlaceFromJson(dynamic response) => List<DataError>.from(response.map((x) => DataError.fromJson(x)));
}

class DataError {
  String msg;
  String param;
  String location;

  DataError({
    required this.msg,
    required this.param,
    required this.location,
  });

  factory DataError.fromJson(Map<String, dynamic> json) => DataError(
        msg: json["msg"],
        param: json["param"],
        location: json["location"],
      );
}
