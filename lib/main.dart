import 'package:flutter/material.dart';
import 'package:gisApp/helper/constants.dart';
import 'package:gisApp/home.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io';
import 'package:gisApp/helper/error_dialog.dart';
import 'package:gisApp/helper/success_dialog.dart';
import 'package:gisApp/resetPassword.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decode/jwt_decode.dart';

//création de la session du user
Future getDistrict(context, codeDistrict, token) async {
  final response = await http.get(
      "http://localhost:8081/api/centroid?code_district=" + codeDistrict,
      headers: {
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Headers": "*",
        'Content-Type': 'application/json;charset=UTF-8',
        'Authorization': token,
      });

  return response; //ici on retourne la réponse de la requête
}

savePref(String name, String email, String token, bool isLoggedIn,
    String idUser) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setString("name", name);
  preferences.setString("email", email);
  preferences.setString("token", token);
  preferences.setString("idUser", idUser);
  preferences.setBool("isLoggedIn", isLoggedIn);
  //preferences.commit(); //commit is deprecated
}

Future connectUser(context, userData) async {
  //ici on fera l'envoie et la récupération des données
  final response = await http.post("http://localhost:8081/api/login",
      headers: {
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Headers": "*",
        'Content-Type': 'application/json;charset=UTF-8',
      },
      body: userData,
      encoding: Encoding.getByName("utf-8"));
  //fermer le  de chargement
  Navigator.pop(context);
  return response; //ici on retourne la réponse de la requête
}

