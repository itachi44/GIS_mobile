import 'package:flutter/material.dart';
import 'package:gisApp/home.dart';
import 'package:gisApp/theme/color/light_color.dart';
import 'package:gisApp/updateReport.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gisApp/helper/error_dialog.dart';
import 'package:gisApp/helper/success_dialog.dart';
import 'package:flutter/services.dart';
import 'package:jwt_decode/jwt_decode.dart';

Future saveReport(context, reportData, _token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  _token = (prefs.getString('token') ?? '');
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
  Navigator.pop(context);
  return response;
}

Future deleteReport(context, idReport, _token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  _token = (prefs.getString('token') ?? '');
  final response = await http.delete(
      "http://localhost:8081/api/report?id_report=" + idReport,
      headers: {
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Headers": "*",
        'Content-Type': 'application/json;charset=UTF-8',
        'authorization': _token
      });
  Navigator.pop(context);
  return response;
}

Future updateReport(context, idReport, reportData, _token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  _token = (prefs.getString('token') ?? '');
  final response =
      await http.put("http://localhost:8081/api/report?id_report=" + idReport,
          headers: {
            "Accept": "application/json",
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Headers": "*",
            'Content-Type': 'application/json;charset=UTF-8',
            'authorization': _token
          },
          body: reportData,
          encoding: Encoding.getByName("utf-8"));
  Navigator.pop(context);
  return response;
}

Future saveComment(context, commentData, _token) async {
  final response = await http.post("http://localhost:8081/api/comment",
      headers: {
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Headers": "*",
        'Content-Type': 'application/json;charset=UTF-8',
        'authorization': _token
      },
      body: commentData,
      encoding: Encoding.getByName("utf-8"));
  Navigator.pop(context);
  return response;
}

class MenuController extends StatefulWidget {
  final String pageName;
  final dynamic data;
  final dynamic idReport;
  MenuController(this.pageName, this.data, this.idReport);
  @override
  _MenuControllerState createState() =>
      _MenuControllerState(this.pageName, this.data, this.idReport);
}

class _MenuControllerState extends State<MenuController> {
  String pageName;
  dynamic data;
  dynamic idReport;
  TextEditingController date = TextEditingController();
  TextEditingController startingTime = TextEditingController();
  TextEditingController endingTime = TextEditingController();
  TextEditingController startingRange = TextEditingController();
  TextEditingController endingRange = TextEditingController();
  String comment;
  String _token;
  dynamic reportInfos;
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

