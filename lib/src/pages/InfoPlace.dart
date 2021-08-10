import 'dart:ui';

import 'package:capacity_control_admin_app/src/api/Constants.dart';
import 'package:capacity_control_admin_app/src/api/DataProvider.dart';
import 'package:capacity_control_admin_app/src/models/PlaceModel.dart';
import 'package:capacity_control_admin_app/src/pages/MainPage.dart';
import 'package:capacity_control_admin_app/src/widgets/CustomPageRoute.dart';
import 'package:capacity_control_admin_app/src/widgets/PlaceAlert.dart';
import 'package:capacity_control_admin_app/src/widgets/SnackBarError.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';

class InforPlacePage extends StatefulWidget {
  final Place place;
  InforPlacePage({required this.place});

  @override
  _InforPlacePageState createState() => _InforPlacePageState();
}

class _InforPlacePageState extends State<InforPlacePage> {
  final DataProvider apiConnection = DataProvider();
  final Constants _constants = Constants();

  @override
  void initState() {
    super.initState();
    _evictImage();
  }

  @override
  Widget build(BuildContext context) {
    final double aforo = (widget.place.currentUsers / widget.place.maxCapacityPermited) * 100;
    final Color aforoColor = aforo < 70
        ? Colors.green
        : aforo < 80
            ? Colors.amber
            : Colors.red;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: aforoColor,
        title: Text(widget.place.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image(
                  image: NetworkImage('http://${_constants.baseUrl}/api/place/img/${widget.place.uid}'),
                  width: MediaQuery.of(context).size.width,
                  height: (MediaQuery.of(context).size.width * 3) / 4,
                  fit: BoxFit.fill,
                  key: UniqueKey(),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: FloatingActionButton(
                    backgroundColor: Theme.of(context).primaryColor,
                    onPressed: () => apiConnection.changePlaceImage(widget.place.uid).then(
                          (result) => result == 200 ? setState(() => _evictImage()) : showInSnackBar(context, result),
                        ),
                    child: Icon(Icons.photo),
                  ),
                )
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Column(
                children: [
                  _customCard(
                    'Aforo',
                    'La cantidad de personas que se encuentran alojadas en el establecimiento en este momento.',
                    widget.place.currentUsers.toString(),
                    color: aforoColor,
                  ),
                  _customCard(
                      'Porcentaje del Aforo',
                      'La división entre el número actual de personas alojadas y la cantidad máxima de personas permitidas.',
                      '${((widget.place.currentUsers / widget.place.maxCapacityPermited) * 100).toStringAsFixed(2)}%',
                      color: aforoColor),
                  _customCard(
                    'Capacidad Máxima',
                    'La cantidad de personas que el establecimiento puede alojar.',
                    widget.place.maxCapacity.toString(),
                  ),
                  _customCard(
                    'Capacidad Máxima Permitida',
                    'La cantidad de personas que el establecimiento puede alojar debido a la pandemia.',
                    widget.place.maxCapacityPermited.toString(),
                  ),
                  _customCard(
                    'Procentaje máximo de personas permitido',
                    'La división entre la capacidad máxima y la capacidad máxima permitida de personas.',
                    '${((widget.place.maxCapacityPermited / widget.place.maxCapacity) * 100).toStringAsFixed(2)}%',
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: (MediaQuery.of(context).size.width / 2) - 15,
                        height: 50,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.amber),
                          ),
                          onPressed: () => _modifyDialog(context),
                          child: ButtonBar(
                            alignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Editar',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Icon(Icons.edit),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width / 2) - 15,
                        height: 50,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                          ),
                          onPressed: () => _deleteDialog(context),
                          child: ButtonBar(
                            alignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Eliminar',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Icon(Icons.delete),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'QR de entrada',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  QrImage(
                    data: '{"placeID":"${widget.place.uid}", "process": "in"}',
                    size: MediaQuery.of(context).size.width * 0.9,
                  ),
                  Text(
                    'QR de salida',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  QrImage(
                    data: '{"placeID":"${widget.place.uid}", "process": "out"}',
                    size: MediaQuery.of(context).size.width * 0.9,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _modifyDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => PlaceAlert(
        uid: widget.place.uid,
        name: widget.place.name,
        address: widget.place.address,
        maxCapacity: widget.place.maxCapacity.toString(),
        maxCapacityPermited: widget.place.maxCapacityPermited.toString(),
      ),
    );
  }

  Future<void> _deleteDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Eliminar establecimiento', textAlign: TextAlign.center),
        content: Text('¿Está seguro que desea eliminar este establecimiento público?'),
        actions: <Widget>[
          TextButton(
            child: Text('Cancelar'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text('Aceptar'),
            onPressed: () => apiConnection.deletePlace(widget.place.uid).then(
                  (result) => result == 200
                      ? Navigator.of(context).pushReplacement(CustomPageRoute(MainPage()))
                      : showInSnackBar(context, result),
                ),
          ),
        ],
      ),
    );
  }

  Widget _customCard(String title, String subtitle, String quantity, {Color color = Colors.white}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Card(
          margin: EdgeInsets.only(bottom: 10),
          color: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 10,
          child: Container(
            width: (MediaQuery.of(context).size.width - 30) * 0.70,
            height: 120,
            child: Center(
              child: ListTile(
                title: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: Text(subtitle, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ),
        Card(
          margin: EdgeInsets.only(bottom: 10),
          color: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 10,
          child: Container(
            width: (MediaQuery.of(context).size.width - 30) * 0.30,
            height: 120,
            child: Center(
              child: Text(quantity, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ],
    );
  }

  void _evictImage() {
    NetworkImage('http://10.0.2.2:8000/api/place/img/${widget.place.uid}').evict();
  }
}
