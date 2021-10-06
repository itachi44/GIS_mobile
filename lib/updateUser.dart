import 'package:flutter/material.dart';
import 'package:gisApp/home.dart';
import 'package:gisApp/main.dart';
import 'package:gisApp/theme/color/light_color.dart';
import 'package:gisApp/updateReport.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:gisApp/helper/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gisApp/helper/error_dialog.dart';
import 'package:gisApp/helper/success_dialog.dart';
import 'package:flutter/services.dart';
import 'package:jwt_decode/jwt_decode.dart';

void reload(context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();
  prefs.setBool("isLoggedIn", false);
  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginPage()),
      (Route<dynamic> route) => false);
}

Future updateUser(context, idUser, userInfos, _token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  _token = (prefs.getString('token') ?? '');
  final response =
      await http.put("http://localhost:8081/api/user?id_user=" + idUser,
          headers: {
            "Accept": "application/json",
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Headers": "*",
            'Content-Type': 'application/json;charset=UTF-8',
            'authorization': _token
          },
          body: userInfos,
          encoding: Encoding.getByName("utf-8"));
  return response;
}

Future getTeamId(context, teamName) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  dynamic _token = (prefs.getString('token') ?? '');
  final response = await http
      .get("http://localhost:8081/api/team?team_name=" + teamName, headers: {
    "Accept": "application/json",
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Headers": "*",
    'Content-Type': 'application/json;charset=UTF-8',
    'authorization': _token
  });
  return response.body;
}

class UpdateUserPage extends StatefulWidget {
  final dynamic idUser;
  final dynamic userData;
  final dynamic userTeam;
  UpdateUserPage(this.idUser, this.userData, this.userTeam);
  @override
  _UpdateUserPageState createState() =>
      _UpdateUserPageState(this.idUser, this.userData, this.userTeam);
}

class _UpdateUserPageState extends State<UpdateUserPage> {
  dynamic idUser;
  dynamic idReport;
  dynamic userData;
  dynamic userTeam;
  TextEditingController email = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController telephone = TextEditingController();
  TextEditingController password = TextEditingController();
  dynamic team;
  String _token;
  final _formKey = GlobalKey<FormState>();
  _UpdateUserPageState(this.idUser, this.userData, this.userTeam);

  int searchTeam(team) {
    for (var i = 0; i < teamList.length; i++) {
      if (teamList[i].split(":")[0].trim() == team) {
        return i;
      }
    }
  }

//Team list
  List teamList = [
    "Equipe",
    "Team_DKC : DAKAR-CENTRE",
    "Team_DKN : DAKAR-NORD",
    "Team_DKO : DAKAR-OUEST",
    "Team_DKS : DAKAR-SUD",
    "Team_DIA : DIAMNIADIO",
    "Team_GUE : GUEDIAWAYE",
    "Team_KMA : KEUR MASSAR",
    "Team_MBA : MBAO",
    "Team_PIK : PIKINE",
    "Team_RUF : RUFISQUE",
    "Team_SAN : SANGALKAM",
    "Team_YEU : YEUMBEUL",
    "Team_BAM : BAMBEY",
    "Team_DIO : DIOURBEL",
    "Team_MBK : MBACKE",
    "Team_TOU : TOUBA",
    "Team_DIF : DIOFFIOR",
    "Team_FAT : FATICK",
    "Team_FOU : FOUNDIOUGNE",
    "Team_GOS : GOSSAS",
    "Team_NIA : NIAKHAR",
    "Team_PAS : PASSY",
    "Team_SOK : SOKONE",
    "Team_BIR : BIREKELANE",
    "Team_KAF : KAFFRINE",
    "Team_KOU : KOUNGHEUL",
    "Team_MHD : MALEM HODAR",
    "Team_GUI : GUINGUINEO",
    "Team_KAO : KAOLACK",
    "Team_NDO : NDOFFANE",
    "Team_NIO : NIORO DU RIP",
    "Team_BIG : BIGNONA",
    "Team_DIL : DIOULOULOU",
    "Team_OUS : OUSSOUYE",
    "Team_TKE : THIONK-ESSYL",
    "Team_ZIG : ZIGUINCHOR",
    "Team_KOL : KOLDA",
    "Team_MYF : MEDINA YORO FOULAH",
    "Team_VEL : VELINGARA",
    "Team_COK : COKI",
    "Team_DAH : DAHRA",
    "Team_DAR : DAROU MOUSTY",
    "Team_KEB : KEBEMER",
    "Team_KMS : KEUR MOMAR SARR",
    "Team_LIN : LINGUERE",
    "Team_LOU : LOUGA",
    "Team_SAK : SAKAL",
    "Team_KAN : KANEL",
    "Team_MAT : MATAM",
    "Team_RAN : RANEROU",
    "Team_TIL : THILOGNE",
    "Team_DAG : DAGANA",
    "Team_PET : PETE",
    "Team_POD : PODOR",
    "Team_RTL : RICHARD-TOLL",
    "Team_STL : SAINT-LOUIS",
    "Team_BOU : BOUNKILING",
    "Team_GOD : GOUDOMP",
    "Team_SED : SEDHIOU",
    "Team_BAK : BAKEL",
    "Team_DIM : DIANKE MAKHAN",
    "Team_GOU : GOUDIRY",
    "Team_KID : KIDIRA",
    "Team_KMP : KOUMPENTOUM",
    "Team_MAK : MAKA COULIBANTANG",
    "Team_TAM : TAMBACOUNDA",
    "Team_JOA : JOAL-FADIOUTH",
    "Team_KHO : KHOMBOLE",
    "Team_MBO : MBOUR",
    "Team_MEK : MECKHE",
    "Team_POP : POPENGUINE",
    "Team_POU : POUT",
    "Team_THD : THIADIAYE",
    "Team_THI : THIES",
    "Team_TIV : TIVAOUANE",
    "Team_KED : KEDOUGOU",
    "Team_SAL : SALEMATA",
    "Team_SAR : SARAYA",
    "Team_DIK : DIAKHAO"
  ];

