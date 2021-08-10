import 'package:capacity_control_admin_app/src/pages/loginPage.dart';
import 'package:capacity_control_admin_app/src/storage/DataStorage.dart';
import 'package:capacity_control_admin_app/src/widgets/CustomPageRoute.dart';
import 'package:capacity_control_admin_app/src/widgets/PlaceAlert.dart';
import 'package:capacity_control_admin_app/src/widgets/SearchDelegate.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final DataStorage storage = DataStorage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    margin: EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 20),
                    elevation: 10,
                    child: Image.asset(
                      'assets/logo.png',
                      width: 100,
                      height: 100,
                    ),
                  ),
                  Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    margin: EdgeInsets.only(top: 40, right: 20, bottom: 20),
                    elevation: 10,
                    child: Container(
                      child: Center(
                        child: Text(
                          'QRFORO',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      height: 100,
                      width: (MediaQuery.of(context).size.width - 160),
                    ),
                  ),
                ],
              ),
              _customCard(
                Colors.white,
                () => null,
                Icons.account_circle_outlined,
                storage.userName,
              ),
              _customCard(
                Theme.of(context).primaryColor,
                () => showSearch(
                  context: context,
                  delegate: DataSearch(),
                ),
                Icons.search,
                'Buscar establecimiento',
              ),
              _customCard(
                Theme.of(context).primaryColor,
                () => showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) => PlaceAlert(),
                ),
                Icons.add,
                'Agregar establecimiento',
              ),
              _customCard(
                Colors.redAccent,
                () => _logOutDialog(context),
                Icons.logout,
                'Cerrar Sesión',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _customCard(
    Color color,
    function,
    IconData icon,
    String title,
  ) {
    return Row(
      children: [
        Card(
          color: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.only(top: 20, left: 20),
          elevation: 10,
          child: Container(
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            width: (MediaQuery.of(context).size.width - 50) * 0.8,
            height: 70,
          ),
        ),
        Card(
          color: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.only(top: 20, left: 10, right: 20),
          elevation: 10,
          child: Container(
            child: IconButton(onPressed: function, icon: Icon(icon, size: 50)),
            width: (MediaQuery.of(context).size.width - 50) * 0.2,
            height: 70,
          ),
        ),
      ],
    );
  }

  Future<void> _logOutDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Cerrar Sesión', textAlign: TextAlign.center),
        content: Text('¿Está seguro que desea cerrar sesión?'),
        actions: <Widget>[
          TextButton(
            child: Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Aceptar'),
            onPressed: () {
              storage.userToken = '';
              Navigator.of(context).pushReplacement(CustomPageRoute(LoginPage()));
            },
          ),
        ],
      ),
    );
  }
}
