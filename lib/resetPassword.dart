import 'package:flutter/material.dart';
import 'package:gisApp/theme/color/light_color.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:gisApp/helper/constants.dart';
import 'package:gisApp/helper/error_dialog.dart';
import 'package:gisApp/helper/resetPassword_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:jwt_decode/jwt_decode.dart';

Future resetPassword(context, email) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  dynamic _token = (prefs.getString('token') ?? '');
  final response = await http.post("http://localhost:8081/api/resetPassword",
      headers: {
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Headers": "*",
        'Content-Type': 'application/json;charset=UTF-8',
        'authorization': _token
      },
      body: email,
      encoding: Encoding.getByName("utf-8"));
  Navigator.pop(context);
  return response;
}

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  TextEditingController email = TextEditingController();

  Widget _buildEmailRow() {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.height / 112),
      child: Padding(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.height / 89.6,
            right: MediaQuery.of(context).size.height / 89.6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Email"),
            SizedBox(height: MediaQuery.of(context).size.height / 100),
            TextFormField(
                controller: email,
                style: TextStyle(color: Colors.black),
                keyboardType: TextInputType.emailAddress,
                onTap: () {},
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.height / 90,
                        right: MediaQuery.of(context).size.height / 90),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 0.0)),
                    labelStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(
                      Icons.email,
                      color: LightColor.mainColor,
                    ),
                    labelText: 'email'),
                //autovalidate: true,
                validator: (value) {
                  if (value.isEmpty ||
                      !RegExp(r'^[a-zA-Z0-9.]+\@pasteur\.sn$')
                          .hasMatch(value)) {
                    return "entrer une adresse email valide";
                  } else {
                    return null;
                  }
                }),
          ],
        ),
      ),
    );
  }

  Widget _buildSendButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 1.4 * (MediaQuery.of(context).size.height / 30),
          width: MediaQuery.of(context).size.width * 0.92,
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height / 44.8),
          child: RaisedButton(
            elevation: 5.0,
            color: mainColor,
            onPressed: () async {
              try {
                final result = await InternetAddress.lookup('google.com');
                if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                  if (_formKey.currentState.validate()) {
                    showSpinner(context, "Traitement en cours...");
                    dynamic userInf = {
                      "email": email.text,
                    };
                    String data = jsonEncode(userInf);

                    resetPassword(context, data).then((response) {
                      if (response.statusCode == 200) {
                        dynamic data = jsonDecode(response.body);
                        print(data);
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return PasswordResetDialogBox();
                            });
                      } else {
                        dynamic data = jsonDecode(response.body);
                        print(data);
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CustomDialogBox(
                                title: "Erreur",
                                descriptions: "..",
                                text: "Fermer",
                              );
                            });
                      }
                    });
                  } else {
                    print("données invalides");
                  }
                }
              } on SocketException catch (_) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CustomDialogBox(
                        title: "Pas de connexion internet",
                        descriptions:
                            'vérifier votre connexion internet et réessayez.',
                        text: "Fermer",
                      );
                    });
              }
            },
            child: Text(
              "Réinitialiser mot de passe",
              style: TextStyle(
                color: Colors.white,
                letterSpacing: 1,
                fontSize: MediaQuery.of(context).size.height / 50,
              ),
            ),
          ),
        )
      ],
    );
  }

  showSpinner(BuildContext context, dynamic content) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.height / 179.2),
              child: Text(content)),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  final _formKey = GlobalKey<FormState>();
  Widget _buildContainer() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[_buildEmailRow(), _buildSendButton()],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("Mot de passe oublié"),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios,
              size: MediaQuery.of(context).size.height / 28),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _buildContainer(),
    ));
  }
}
