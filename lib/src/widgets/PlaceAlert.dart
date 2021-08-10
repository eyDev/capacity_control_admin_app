import 'package:capacity_control_admin_app/src/api/DataProvider.dart';
import 'package:capacity_control_admin_app/src/models/ErrorModel.dart';
import 'package:capacity_control_admin_app/src/models/PlaceModel.dart';
import 'package:capacity_control_admin_app/src/pages/InfoPlace.dart';
import 'package:capacity_control_admin_app/src/widgets/CustomPageRoute.dart';
import 'package:capacity_control_admin_app/src/widgets/InputField.dart';
import 'package:capacity_control_admin_app/src/widgets/SnackBarError.dart';
import 'package:flutter/material.dart';

class PlaceAlert extends StatefulWidget {
  final String uid;
  final String name;
  final String address;
  final String maxCapacity;
  final String maxCapacityPermited;

  const PlaceAlert({
    Key? key,
    this.uid = '',
    this.name = '',
    this.address = '',
    this.maxCapacity = '',
    this.maxCapacityPermited = '',
  }) : super(key: key);

  @override
  _PlaceAlertState createState() => _PlaceAlertState();
}

class _PlaceAlertState extends State<PlaceAlert> {
  bool _isLoading = false;
  final TextEditingController nameEditingController = TextEditingController();
  final TextEditingController addressEditingController = TextEditingController();
  final TextEditingController maxCapacityEditingController = TextEditingController();
  final TextEditingController maxCapacityPermitedEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final DataProvider apiConnection = DataProvider();
  final List<DataError> errors = <DataError>[
    DataError(
      location: 'user',
      msg: 'La capacidad máxima debe ser mayor a la capacidad máxima permitida.',
      param: 'newplace',
    )
  ];

  @override
  void initState() {
    if (widget.uid != '') {
      nameEditingController.text = widget.name;
      addressEditingController.text = widget.address;
      maxCapacityEditingController.text = widget.maxCapacity;
      maxCapacityPermitedEditingController.text = widget.maxCapacityPermited;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text(
          widget.uid == "" ? 'Agregar Establecimiento Público' : 'Modificar Establecimiento Público',
          textAlign: TextAlign.center,
        ),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: ListBody(
              children: <Widget>[
                InputField(
                  label: 'Nombre del establecimiento',
                  regexPattern: RegExp(r"(^.*$)"),
                  inputType: TextInputType.text,
                  controller: nameEditingController,
                ),
                SizedBox(height: 15),
                InputField(
                  label: 'Dirección',
                  regexPattern: RegExp(r"(^.*$)"),
                  inputType: TextInputType.text,
                  controller: addressEditingController,
                ),
                SizedBox(height: 15),
                InputField(
                  label: 'Capacidad Máxima',
                  regexPattern: RegExp(r'(^([1-9][0-9]{0,3}|10000)$)'),
                  inputType: TextInputType.number,
                  controller: maxCapacityEditingController,
                ),
                SizedBox(height: 15),
                InputField(
                  label: 'Capacidad Máxima Permitida',
                  regexPattern: RegExp(r'(^([1-9][0-9]{0,3}|10000)$)'),
                  inputType: TextInputType.number,
                  controller: maxCapacityPermitedEditingController,
                ),
              ],
            ),
          ),
        ),
        actions: !_isLoading
            ? <Widget>[
                TextButton(
                  child: Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Aceptar'),
                  onPressed: () {
                    final int? maxCapacityParsed = int.tryParse(maxCapacityEditingController.text);
                    final int? maxCapacityPermitedParsed = int.tryParse(maxCapacityPermitedEditingController.text);
                    if (_formKey.currentState!.validate() &&
                        maxCapacityParsed != null &&
                        maxCapacityPermitedParsed != null &&
                        maxCapacityParsed >= maxCapacityPermitedParsed) {
                      setState(() {
                        _isLoading = true;
                      });
                      widget.uid == ""
                          ? apiConnection
                              .newPlace(
                                nameEditingController.text,
                                addressEditingController.text,
                                maxCapacityParsed,
                                maxCapacityPermitedParsed,
                              )
                              .then((result) => {
                                    if (result is Place)
                                      {
                                        Navigator.pop(context),
                                        Navigator.of(context).push(CustomPageRoute(InforPlacePage(
                                          place: result,
                                        )))
                                      }
                                    else
                                      {
                                        showInSnackBar(context, result),
                                      }
                                  })
                              .then((value) => setState(() => _isLoading = false))
                          : apiConnection
                              .updatePlace(
                                widget.uid,
                                nameEditingController.text,
                                addressEditingController.text,
                                maxCapacityParsed,
                                maxCapacityPermitedParsed,
                              )
                              .then((result) => {
                                    if (result is Place)
                                      {
                                        Navigator.pop(context),
                                        Navigator.pop(context),
                                        Navigator.of(context).push(CustomPageRoute(InforPlacePage(
                                          place: result,
                                        )))
                                      }
                                    else
                                      {
                                        showInSnackBar(context, result),
                                      }
                                  })
                              .then((value) => setState(() => _isLoading = false));
                    } else {
                      showInSnackBar(context, errors);
                    }
                  },
                ),
              ]
            : <Widget>[
                Center(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 15),
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  ),
                ),
              ]);
  }
}
