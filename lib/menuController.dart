import 'package:flutter/material.dart';
import 'package:gisApp/theme/color/light_color.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gisApp/helper/error_dialog.dart';
import 'package:gisApp/helper/success_dialog.dart';
import 'package:flutter/services.dart';
import 'package:jwt_decode/jwt_decode.dart';

//TODO verifier le paramètre passé et afficher le rendu en fonction de ça
//TODO DEFINIR LE CONTAINER DE LA PAGE REPORT ET LE CONTAINER DE LA PAGE COMMENT

Future saveReport(context, reportData, _token) async {
  final response = await http.post("http://localhost:8081/api/report",
      headers: {
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Headers": "*",
        'Content-Type': 'application/json;charset=UTF-8',
        'authorization': _token
      },
      body: reportData,
      encoding: Encoding.getByName("utf-8"));
  //TODO : pour le modal spinner
  Navigator.pop(context);
  return response;
}

class MenuController extends StatefulWidget {
  final String pageName;
  MenuController(this.pageName);
  @override
  _MenuControllerState createState() => _MenuControllerState(this.pageName);
}

class _MenuControllerState extends State<MenuController> {
  String pageName;
  TextEditingController date = TextEditingController();
  TextEditingController startingTime = TextEditingController();
  TextEditingController endingTime = TextEditingController();
  TextEditingController startingRange = TextEditingController();
  TextEditingController endingRange = TextEditingController();
  TextEditingController comment = TextEditingController();
  String _token;
  final _formKey = GlobalKey<FormState>();

  void userInfosLoader() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = (prefs.getString('token') ?? '');
    });
  }

  @override
  void initState() {
    date.text = "";
    startingTime.text = "";
    endingTime.text = "";
    userInfosLoader();

    super.initState();
  }

  _MenuControllerState(this.pageName); //récupération du paramètre pageName
//DEBUT WIDGETS PAGE REPORT:
//widget Header
  Widget _buildLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
              EdgeInsets.only(left: MediaQuery.of(context).size.height / 80),
          child: Text(
            'Nouveau rapport',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height / 45,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        )
      ],
    );
  }

