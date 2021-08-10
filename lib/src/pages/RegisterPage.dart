import 'package:capacity_control_admin_app/src/api/DataProvider.dart';
import 'package:capacity_control_admin_app/src/pages/LoginPage.dart';
import 'package:capacity_control_admin_app/src/pages/MainPage.dart';
import 'package:capacity_control_admin_app/src/widgets/CustomPageRoute.dart';
import 'package:capacity_control_admin_app/src/widgets/InputField.dart';
import 'package:capacity_control_admin_app/src/widgets/SnackBarError.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameEditingController = TextEditingController();
  final TextEditingController emailEditingController = TextEditingController();
  final TextEditingController passwordEditingController = TextEditingController();
  final DataProvider apiConnection = DataProvider();
  bool _isButtonDisabled = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(16),
            children: [
              Image(
                image: AssetImage('assets/registro.png'),
                height: 200,
              ),
              Text(
                'Registro',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              InputField(
                label: 'Nombre',
                regexPattern: RegExp(r'(^[a-zA-Z ]+$)'),
                inputType: TextInputType.name,
                controller: nameEditingController,
              ),
              SizedBox(height: 15),
              InputField(
                label: 'Email',
                regexPattern: RegExp(r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)'),
                inputType: TextInputType.emailAddress,
                controller: emailEditingController,
              ),
              SizedBox(height: 15),
              InputField(
                label: 'Contraseña',
                regexPattern: RegExp(r'(^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[^\w\s]).{8,14}$)'),
                inputType: TextInputType.visiblePassword,
                controller: passwordEditingController,
              ),
              SizedBox(height: 15),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
                    fixedSize: MaterialStateProperty.all<Size>(Size(double.infinity, 55))),
                onPressed: _isButtonDisabled
                    ? () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isButtonDisabled = false;
                          });
                          apiConnection
                              .register(
                                nameEditingController.text,
                                emailEditingController.text,
                                passwordEditingController.text,
                              )
                              .then((result) => {
                                    if (result == 201)
                                      {
                                        Navigator.of(context).pushReplacement(CustomPageRoute(MainPage())),
                                      }
                                    else
                                      {
                                        showInSnackBar(context, result),
                                      }
                                  })
                              .then((value) => setState(() => _isButtonDisabled = true));
                        }
                      }
                    : null,
                child: _isButtonDisabled
                    ? Text('Registrarse')
                    : CircularProgressIndicator(
                        color: Colors.white,
                      ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pushReplacement(CustomPageRoute(LoginPage())),
                child: Text('Ingresar'),
                style: ButtonStyle(foregroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
