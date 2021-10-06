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

class UpdateReportPage extends StatefulWidget {
  final dynamic idReport;
  final dynamic data;
  UpdateReportPage(this.idReport, this.data);
  @override
  _UpdateReportPageState createState() =>
      _UpdateReportPageState(this.idReport, this.data);
}

class _UpdateReportPageState extends State<UpdateReportPage> {
  dynamic idReport;
  dynamic data;
  TextEditingController date = TextEditingController();
  TextEditingController startingTime = TextEditingController();
  TextEditingController endingTime = TextEditingController();
  TextEditingController startingRange = TextEditingController();
  TextEditingController endingRange = TextEditingController();
  TextEditingController comment = TextEditingController();
  String _token;
  dynamic reportInfos;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    setState(() {
      date = new TextEditingController(text: data["response"]["date"]);
      startingTime =
          new TextEditingController(text: data["response"]["starting_time"]);
      endingTime =
          new TextEditingController(text: data["response"]["ending_time"]);
      dynamic range = data["response"]["allocated_range"].split("-");
      startingRange = TextEditingController(text: range[0]);
      endingRange = TextEditingController(text: range[1]);
      comment = TextEditingController(text: data["response"]["comment"]);
    });
    super.initState();
  }

  _UpdateReportPageState(this.idReport, this.data);
  //widget Header
  Widget _buildLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
              EdgeInsets.only(left: MediaQuery.of(context).size.height / 80),
          child: Text(
            'Mise à jour du rapport',
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
                    dynamic report = {
                      "comment": comment.text,
                      "date": date.text,
                      "allocated_range":
                          startingRange.text + "-" + endingRange.text,
                      "starting_time": startingTime.text,
                      "ending_time": endingTime.text,
                    };
                    String reportData = jsonEncode(report);
                    showSpinner(context, "Traitement en cours...");
                    updateReport(context, idReport, reportData, _token)
                        .then((response) {
                      if (response.statusCode == 200) {
                        dynamic data = jsonDecode(response.body);
                        print(data);
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return SuccessDialogBox(
                                title: "rapport mis à jour avec succès",
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
              onChanged: (value) {},
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