//Widget event date
  Widget _buildDateRow() {
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
            Text("Date de l'évènement"),
            SizedBox(height: MediaQuery.of(context).size.height / 100),
            TextFormField(
                controller: date,
                style: TextStyle(color: Colors.black),
                readOnly: true,
                keyboardType: TextInputType.emailAddress,
                onTap: () async {
                  DateTime pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101));

                  if (pickedDate != null) {
                    print(pickedDate);
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    print(formattedDate);

                    setState(() {
                      date.text = formattedDate;
                    });
                  } else {
                    print("Date is not selected");
                  }
                },
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.height / 90,
                        right: MediaQuery.of(context).size.height / 90),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 0.0)),
                    labelStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(
                      Icons.date_range,
                      color: LightColor.mainColor,
                    ),
                    labelText: '2021-09-09'),
                //autovalidate: true,
                validator: (value) {
                  if (value.isEmpty) {
                    return "veuillez entrer la date.";
                  } else {
                    return null;
                  }
                }),
          ],
        ),
      ),
    );
  }

  //Widget Time
  Widget _buildTimeRow(dynamic fieldToSet, String label) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.height / 112),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.33,
        child: Padding(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.height / 89.6,
              right: MediaQuery.of(context).size.height / 89.6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(label),
              SizedBox(height: MediaQuery.of(context).size.height / 80),
              TextFormField(
                  controller: fieldToSet,
                  readOnly: true,
                  keyboardType: TextInputType.emailAddress,
                  onTap: () async {
                    TimeOfDay pickedTime = await showTimePicker(
                      initialTime: TimeOfDay.now(),
                      context: context,
                    );

                    if (pickedTime != null) {
                      print(pickedTime.format(context));
                      DateTime parsedTime = DateFormat.jm()
                          .parse(pickedTime.format(context).toString());
                      print(parsedTime);
                      String formattedTime =
                          DateFormat('HH:mm:ss').format(parsedTime);
                      print(formattedTime);
                      setState(() {
                        fieldToSet.text = formattedTime;
                      });
                      print(startingTime.text);
                    } else {
                      print("Time is not selected");
                    }
                  },
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.height / 90,
                          right: MediaQuery.of(context).size.height / 90),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.0)),
                      labelStyle: TextStyle(color: Colors.grey),
                      labelText: '00:00:00'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Veuillez entrer l'heure.";
                    } else {
                      return null;
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  //Widget Range
  Widget _buildRangeRow(dynamic fieldToSet) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.height / 112),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.33,
        child: Padding(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.height / 89.6,
              right: MediaQuery.of(context).size.height / 89.6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height / 80),
              TextFormField(
                  controller: fieldToSet,
                  keyboardType: TextInputType.number,
                  onTap: () {},
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.height / 90,
                          right: MediaQuery.of(context).size.height / 90),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.0)),
                      labelStyle: TextStyle(color: Colors.grey),
                      labelText: '99999'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Veuillez entrer la plage";
                    } else {
                      return null;
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  //Widget timeContainer
  Widget _buildCommentRow() {
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
            Text("Commentaire"),
            SizedBox(height: MediaQuery.of(context).size.height / 100),
            TextFormField(
              controller: comment,
              style: TextStyle(color: Colors.black),
              keyboardType: TextInputType.multiline,
              maxLines: null,
              onChanged: (value) {
                setState(() {
                  comment.text = value;
                });
              },
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.height / 90,
                      right: MediaQuery.of(context).size.height / 90,
                      bottom: MediaQuery.of(context).size.height * 0.19),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 0.0)),
                  labelStyle: TextStyle(color: Colors.grey),
                  labelText: 'Taper un commentaire...'),
            ),
          ],
        ),
      ),
    );
  }

  //Widget send button
  Widget _buildSendButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 1.4 * (MediaQuery.of(context).size.height / 25),
          width: 5 * (MediaQuery.of(context).size.width / 13),
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height / 44.8),
          child: RaisedButton(
            elevation: 5.0,
            color: Color(0xff04CF00),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            onPressed: () async {
              try {
                final result = await InternetAddress.lookup('google.com');
                if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                  if (_formKey.currentState.validate()) {
                    Map<String, dynamic> decodedData = Jwt.parseJwt(_token);
                    dynamic idTeam = decodedData["id_team"];
                    dynamic idUser = decodedData["id_user"];
                    dynamic response = await http.get(
                        "http://localhost:8081/api/team?id_team=" + idTeam,
                        headers: {
                          "Accept": "application/json",
                          "Access-Control-Allow-Origin": "*",
                          "Access-Control-Allow-Headers": "*",
                          'Content-Type': 'application/json;charset=UTF-8',
                          'authorization': _token
                        });
                    Map<String, dynamic> data = jsonDecode(response.body);
                    String codeDistrict =
                        data["response"]["team_name"].split("_")[1].trim();
                    dynamic centroidResponse = await http.get(
                        "http://localhost:8081/api/centroid?code_district=" +
                            codeDistrict,
                        headers: {
                          "Accept": "application/json",
                          "Access-Control-Allow-Origin": "*",
                          "Access-Control-Allow-Headers": "*",
                          'Content-Type': 'application/json;charset=UTF-8',
                          'authorization': _token
                        });
                    dynamic centroidData = jsonDecode(centroidResponse.body);
                    print(centroidData["response"]["id_district"]);

                    dynamic report = {
                      "comment": comment.text,
                      "date": date.text,
                      "starting_range": startingRange.text,
                      "ending_range": endingRange.text,
                      "starting_time": startingTime.text,
                      "ending_time": endingTime.text,
                      "id_user": idUser,
                      "id_district": centroidData["response"]["id_district"],
                    };
                    String reportData = jsonEncode(report);
                    showSpinner(context);
                    saveReport(context, reportData, _token).then((response) {
                      if (response.statusCode == 201) {
                        Map<String, dynamic> data = jsonDecode(response.body);
                        print(data);
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return SuccessDialogBox(
                                title: "rapport créé avec succès",
                                descriptions: "...",
                                text: "Fermer",
                              );
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
              "Connexion",
              style: TextStyle(
                color: Colors.white,
                letterSpacing: 1.5,
                fontSize: MediaQuery.of(context).size.height / 45,
              ),
            ),
          ),
        )
      ],
    );
  }

//spinner de chargement
  showSpinner(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.height / 179.2),
              child: Text("connexion")),
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

//widget page report contructor
  Widget _reportPageConstructor() {
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height / 90),
              _buildLogo(),
              SizedBox(height: MediaQuery.of(context).size.height / 50),
              _buildDateRow(),
              SizedBox(height: MediaQuery.of(context).size.height / 50),
              Row(children: <Widget>[
                _buildTimeRow(startingTime, "Heure de début"),
                SizedBox(width: MediaQuery.of(context).size.width * 0.2),
                _buildTimeRow(endingTime, "Heure de fin"),
              ]),
              SizedBox(height: MediaQuery.of(context).size.height / 40),
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(0),
                    child: Column(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.height / 50),
                            child: Text("Plage de numéro alloué")),
                        Row(children: <Widget>[
                          _buildRangeRow(startingRange),
                          Icon(Icons.arrow_right,
                              size: MediaQuery.of(context).size.height / 17.92),
                          _buildRangeRow(endingRange)
                        ])
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 40),
              _buildCommentRow(),
              SizedBox(height: MediaQuery.of(context).size.height / 40),
              _buildSendButton(),
            ],
          ),
        ],
      ),
    );
  }

  //DEBUT WIDGETS PAGE REPORT:
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text("IPD-GIS"),
              leading: new IconButton(
                icon: new Icon(Icons.arrow_back_ios,
                    size: MediaQuery.of(context).size.height / 28),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: _reportPageConstructor()));
  }
}
