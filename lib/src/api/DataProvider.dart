import 'dart:convert';
import 'package:capacity_control_admin_app/src/api/Constants.dart';
import 'package:capacity_control_admin_app/src/models/ErrorModel.dart';
import 'package:capacity_control_admin_app/src/models/PlaceModel.dart';
import 'package:capacity_control_admin_app/src/storage/DataStorage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

class DataProvider {
  static final DataProvider _instancia = new DataProvider._();
  factory DataProvider() {
    return _instancia;
  }
  DataProvider._();

  final Constants _constants = Constants();
  final DataStorage storage = new DataStorage();
  final Map<String, String> header = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  };

  Future<dynamic> login(String email, String pass) async {
    final Map<String, String> body = <String, String>{
      'email': email,
      'password': pass,
    };
    return await _auth(body, '/api/auth');
  }

  Future<dynamic> register(String name, String email, String pass) async {
    final Map<String, String> body = <String, String>{
      'name': name,
      'email': email,
      'password': pass,
    };
    return await _auth(body, '/api/auth/new');
  }

  Future<dynamic> _auth(Map<String, String> body, String endpoint) async {
    try {
      final Uri url = Uri.http(_constants.baseUrl, endpoint);
      final http.Response response = await http.post(
        url,
        headers: header,
        body: jsonEncode(body),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        final Map<String, dynamic> usuario = responseBody['usuario'];
        storage.userToken = responseBody['token'];
        storage.userName = usuario['name'];
        storage.userEmail = usuario['email'];
        return response.statusCode;
      } else {
        return _parseErrors(response);
      }
    } catch (e) {
      return _localError();
    }
  }

  Future<List<Place>> searchPlaces(String query) async {
    final Uri url = Uri.http(_constants.baseUrl, '/api/place/$query');
    final http.Response response = await http.get(url);
    final Map<String, dynamic> decodedData = json.decode(response.body);
    final List<Place> places = Places().modelPlaceFromJson(decodedData['places']);
    return places;
  }

  Future<dynamic> newPlace(
    String name,
    String address,
    int maxCapacity,
    int maxCapacityPermited,
  ) async {
    try {
      final Map<String, dynamic> body = <String, dynamic>{
        'name': name,
        'address': address,
        'maxCapacity': maxCapacity,
        'maxCapacityPermited': maxCapacityPermited,
      };
      final Uri url = Uri.http(_constants.baseUrl, '/api/place');

      final http.Response response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-token': storage.userToken,
        },
        body: jsonEncode(body),
      );
      if (response.statusCode == 201) {
        return Place.fromJson(jsonDecode(response.body)['place']);
      } else {
        return _parseErrors(response);
      }
    } catch (e) {
      return _localError();
    }
  }

  Future<dynamic> deletePlace(String id) async {
    try {
      final Uri url = Uri.http(_constants.baseUrl, '/api/place/$id');
      final http.Response response = await http.delete(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-token': storage.userToken,
        },
      );
      if (response.statusCode == 200) {
        return response.statusCode;
      } else {
        return _parseErrors(response);
      }
    } catch (e) {
      return _localError();
    }
  }

  Future<dynamic> updatePlace(
    String uid,
    String name,
    String address,
    int maxCapacity,
    int maxCapacityPermited,
  ) async {
    try {
      final Map<String, dynamic> body = <String, dynamic>{
        'name': name,
        'address': address,
        'maxCapacity': maxCapacity,
        'maxCapacityPermited': maxCapacityPermited,
      };
      final Uri url = Uri.http(_constants.baseUrl, '/api/place/$uid');

      final http.Response response = await http.put(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-token': storage.userToken,
        },
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        return Place.fromJson(jsonDecode(response.body)['place']);
      } else {
        return _parseErrors(response);
      }
    } catch (e) {
      return _localError();
    }
  }

  Future<dynamic> changePlaceImage(String uid) async {
    try {
      final XFile? image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (image == null) {
        return [DataError(msg: 'No se ha seleccionado alguna imagen.', param: 'image', location: 'user')];
      } else {
        final Uri url = Uri.http(_constants.baseUrl, '/api/place/img/$uid');
        final http.MultipartRequest request = http.MultipartRequest(
          'PUT',
          url,
        );
        Map<String, String> headers = <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-token': storage.userToken,
        };
        final http.MultipartFile pic = await http.MultipartFile.fromPath(
          "img",
          image.path,
          contentType: MediaType('image', image.path.split('.').last),
        );
        request.files.add(pic);
        request.headers.addAll(headers);

        final http.StreamedResponse response = await request.send();
        final Iterable<int> responseData = await response.stream.toBytes();
        final String responseString = String.fromCharCodes(responseData);

        final Map<String, dynamic> ressponseBody = jsonDecode(responseString);

        if (response.statusCode == 200) {
          return response.statusCode;
        } else {
          return DataErrors().modelPlaceFromJson(ressponseBody['errors']);
        }
      }
    } catch (e) {
      return _localError();
    }
  }

  List<DataError> _parseErrors(http.Response response) {
    final Map<String, dynamic> decodedData = json.decode(response.body);
    final List<DataError> errors = DataErrors().modelPlaceFromJson(decodedData['errors']);
    return errors;
  }

  List<DataError> _localError() {
    return [
      DataError(
        msg: 'Error Interno, verifique la conección a internet',
        param: 'local',
        location: 'user',
      )
    ];
  }
}