  Widget _buildTeamSelectorRow() {
    return Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.height / 112),
        child: Container(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.height / 80,
              right: MediaQuery.of(context).size.height / 80),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1),
              borderRadius: BorderRadius.circular(15)),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
            child: DropdownButtonFormField(
              value: team,
              hint: Text("Equipe"),
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down),
              iconSize: MediaQuery.of(context).size.height / 29.8,
              elevation: 15,
              decoration: InputDecoration.collapsed(hintText: ''),
              style: TextStyle(
                  color: Colors.black,
                  fontSize: MediaQuery.of(context).size.height / 49.78),
              onChanged: (newValue) {
                setState(() {
                  team = newValue;
                });
              },
              validator: (value) {
                if (value.isEmpty || value == "équipe") {
                  return "selectionnez une équipe";
                } else {
                  return null;
                }
              },
              items: teamList.map<DropdownMenuItem<String>>((valueItem) {
                return DropdownMenuItem<String>(
                    value: valueItem,
                    child: Center(
                        child: Text(
                      valueItem,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height / 40,
                      ),
                    )));
              }).toList(),
            ),
          ),
        ));
  }

  @override
  void initState() {
    setState(() {
      email = TextEditingController(text: userData["response"]["email"]);
      firstName =
          TextEditingController(text: userData["response"]["first_name"]);
      lastName = TextEditingController(text: userData["response"]["last_name"]);
      telephone =
          TextEditingController(text: userData["response"]["telephone"]);
    });
    team = userTeam["response"]["team_name"].split("_");
    team = team[0][0].toUpperCase() +
        team[0].substring(1, team[0].length) +
        "_" +
        team[1].toUpperCase();
    int i = searchTeam(team);
    team = teamList[i];
    super.initState();
  }

  //widget Header
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
              EdgeInsets.only(left: MediaQuery.of(context).size.height / 80),
          child: Text(
            'Mise à jour utilisateur',
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
  Widget _buildUpdateUserButton() {
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
                    dynamic teamInfos =
                        await getTeamId(context, team.split(":")[0].trim());
                    dynamic teamInfosData = jsonDecode(teamInfos);
                    dynamic user = {};
                    if (password2.text != "") {
                      user = {
                        "last_name": lastName.text,
                        "first_name": firstName.text,
                        "email": email.text,
                        "telephone": telephone.text,
                        "id_team": teamInfosData["response"]["id_team"],
                        "password": password2.text
                      };
                    } else {
                      user = {
                        "last_name": lastName.text,
                        "first_name": firstName.text,
                        "email": email.text,
                        "telephone": telephone.text,
                        "id_team": teamInfosData["response"][0]["id_team"]
                      };
                    }
                    String userData = jsonEncode(user);
                    showSpinner(context, "Traitement en cours...");
                    updateUser(context, idUser, userData, _token)
                        .then((response) {
                      if (response.statusCode == 200) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return SuccessDialogBox(
                                title: "utilisateur mis à jour avec succès",
                                descriptions: "veuillez vous reconnecter",
                                text: "Fermer",
                                pageToGo: "/home",
                              );
                            });
                        dynamic data = jsonDecode(response.body);

                        reload(context);
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

  //Update page contructor
  Widget _updatePageConstructor() {
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height / 90),
              _buildHeader(),
              SizedBox(height: MediaQuery.of(context).size.height / 50),
              _buildEmailRow(),
              SizedBox(height: MediaQuery.of(context).size.height / 50),
              _buildFirstNameRow(),
              SizedBox(width: MediaQuery.of(context).size.width * 0.2),
              _buildLastNameRow(),
              SizedBox(height: MediaQuery.of(context).size.height / 40),
              _buildTelephoneRow(),
              SizedBox(height: MediaQuery.of(context).size.height / 40),
              _buildTeamSelectorRow(),
              SizedBox(height: MediaQuery.of(context).size.height / 40),
              _buildPasswordButton(),
              SizedBox(height: MediaQuery.of(context).size.height / 40),
              _buildUpdateUserButton(),
            ],
          ),
        ],
      ),
    );
  }

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
                      Icons.date_range,
                      color: LightColor.mainColor,
                    ),
                    labelText: 'email'),
                //autovalidate: true,
                validator: (value) {
                  if (value.isEmpty) {
                    return "veuillez entrer l'adresse email.";
                  } else {
                    return null;
                  }
                }),
          ],
        ),
      ),
    );
  }

  Widget _buildFirstNameRow() {
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
            Text("Prénom"),
            SizedBox(height: MediaQuery.of(context).size.height / 100),
            TextFormField(
                controller: firstName,
                style: TextStyle(color: Colors.black),
                keyboardType: TextInputType.text,
                onTap: () {},
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
                    labelText: 'Prénom'),
                //autovalidate: true,
                validator: (value) {
                  if (value.isEmpty ||
                      !RegExp(r'^[a-zA-Zç]+$').hasMatch(value)) {
                    return "entrer un prénom valide";
                  } else {
                    return null;
                  }
                }),
          ],
        ),
      ),
    );
  }

  Widget _buildLastNameRow() {
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
            Text("Nom"),
            SizedBox(height: MediaQuery.of(context).size.height / 100),
            TextFormField(
                controller: lastName,
                style: TextStyle(color: Colors.black),
                keyboardType: TextInputType.text,
                onTap: () {},
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
                    labelText: 'Nom'),
                //autovalidate: true,
                validator: (value) {
                  if (value.isEmpty ||
                      !RegExp(r'^[a-zA-Zç]+$').hasMatch(value)) {
                    return "entrer un nom valide";
                  } else {
                    return null;
                  }
                }),
          ],
        ),
      ),
    );
  }

  Widget _buildTelephoneRow() {
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
            Text("téléphone"),
            SizedBox(height: MediaQuery.of(context).size.height / 100),
            TextFormField(
                controller: telephone,
                style: TextStyle(color: Colors.black),
                keyboardType: TextInputType.phone,
                onTap: () {},
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
                    labelText: 'Téléphone'),
                //autovalidate: true,
                validator: (value) {
                  if (value.isEmpty ||
                      !RegExp(r'^(\+221)?[- ]?(77|70|76|78)[- ]?([0-9]{3})[- ]?([0-9]{2}[- ]?){2}$')
                          .hasMatch(value)) {
                    return "entrer un numéro valide";
                  } else {
                    return null;
                  }
                }),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 1.4 * (MediaQuery.of(context).size.height / 30),
          width: 5 * (MediaQuery.of(context).size.width / 7),
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
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return contentBox(context);
                    });
              },
              child: Row(
                children: <Widget>[
                  Text(
                    "Modifier mot de passe ",
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 1.5,
                      fontSize: MediaQuery.of(context).size.height / 45,
                    ),
                  ),
                  Icon(Icons.keyboard_hide,
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

//Widgets pour le modal du mdp
  TextEditingController password1 = TextEditingController();
  TextEditingController password2 = TextEditingController();
  String passwordLabelText1 = "Mot de passe actuel";
  String passwordLabelText2 = "Nouveau mot de passe";
  Widget _buildPasswordRow1() {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.height / 112),
      child: TextFormField(
          controller: password1,
          keyboardType: TextInputType.text,
          obscureText: true,
          onChanged: (value) {},
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.lock,
              color: mainColor,
            ),
            labelText: passwordLabelText1,
          ),
          validator: (value) {
            if (value.isEmpty) {
              return "veuillez entrer votre mot de passe";
            } else {
              return null;
            }
          }),
    );
  }

  Widget _buildPasswordRow2() {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.height / 112),
      child: TextFormField(
          controller: password2,
          keyboardType: TextInputType.text,
          obscureText: true,
          onChanged: (value) {},
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.lock,
              color: mainColor,
            ),
            labelText: passwordLabelText2,
          ),
          validator: (value) {
            if (value.isEmpty) {
              return "veuillez entrer votre mot de passe";
            } else {
              return null;
            }
          }),
    );
  }

  Widget _buildValidateButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 1.4 * (MediaQuery.of(context).size.height / 30),
          width: 5 * (MediaQuery.of(context).size.width / 15),
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height / 44.8),
          child: RaisedButton(
            elevation: 5.0,
            color: Color(0xff04CF00),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "Envoyer",
              style: TextStyle(
                color: Colors.white,
                letterSpacing: 1.5,
                fontSize: MediaQuery.of(context).size.height / 50,
              ),
            ),
          ),
        )
      ],
    );
  }

  contentBox(context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
                left: Constants.padding,
                top: Constants.avatarRadius + Constants.padding,
                right: Constants.padding,
                bottom: Constants.padding),
            margin: EdgeInsets.only(top: Constants.avatarRadius),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.circular(Constants.padding),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black,
                      offset: Offset(0, 10),
                      blurRadius: 10),
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _buildPasswordRow1(),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 40,
                ),
                _buildPasswordRow2(),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 40,
                ),
                _buildValidateButton(),
                //bouton fermer
                Align(
                  alignment: Alignment.bottomRight,
                  child: FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: _getPage(widget.pageToGo)));
                      },
                      child: Text(
                        "Fermer",
                        style: TextStyle(fontSize: 18),
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

//TODO mettre un future builder ici ??
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
            body: _updatePageConstructor()));
  }
}
