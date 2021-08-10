import 'package:shared_preferences/shared_preferences.dart';

class DataStorage {
  static final DataStorage _instancia = new DataStorage._();
  factory DataStorage() {
    return _instancia;
  }
  DataStorage._();

  SharedPreferences? _storage;

  initPrefs() async {
    this._storage = await SharedPreferences.getInstance();
  }

  String get userToken {
    return _storage!.getString('jwt') ?? '';
  }

  set userToken(String value) {
    _storage!.setString('jwt', value);
  }

  String get userName {
    return _storage!.getString('name') ?? '';
  }

  set userName(String value) {
    _storage!.setString('name', value);
  }

  String get userEmail {
    return _storage!.getString('email') ?? '';
  }

  set userEmail(String value) {
    _storage!.setString('email', value);
  }
}