Future saveUser(context, userData, token) async {
  final response = await http.post("http://localhost:8081/api/user",
      headers: {
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Headers": "*",
        'Content-Type': 'application/json;charset=UTF-8',
      },
      body: userData,
      encoding: Encoding.getByName("utf-8"));
  Navigator.pop(context);
  return response;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var isLoggedIn = preferences.getBool("isLoggedIn");
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: isLoggedIn == true ? HomePage() : LoginPage(),
    routes: {
      '/SignUp': (context) => SignUpPage(),
      '/Home': (context) => HomePage()
    },
  ));
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email, password;
  dynamic recentReports;

  String emailLabelText = "E-mail", passwordLabelText = "Mot de passe";
  Widget _buildLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height / 14),
          child: Text(
            'IPD-GIS',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height / 25,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }

  FocusNode emailFocusNode, passwordFocusNode;
  @override
  void initState() {
    super.initState();
    emailFocusNode = new FocusNode();
    passwordFocusNode = new FocusNode();
    emailFocusNode.addListener(() {
      if (!emailFocusNode.hasFocus) {
        setState(() {
          emailLabelText = "E-mail";
        });
      } else {
        setState(() {
          emailLabelText = "";
        });
      }
    });
    passwordFocusNode.addListener(() {
      if (!passwordFocusNode.hasFocus) {
        setState(() {
          passwordLabelText = "Mot de passe";
        });
      } else {
        setState(() {
          passwordLabelText = "";
        });
      }
    });
  }

  Widget _buildEmailRow() {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.height / 112),
      child: TextFormField(
          focusNode: emailFocusNode,
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) {
            //emailLabelText = "";
            setState(() {
              email = value;
            });
          },
          decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.email,
                color: mainColor,
              ),
              labelText: emailLabelText),
          //autovalidate: true,
          validator: (value) {
            if (value.isEmpty ||
                !RegExp(r'^[a-zA-Z0-9.]+\@pasteur\.sn$').hasMatch(value)) {
              return "entrer une adresse email valide";
            } else {
              return null;
            }
          }),
    );
  }

  Widget _buildPasswordRow() {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.height / 112),
      child: TextFormField(
          focusNode: passwordFocusNode,
          keyboardType: TextInputType.text,
          obscureText: true,
          onChanged: (value) {
            setState(() {
              password = value;
            });
          },
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.lock,
              color: mainColor,
            ),
            labelText: passwordLabelText,
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

  Widget _buildForgetPasswordButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => ResetPasswordPage()));
          },
          child: InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => ResetPasswordPage()));
              },
              child: Text("Mot de passe oublié ?",
                  style: TextStyle(color: mainColor))),
        ),
      ],
    );
  }

  showloginSpinner(BuildContext context) {
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

  Widget _buildLoginButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 1.4 * (MediaQuery.of(context).size.height / 20),
          width: 5 * (MediaQuery.of(context).size.width / 10),
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height / 44.8),
          child: RaisedButton(
            elevation: 5.0,
            color: mainColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            onPressed: () async {
              try {
                final result = await InternetAddress.lookup('google.com');
                if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                  if (_formKey.currentState.validate()) {
                    dynamic user = {"email": email, "password": password};
                    String userData = jsonEncode(user);
                    showloginSpinner(context);
                    connectUser(context, userData).then((response) {
                      if (response.statusCode == 200) {
                        Map<String, dynamic> data = jsonDecode(response.body);
                        dynamic token = data["token"];
                        Map<String, dynamic> decodedData = Jwt.parseJwt(token);
                        String name = decodedData["first_name"] +
                            " " +
                            decodedData["last_name"];
                        String email = decodedData["email"];
                        bool isLoggedIn = true;
                        print(decodedData);
                        String idUser = decodedData["id_user"];
                        savePref(name, email, token, isLoggedIn, idUser);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (BuildContext context) => HomePage()));
                      } else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CustomDialogBox(
                                title: "Erreur lors de la connexion",
                                descriptions:
                                    "Adresse email ou mot de passe incorrect.",
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
                fontSize: MediaQuery.of(context).size.height / 40,
              ),
            ),
          ),
        )
      ],
    );
  }

  final _formKey = GlobalKey<FormState>();
  Widget _buildContainer() {
    return Form(
      key: _formKey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Connexion",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height / 30,
                        ),
                      ),
                    ],
                  ),
                  Flexible(child: _buildEmailRow()),
                  Flexible(child: _buildPasswordRow()),
                  Flexible(child: _buildForgetPasswordButton()),
                  Flexible(child: _buildLoginButton()),
                  Flexible(child: _buildSignUpBtn())
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpBtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 22.4),
            child: FlatButton(
              onPressed: () {
                Navigator.pushNamed(context, '/SignUp');
              },
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: 'Pas de compte? ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: MediaQuery.of(context).size.height / 50,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextSpan(
                    text: 'Inscrivez-vous',
                    style: TextStyle(
                      color: mainColor,
                      fontSize: MediaQuery.of(context).size.height / 50,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ]),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Color(0xfff2f3f7),
        body: ListView(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.9,
              width: MediaQuery.of(context).size.width,
              child: Container(
                decoration: BoxDecoration(
                  color: mainColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: const Radius.circular(70),
                    bottomRight: const Radius.circular(70),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildLogo(),
                    _buildContainer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String _token;
  String email, password, lastName, firstName, team;
  dynamic telephone;
  String firstNameLabelText = 'Prenom',
      lastNameLabelText = 'Nom',
      emailLabelText = "E-mail",
      phoneLabelText = "Telephone";

  FocusNode emailFocusNode,
      lastNameFocusNode,
      firstNameFocusNode,
      phoneFocusNode;

  void userInfosLoader() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = (prefs.getString('token') ?? '');
    });
  }

  @override
  void initState() {
    super.initState();
    team = teamList[0];
    emailFocusNode = new FocusNode();
    lastNameFocusNode = new FocusNode();
    firstNameFocusNode = new FocusNode();
    phoneFocusNode = new FocusNode();
    emailFocusNode.addListener(() {
      if (!emailFocusNode.hasFocus) {
        setState(() {
          emailLabelText = "E-mail";
        });
      } else {
        setState(() {
          emailLabelText = "";
        });
      }
    });
    lastNameFocusNode.addListener(() {
      if (!lastNameFocusNode.hasFocus) {
        setState(() {
          lastNameLabelText = "Nom";
        });
      } else {
        setState(() {
          lastNameLabelText = "";
        });
      }
    });
    firstNameFocusNode.addListener(() {
      if (!firstNameFocusNode.hasFocus) {
        setState(() {
          firstNameLabelText = "Prenom";
        });
      } else {
        setState(() {
          firstNameLabelText = "";
        });
      }
    });
    phoneFocusNode.addListener(() {
      if (!phoneFocusNode.hasFocus) {
        setState(() {
          phoneLabelText = "Telephone";
        });
      } else {
        setState(() {
          phoneLabelText = "";
        });
      }
    });
    userInfosLoader();
  }

  Widget _buildLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height / 70),
        )
      ],
    );
  }

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

  Widget _buildFirstNameRow() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextFormField(
          focusNode: firstNameFocusNode,
          keyboardType: TextInputType.text,
          onChanged: (value) {
            //firstNameLabelText = "";
            setState(() {
              firstName = value;
            });
          },
          decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.border_color,
                color: mainColor,
              ),
              labelText: firstNameLabelText),
          //autovalidate: true,
          validator: (value) {
            if (value.isEmpty || !RegExp(r'^[a-zA-Zç]+$').hasMatch(value)) {
              return "entrer un prénom valide";
            } else {
              return null;
            }
          }),
    );
  }

  Widget _buildLastNameRow() {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.height / 112),
      child: TextFormField(
          focusNode: lastNameFocusNode,
          keyboardType: TextInputType.text,
          onChanged: (value) {
            setState(() {
              lastName = value;
            });
          },
          decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.border_color,
                color: mainColor,
              ),
              labelText: lastNameLabelText),
          validator: (value) {
            if (value.isEmpty || !RegExp(r'^[a-zA-Zç]+$').hasMatch(value)) {
              return "entrer un nom valide";
            } else {
              return null;
            }
          }),
    );
  }

  Widget _buildTelephoneRow() {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.height / 112),
      child: TextFormField(
          focusNode: phoneFocusNode,
          keyboardType: TextInputType.phone,
          onChanged: (value) {
            setState(() {
              telephone = value;
            });
          },
          decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.call,
                color: mainColor,
              ),
              labelText: phoneLabelText),
          validator: (value) {
            if (value.isEmpty ||
                !RegExp(r'^(\+221)?[- ]?(77|70|76|78)[- ]?([0-9]{3})[- ]?([0-9]{2}[- ]?){2}$')
                    .hasMatch(value)) {
              return "entrer un numéro valide";
            } else {
              return null;
            }
          }),
    );
  }

  Widget _buildEmailRow() {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.height / 112),
      child: TextFormField(
          focusNode: emailFocusNode,
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) {
            setState(() {
              email = value;
            });
          },
          decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.email,
                color: mainColor,
              ),
              labelText: 'E-mail'),
          validator: (value) {
            if (value.isEmpty ||
                !RegExp(r'^[a-zA-Z0-9.]+\@pasteur\.sn$').hasMatch(value)) {
              return "entrer une adresse email valide";
            } else {
              return null;
            }
          }),
    );
  }

  Widget _buildPasswordRow() {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.height / 112),
      child: TextFormField(
          keyboardType: TextInputType.text,
          obscureText: true,
          onChanged: (value) {
            setState(() {
              password = value;
            });
          },
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.lock,
              color: mainColor,
            ),
            labelText: 'Mot de passe',
          ),
          validator: (value) {
            if (value.length < 8) {
              return "mot de passe trop court";
            } else if (value.isEmpty ||
                !RegExp(r'^(?=.*?[a-z])(?=.*?[0-9]).{8,}$').hasMatch(value)) {
              return "Doit contenir au moins un chiffre";
            } else {
              return null;
            }
          }),
    );
  }

  Widget _buildSignUpButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 1.4 * (MediaQuery.of(context).size.height / 20),
          width: 5 * (MediaQuery.of(context).size.width / 10),
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height / 44.8),
          child: RaisedButton(
            elevation: 5.0,
            color: mainColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            onPressed: () async {
              try {
                final result = await InternetAddress.lookup('google.com');
                if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                  if (_formKey.currentState.validate()) {
                    dynamic user = {
                      "email": email,
                      "password": password,
                      "first_name": firstName,
                      "last_name": lastName,
                      "telephone": telephone,
                      "team": team,
                    };
                    String userData = jsonEncode(user);
                    showSpinner(context);
                    saveUser(context, userData, _token).then((response) {
                      if (response.statusCode == 201) {
                        Map<String, dynamic> data = jsonDecode(response.body);
                        print(data);
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return SuccessDialogBox(
                                title: "Inscription réussie",
                                descriptions:
                                    "votre compte a été créé avec succès",
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
                                descriptions: data["response"],
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
              "S'inscrire",
              style: TextStyle(
                color: Colors.white,
                letterSpacing: 1.5,
                fontSize: MediaQuery.of(context).size.height / 40,
              ),
            ),
          ),
        )
      ],
    );
  }

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

  Widget _buildTeamRow() {
    return Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.height / 112),
        child: Container(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.height / 60,
              right: MediaQuery.of(context).size.height / 60),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1),
              borderRadius: BorderRadius.circular(15)),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.06,
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

  Widget _buildContainer() {
    return Form(
      key: _formKey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(""),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Inscription",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height / 30,
                        ),
                      ),
                    ],
                  ),
                  _buildFirstNameRow(),
                  _buildLastNameRow(),
                  _buildEmailRow(),
                  _buildPasswordRow(),
                  _buildTelephoneRow(),
                  _buildTeamRow(),
                  _buildSignUpButton()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Color(0xfff2f3f7),
        appBar: AppBar(
          title: Text("IPD-GIS"),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: ListView(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              child: Container(
                decoration: BoxDecoration(
                  color: mainColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: const Radius.circular(70),
                    bottomRight: const Radius.circular(70),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[_buildLogo(), _buildContainer(), Text("")],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
