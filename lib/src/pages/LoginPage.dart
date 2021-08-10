import 'package:capacity_control_admin_app/src/api/DataProvider.dart';
import 'package:capacity_control_admin_app/src/pages/MainPage.dart';
import 'package:capacity_control_admin_app/src/pages/RegisterPage.dart';
import 'package:capacity_control_admin_app/src/storage/DataStorage.dart';
import 'package:capacity_control_admin_app/src/widgets/CustomPageRoute.dart';
import 'package:capacity_control_admin_app/src/widgets/InputField.dart';
import 'package:capacity_control_admin_app/src/widgets/SnackBarError.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailEditingController = TextEditingController();
  final TextEditingController passwordEditingController = TextEditingController();
  final DataProvider apiConnection = DataProvider();
  final DataStorage storage = new DataStorage();
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
                image: AssetImage('assets/login.png'),
                height: 200,
              ),
              Text(
                'Login',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
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
                              .login(
                                emailEditingController.text,
                                passwordEditingController.text,
                              )
                              .then((result) => {
                                    if (result == 200)
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
                    ? Text('Ingresar')
                    : CircularProgressIndicator(
                        color: Colors.white,
                      ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pushReplacement(CustomPageRoute(RegisterPage())),
                child: Text('Registrarse'),
                style: ButtonStyle(foregroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