  _MenuControllerState(this.pageName, this.data,
      this.idReport); //récupération du paramètre pageName
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
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);

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
                      String formattedTime =
                          DateFormat('HH:mm:ss').format(parsedTime);
                      setState(() {
                        fieldToSet.text = formattedTime;
                      });
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
              //controller: comment,
              style: TextStyle(color: Colors.black),
              keyboardType: TextInputType.multiline,
              maxLines: null,
              onChanged: (value) {
                setState(() {
                  comment = value;
                });
              },
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.height / 90,
                      right: MediaQuery.of(context).size.height / 90,
                      bottom: MediaQuery.of(context).size.height / 25),
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

  //Widget send report button
  Widget _buildSendReportButton() {
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
                    dynamic report = {
                      "comment": comment,
                      "date": date.text,
                      "starting_range": startingRange.text,
                      "ending_range": endingRange.text,
                      "starting_time": startingTime.text,
                      "ending_time": endingTime.text,
                      "id_user": idUser,
                      "id_district": centroidData["response"]["id_district"],
                    };
                    String reportData = jsonEncode(report);
                    showSpinner(context, "Connexion");
                    saveReport(context, reportData, _token).then((response) {
                      if (response.statusCode == 201) {
                        dynamic data = jsonDecode(response.body);
                        print(data);
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return SuccessDialogBox(
                                title: "rapport créé avec succès",
                                descriptions: "",
                                text: "Fermer",
                                pageToGo: "/home",
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
              "Envoyer",
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
              _buildSendReportButton(),
            ],
          ),
        ],
      ),
    );
  }

  //FIN WIDGETS PAGE REPORT:

  //DEBUT WIDGETS PAGE COMMENT:
  //widget page comment contructor
  Widget _commentPageConstructor() {
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height / 90),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.height / 80),
                    child: Text(
                      'Commentaire libre',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height / 45,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 50),
              _buildCommentRow(),
              SizedBox(height: MediaQuery.of(context).size.height / 40),
              _buildSendCommentButton(),
            ],
          ),
        ],
      ),
    );
  }

  //Widget send button
  Widget _buildSendCommentButton() {
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
                    dynamic idUser = decodedData["id_user"];
                    dynamic userComment = {
                      "comment_content": comment,
                      "id_user": idUser
                    };
                    String commentData = jsonEncode(userComment);
                    showSpinner(context, "Connexion");
                    saveComment(context, commentData, _token).then((response) {
                      if (response.statusCode == 201) {
                        Map<String, dynamic> data = jsonDecode(response.body);
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return SuccessDialogBox(
                                title: "commentaire créé avec succès",
                                descriptions: "",
                                text: "Fermer",
                                pageToGo: "/home",
                              );
                            });
                      } else {
                        dynamic data = jsonDecode(response.body);
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
              "Envoyer",
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
  //FIN WIDGETS PAGE COMMENT:

//WIDGET POUR CONSULTER UN REPORT SPECIFIQUE
  Widget _reportPage(dynamic data) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Color(0xfff2f3f7),
        body: ListView(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.85,
              width: MediaQuery.of(context).size.width,
              child: Container(
                decoration: BoxDecoration(
                  color: LightColor.mainColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: const Radius.circular(70),
                    bottomRight: const Radius.circular(70),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: MediaQuery.of(context).size.height / 20),
                    _profileContainer(data)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  final _key = GlobalKey<FormState>();
  Widget _profileContainer(dynamic data) {
    return Form(
      key: _key,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.75,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: MediaQuery.of(context).size.height / 10),
                      Text(
                        "Infos rapport",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height / 35,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff1e3799),
                          //decoration: TextDecoration.underline
                        ),
                      ),
                    ],
                  ),
                  Container(
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        border: Border.all(color: Color(0xff1e3799), width: 2),
                      ),
                      child: Column(
                        children: <Widget>[
                          _buildRow("Date : " + data["response"]["date"]),
                          _buildRow("Durée : " +
                              data["response"]["starting_time"]
                                  .substring(0, 5) +
                              "~" +
                              data["response"]["ending_time"].substring(0, 5)),
                          _buildRow(
                              "Plage : " + data["response"]["allocated_range"]),
                          _buildRow("Commentaire : "),
                          Container(
                            height: MediaQuery.of(context).size.height / 6.5,
                            child: SingleChildScrollView(
                                child: _commentRow(
                                    "", data["response"]["comment"])),
                          ),
                        ],
                      )),
                  SizedBox(height: 10),
                  Flexible(child: _buildUpdateButton()),
                  Flexible(child: _buildDeleteButton())
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 1.4 * (MediaQuery.of(context).size.height / 30),
          width: 5 * (MediaQuery.of(context).size.width / 13.2),
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height / 44.8),
          child: RaisedButton(
            elevation: 5.0,
            color: Color(0xffa4b0be),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            onPressed: () {},
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        UpdateReportPage(idReport)));
              },
              child: Row(
                children: <Widget>[
                  Text(
                    "Modifier ",
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 1.5,
                      fontSize: MediaQuery.of(context).size.height / 45,
                    ),
                  ),
                  Icon(Icons.border_color,
                      color: LightColor.mainColor,
                      size: MediaQuery.of(context).size.height / 35.84)
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildDeleteButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 1.4 * (MediaQuery.of(context).size.height / 30),
          width: 5 * (MediaQuery.of(context).size.width / 12),
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height / 44.8),
          child: RaisedButton(
            elevation: 5.0,
            color: Color(0xffa4b0be),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            onPressed: () {},
            child: InkWell(
              onTap: () {
                showSpinner(context, "En cours");
                deleteReport(context, idReport, _token).then((response) {
                  if (response.statusCode == 200) {
                    dynamic data = jsonDecode(response.body);
                    print(data);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => HomePage()));
                  }
                });
              },
              child: Row(
                children: <Widget>[
                  Text(
                    "Supprimer ",
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 1.5,
                      fontSize: MediaQuery.of(context).size.height / 45,
                    ),
                  ),
                  Icon(Icons.delete,
                      color: Colors.red,
                      size: MediaQuery.of(context).size.height / 35.84)
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _chip(String text, Color bcolor, Color textColor, double fontSize,
      dynamic alignment, isProfilePage,
      {double height = 0, bool isPrimaryCard = false}) {
    return Container(
      alignment: alignment,
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.height / 89.6,
          vertical: height),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color:
            isProfilePage ? bcolor.withAlpha(isPrimaryCard ? 200 : 50) : null,
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.black, fontSize: fontSize),
      ),
    );
  }

  Widget _buildRow(dynamic content) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.height / 112),
      child: _chip(content, LightColor.mainColor, Color(0xff1e3799),
          MediaQuery.of(context).size.height / 40, Alignment.centerLeft, false,
          height: MediaQuery.of(context).size.height / 74.7,
          isPrimaryCard: true),
    );
  }

  Widget _commentRow(dynamic content, dynamic comment) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.height / 50,
              right: MediaQuery.of(context).size.height / 50,
              bottom: MediaQuery.of(context).size.height / 112,
              top: 0),
          child: SingleChildScrollView(
            child: Text(
              comment,
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height / 49.78,
                  color: Colors.black),
            ),
          ),
        )
      ],
    );
  }

  Widget _chooseTheRightOne(dynamic pageName) {
    switch (pageName) {
      case "report":
        return _reportPageConstructor();
        break;
      case "comment":
        return _commentPageConstructor();
        break;
      case "seeReport":
        return _reportPage(data);
        break;
      default:
        return null;
    }
  }

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
            body: _chooseTheRightOne(pageName)));
  }
}
