import 'package:capacity_control_admin_app/src/api/Constants.dart';
import 'package:capacity_control_admin_app/src/pages/LoginPage.dart';
import 'package:capacity_control_admin_app/src/pages/MainPage.dart';
import 'package:capacity_control_admin_app/src/storage/DataStorage.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final DataStorage data = DataStorage();
  await data.initPrefs();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final DataStorage _data = DataStorage();
  final Constants _constants = Constants();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Capacity Control Admin App',
      home: _data.userToken == '' ? LoginPage() : MainPage(),
      theme: ThemeData(primaryColor: _constants.primaryColor),
    );
  }
}
