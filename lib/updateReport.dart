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

class UpdateReportPage extends StatefulWidget {
  final dynamic idReport;
  UpdateReportPage(this.idReport);
  @override
  _UpdateReportPageState createState() => _UpdateReportPageState(this.idReport);
}

class _UpdateReportPageState extends State<UpdateReportPage> {
  dynamic idReport;

  @override
  void initState() {
    super.initState();
  }

  _UpdateReportPageState(this.idReport);

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
            body: Center(child: Text("implementation en cours"))));
  }
}
