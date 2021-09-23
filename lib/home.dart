import 'package:flutter/material.dart';
import 'package:gisApp/main.dart';
import 'package:gisApp/theme/color/light_color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gisApp/menuController.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _name = "", _token = "";
  String _email = "";
  int _index = 0;
  double width;

  @override
  void initState() {
    super.initState();
    userInfosLoader();
  }

  void userInfosLoader() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = (prefs.getString('name') ?? '');
      _email = (prefs.getString('email') ?? '');
      _token = (prefs.getString('token') ?? '');
    });
  }

//DEBUT PAGE HOME:
  Widget _header(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return ClipRRect(
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50)),
      child: Container(
          height: MediaQuery.of(context).size.height / 7.57,
          width: width,
          decoration: BoxDecoration(
            color: LightColor.mainColor,
          ),
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                  top: MediaQuery.of(context).size.height / 29.87,
                  right: -MediaQuery.of(context).size.height / 8.96,
                  child: _circularContainer(300, LightColor.mainColor)),
              Positioned(
                  top: -MediaQuery.of(context).size.height / 8.96,
                  left: -MediaQuery.of(context).size.height / 19.91,
                  child: _circularContainer(width * .5, LightColor.mainColor)),
              Positioned(
                  top: -MediaQuery.of(context).size.height / 4.98,
                  right: -MediaQuery.of(context).size.height / 29.87,
                  child: _circularContainer(width * .7, Colors.transparent,
                      borderColor: Colors.white38)),
              Positioned(
                  top: MediaQuery.of(context).size.height / 20,
                  left: 0,
                  child: Container(
                      width: width,
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              MediaQuery.of(context).size.height / 44.8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height / 44.8),
                          Text(
                            "Bienvenue " + _name,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    MediaQuery.of(context).size.height / 42,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      )))
            ],
          )),
    );
  }

//Widget circular container
  Widget _circularContainer(double height, Color color,
      {Color borderColor = Colors.transparent, double borderWidth = 2}) {
    return Container(
      height: height,
      width: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(color: borderColor, width: borderWidth),
      ),
    );
  }

//premier row contenant les cards
  Widget _featuredRowA() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            _card(
                primary: LightColor.mainColor,
                backWidget: _decorationContainerA(
                    LightColor.mainColor,
                    MediaQuery.of(context).size.height / 17.92,
                    -MediaQuery.of(context).size.height / 29.87),
                chipColor: LightColor.mainColor,
                chipText1: "Nouveau rapport",
                chipText2: "",
                iconTop: MediaQuery.of(context).size.height / 44.8,
                iconLeft: MediaQuery.of(context).size.height / 89.6,
                textCardBottom: MediaQuery.of(context).size.height / 89.6,
                textCardLeft: MediaQuery.of(context).size.height / 89.6,
                h: MediaQuery.of(context).size.height / 4.5,
                w: MediaQuery.of(context).size.width * 0.42,
                page: "report",
                imgPath: "assets/images/document.png"),
            _card(
                primary: LightColor.mainColor,
                backWidget: _decorationContainerA(
                    LightColor.mainColor,
                    MediaQuery.of(context).size.height / 17.92,
                    -MediaQuery.of(context).size.height / 29.87),
                chipColor: LightColor.mainColor,
                chipText1: "Faire un commentaire",
                page: "comment",
                iconTop: MediaQuery.of(context).size.height / 44.8,
                iconLeft: MediaQuery.of(context).size.height / 89.6,
                textCardBottom: MediaQuery.of(context).size.height / 89.6,
                textCardLeft: MediaQuery.of(context).size.height / 89.6,
                h: MediaQuery.of(context).size.height / 4.5,
                w: MediaQuery.of(context).size.width * 0.42,
                chipText2: "",
                imgPath: "assets/images/message.png"),
          ],
        ),
      ),
    );
  }

//second row contenant les cards
  Widget _featuredRowB() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          //TODO mettre une boucle
          children: <Widget>[
            _card(
                primary: Colors.white,
                backWidget: _decorationContainerB(
                    LightColor.mainColor,
                    MediaQuery.of(context).size.height / 17.92,
                    -MediaQuery.of(context).size.height / 29.87),
                chipColor: LightColor.mainColor,
                chipText1: "Résumé",
                chipText2: "Date: 2021-09-08",
                chipText3: "plage: 2500-3000",
                chipText4: "heure: 10h00-18h00",
                iconTop: MediaQuery.of(context).size.height / 17.92,
                iconLeft: MediaQuery.of(context).size.height / 4.48,
                textCardBottom: MediaQuery.of(context).size.height / 12.8,
                textCardLeft: MediaQuery.of(context).size.height / 29.87,
                h: MediaQuery.of(context).size.height / 3.9,
                w: MediaQuery.of(context).size.width * 0.7,
                isPrimaryCard: true,
                textColor: Colors.black,
                isReport: true),
            _card(
                primary: Colors.white,
                backWidget: _decorationContainerB(
                    LightColor.mainColor,
                    MediaQuery.of(context).size.height / 17.92,
                    -MediaQuery.of(context).size.height / 29.87),
                chipColor: LightColor.mainColor,
                chipText1: "Résumé",
                chipText2: "Date: 2021-09-08",
                chipText3: "plage: 2500-3000",
                chipText4: "heure: 10h00-18h00",
                iconTop: MediaQuery.of(context).size.height / 17.92,
                iconLeft: MediaQuery.of(context).size.height / 4.48,
                textCardBottom: MediaQuery.of(context).size.height / 12.8,
                textCardLeft: MediaQuery.of(context).size.height / 29.87,
                h: MediaQuery.of(context).size.height / 3.9,
                w: MediaQuery.of(context).size.width * 0.7,
                isPrimaryCard: true,
                textColor: Colors.black,
                isReport: true),
            _card(
                primary: Colors.white,
                backWidget: _decorationContainerB(
                    LightColor.mainColor,
                    MediaQuery.of(context).size.height / 17.92,
                    -MediaQuery.of(context).size.height / 29.87),
                chipColor: LightColor.mainColor,
                chipText1: "Résumé",
                chipText2: "Date: 2021-09-08",
                chipText3: "plage: 2500-3000",
                chipText4: "heure: 10h00-18h00",
                iconTop: MediaQuery.of(context).size.height / 17.92,
                iconLeft: MediaQuery.of(context).size.height / 4.48,
                textCardBottom: MediaQuery.of(context).size.height / 12.8,
                textCardLeft: MediaQuery.of(context).size.height / 29.87,
                h: MediaQuery.of(context).size.height / 3.9,
                w: MediaQuery.of(context).size.width * 0.7,
                isPrimaryCard: true,
                textColor: Colors.black,
                isReport: true),
            _card(
                primary: Colors.white,
                backWidget: _decorationContainerB(
                    LightColor.mainColor,
                    MediaQuery.of(context).size.height / 17.92,
                    -MediaQuery.of(context).size.height / 29.87),
                chipColor: LightColor.mainColor,
                chipText1: "Résumé",
                chipText2: "Date: 2021-09-08",
                chipText3: "plage: 2500-3000",
                chipText4: "heure: 10h00-18h00",
                iconTop: MediaQuery.of(context).size.height / 17.92,
                iconLeft: MediaQuery.of(context).size.height / 4.48,
                textCardBottom: MediaQuery.of(context).size.height / 12.8,
                textCardLeft: MediaQuery.of(context).size.height / 29.87,
                h: MediaQuery.of(context).size.height / 3.9,
                w: MediaQuery.of(context).size.width * 0.7,
                isPrimaryCard: true,
                textColor: Colors.black,
                isReport: true),
            _card(
                primary: Colors.white,
                backWidget: _decorationContainerB(
                    LightColor.mainColor,
                    MediaQuery.of(context).size.height / 17.92,
                    -MediaQuery.of(context).size.height / 29.87),
                chipColor: LightColor.mainColor,
                chipText1: "Résumé",
                chipText2: "Date: 2021-09-08",
                chipText3: "plage: 2500-3000",
                chipText4: "heure: 10h00-18h00",
                iconTop: MediaQuery.of(context).size.height / 17.92,
                iconLeft: MediaQuery.of(context).size.height / 4.48,
                textCardBottom: MediaQuery.of(context).size.height / 12.8,
                textCardLeft: MediaQuery.of(context).size.height / 29.87,
                h: MediaQuery.of(context).size.height / 3.9,
                w: MediaQuery.of(context).size.width * 0.7,
                isPrimaryCard: true,
                textColor: Colors.black,
                isReport: true),
          ],
        ),
      ),
    );
  }

//LES WIDGETS A MODIFIER : DEBUT
//Widget catégorie row
  Widget _categoryRow(
    String title,
    Color primary,
    Color textColor,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.height / 44.8),
      height: MediaQuery.of(context).size.height / 29.87,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                color: LightColor.titleTextColor, fontWeight: FontWeight.bold),
          ),
          // _chip("voir tout", primary)
        ],
      ),
    );
  }

  Widget _card(
      {Color primary = Colors.redAccent,
      String imgPath,
      String chipText1 = '',
      String chipText2 = '',
      String chipText3 = '',
      String chipText4 = '',
      double h,
      double w,
      double iconTop,
      double iconLeft,
      Widget backWidget,
      dynamic page,
      bool isReport = false,
      double textCardBottom,
      double textCardLeft,
      Color textColor = Colors.white,
      Color chipColor = LightColor.orange,
      bool isPrimaryCard = false}) {
    return AnimatedContainer(
      duration: const Duration(seconds: 500),
      curve: Curves.easeIn,
      child: InkWell(
        //les couleurs par défaut pour le comportement
        // splashColor: Colors.transparent,
        // highlightColor: Colors.transparent,
        // hoverColor: Colors.transparent,
        onTap: () {
          setState(() {});
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MenuController(page)),
          );
        },
        child: Container(
            height: h,
            width: w,
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.height / 59.73,
                vertical: MediaQuery.of(context).size.height / 44.8),
            decoration: BoxDecoration(
                color: primary.withAlpha(200),
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      offset: Offset(0, 2),
                      spreadRadius: 1,
                      blurRadius: 1,
                      color: Colors.grey)
                ]),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              child: Container(
                child: Stack(
                  children: <Widget>[
                    backWidget,
                    Positioned(
                        top: iconTop,
                        left: iconLeft,
                        child: isReport
                            ? ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(20.0), //or 15.0
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height / 12.8,
                                  width:
                                      MediaQuery.of(context).size.height / 12.8,
                                  color: LightColor.mainColor,
                                  child: Icon(Icons.description,
                                      color: Colors.white,
                                      size: MediaQuery.of(context).size.height /
                                          17.92),
                                ),
                              )
                            : CircleAvatar(
                                radius: MediaQuery.of(context).size.height / 30,
                                backgroundColor: LightColor.mainColor,
                                backgroundImage: AssetImage(imgPath))),
                    //C'est le container des textes
                    Positioned(
                      bottom: textCardBottom,
                      left: textCardLeft,
                      child: _cardInfo(chipText1, chipText2, chipText3,
                          chipText4, textColor, chipColor, isReport,
                          isPrimaryCard: isPrimaryCard),
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }

  Widget _cardInfo(String title, String date, String heure, String plage,
      Color textColor, Color primary, isReport,
      {bool isPrimaryCard = false}) {
    return isReport
        ? Align(
            alignment: Alignment.bottomLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                      right: MediaQuery.of(context).size.height / 179.2),
                  width: width * .40,
                  alignment: Alignment.topCenter,
                  child: Text(
                    title,
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height / 49.78,
                        fontWeight: FontWeight.bold,
                        color: textColor),
                  ),
                ),
                SizedBox(height: 5),
                isReport
                    ? _chip(
                        date,
                        primary,
                        Colors.white,
                        MediaQuery.of(context).size.height / 49.78,
                        Alignment.center,
                        true,
                        height: MediaQuery.of(context).size.height / 179.2,
                        isPrimaryCard: isPrimaryCard)
                    : null,
                SizedBox(height: MediaQuery.of(context).size.height / 179.2),
                isReport
                    ? _chip(
                        heure,
                        primary,
                        Colors.white,
                        MediaQuery.of(context).size.height / 49.78,
                        Alignment.center,
                        true,
                        height: MediaQuery.of(context).size.height / 179.2,
                        isPrimaryCard: isPrimaryCard)
                    : null,
                SizedBox(height: MediaQuery.of(context).size.height / 179.2),
                isReport
                    ? _chip(
                        plage,
                        primary,
                        Colors.white,
                        MediaQuery.of(context).size.height / 49.78,
                        Alignment.center,
                        true,
                        height: MediaQuery.of(context).size.height / 179.2,
                        isPrimaryCard: isPrimaryCard)
                    : null,
              ],
            ),
          )
        : Align(
            alignment: Alignment.bottomLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                      right: MediaQuery.of(context).size.height / 179.2),
                  width: width * .40,
                  alignment: Alignment.topCenter,
                  child: Text(
                    title,
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height / 49.78,
                        fontWeight: FontWeight.bold,
                        color: textColor),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 29.87)
              ],
            ),
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
        //border: Border.all(color: Color(0xff1e3799), width: 2),
        color:
            isProfilePage ? bcolor.withAlpha(isPrimaryCard ? 200 : 50) : null,
      ),
      child: Text(
        text,
        style: TextStyle(color: textColor, fontSize: fontSize),
      ),
    );
  }

// Décoration containers
  Widget _decorationContainerA(Color primary, double top, double left) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: top,
          left: left,
          child: CircleAvatar(
            maxRadius: MediaQuery.of(context).size.height / 1.792,
            backgroundColor: primary.withAlpha(255),
          ),
        ),
        _smallContainer(primary, 20, 90),
        Positioned(
          top: MediaQuery.of(context).size.height / 44.8,
          right: -MediaQuery.of(context).size.height / 29.87,
          child: _circularContainer(0, Colors.transparent,
              borderColor: Colors.white),
        )
      ],
    );
  }

//Pour les rapports récents
//card1
  Widget _decorationContainerB(Color primary, double top, double left) {
    return Stack(
      children: <Widget>[
        //le cercle bleu en bas
        _smallContainer(primary, MediaQuery.of(context).size.height / 4.48,
            MediaQuery.of(context).size.height / 9.96),
        Positioned(
          top: MediaQuery.of(context).size.height / 44.8,
          right: -MediaQuery.of(context).size.height / 29.87,
          //le trait blanc circulaire
          child: _circularContainer(
              MediaQuery.of(context).size.height / 8.96, Colors.transparent,
              borderColor: Colors.white),
        )
      ],
    );
  }

  Positioned _smallContainer(Color primary, double top, double left,
      {double radius = 10}) {
    //TODO revoir le passage de paramètres pour toutes les instances
    return Positioned(
        top: top,
        left: left,
        child: CircleAvatar(
          radius: radius,
          backgroundColor: primary.withAlpha(255),
        ));
  }

  Widget _containerHome() {
    return SingleChildScrollView(
        child: Container(
      child: Column(
        children: <Widget>[
          _header(context),
          SizedBox(height: MediaQuery.of(context).size.height / 44.8),
          _categoryRow("Menu", LightColor.mainColor, LightColor.mainColor),
          _featuredRowA(),
          SizedBox(height: MediaQuery.of(context).size.height / 89.6),
          _categoryRow(
              "rapports récents", LightColor.mainColor, LightColor.mainColor),
          SizedBox(height: MediaQuery.of(context).size.height / 44.8),
          _featuredRowB()
        ],
      ),
    ));
  }
//FIN PAGE HOME:

//DEBUT PAGE PROFILE:

  String email, password;
  String emailLabelText = "E-mail", passwordLabelText = "Mot de passe";
  Widget _buildLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height / 22.4),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50.0),
              child: Container(
                height: MediaQuery.of(context).size.height / 8.96,
                width: MediaQuery.of(context).size.height / 8.96,
                color: Colors.white,
                child: Icon(LineIcons.user,
                    color: LightColor.mainColor,
                    size: MediaQuery.of(context).size.height / 11.2),
              ),
            ))
      ],
    );
  }

  Widget _buildEmailRow() {
    return Container(
      padding: EdgeInsets.all(MediaQuery.of(context).size.height / 112),
      child: _chip("Email : " + _email, LightColor.mainColor, Color(0xff1e3799),
          MediaQuery.of(context).size.height / 40, Alignment.centerLeft, false,
          height: MediaQuery.of(context).size.height / 74.7,
          isPrimaryCard: true),
    );
  }

  Widget _buildNameRow() {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.height / 112),
      child: _chip("Nom : " + _name, LightColor.mainColor, Color(0xff1e3799),
          MediaQuery.of(context).size.height / 40, Alignment.centerLeft, false,
          height: MediaQuery.of(context).size.height / 74.7,
          isPrimaryCard: true),
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
              child: Text("traitement en cours...")),
        ],
      ),
    );
    showDialog(
      //barrierDismissible: false,
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
                //handle update process
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
  //handle logout process

  logoutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    prefs.setBool("isLoggedIn", false);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginPage()),
        (Route<dynamic> route) => false);
    return true;
  }

  Widget _buildLogoutButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 1.4 * (MediaQuery.of(context).size.height / 30),
          width: 5 * (MediaQuery.of(context).size.width / 10.3),
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height / 44.8),
          child: RaisedButton(
            elevation: 5.0,
            color: Color(0xffa4b0be),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            onPressed: () async {
              await logoutUser();
            },
            child: InkWell(
              onTap: () async {
                await logoutUser();
              },
              child: Row(
                children: <Widget>[
                  Text(
                    "Deconnexion ",
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 1.5,
                      fontSize: MediaQuery.of(context).size.height / 45,
                    ),
                  ),
                  Icon(Icons.no_encryption,
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
              height: MediaQuery.of(context).size.height * 0.4,
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
                        "Vos informations",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height / 35,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff1e3799),
                          //decoration: TextDecoration.underline
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 44.8),
                  Container(
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        border: Border.all(color: Color(0xff1e3799), width: 2),
                      ),
                      child: Column(
                        children: <Widget>[
                          _buildEmailRow(),
                          _buildNameRow(),
                        ],
                      )),
                  SizedBox(height: 10),
                  Flexible(child: _buildLoginButton()),
                  Flexible(child: _buildLogoutButton())
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileContainer() {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Color(0xfff2f3f7),
        body: ListView(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.8,
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

//FIN PAGE PROFILE:

//TODO Ajouter d'autre container pour les autres pages
  Widget _chooseTheRightOne(int index) {
    switch (index) {
      case 0:
        return _containerHome();
        break;
      case 1:
        return _profileContainer();
        break;
      default:
        return null;
    }
  }

  PageController controller = PageController();
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: PageView.builder(
          itemCount: 4,
          controller: controller,
          onPageChanged: (page) {
            setState(() {
              _index = page;
            });
          },
          itemBuilder: (context, position) {
            return _chooseTheRightOne(position);
          }),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.height / 44.8,
              vertical: MediaQuery.of(context).size.height / 179.2),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(100)),
              boxShadow: [
                BoxShadow(
                  spreadRadius: -10,
                  blurRadius: 60,
                  color: Colors.black.withOpacity(0.4),
                  offset: Offset(0, 25),
                )
              ]),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: GNav(
              curve: Curves.fastOutSlowIn,
              duration: Duration(milliseconds: 800),
              tabs: [
                GButton(
                  gap: MediaQuery.of(context).size.height / 89.6,
                  icon: LineIcons.home,
                  iconColor: LightColor.mainColor,
                  iconActiveColor: Colors.white,
                  text: 'Accueil',
                  textColor: Colors.white,
                  backgroundColor: LightColor.mainColor,
                  iconSize: MediaQuery.of(context).size.height / 37.3,
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.height / 49.78,
                      vertical: MediaQuery.of(context).size.height / 179.2),
                ),
                GButton(
                  gap: MediaQuery.of(context).size.height / 89.6,
                  icon: LineIcons.user,
                  iconColor: LightColor.mainColor,
                  iconActiveColor: Colors.white,
                  text: 'profil',
                  textColor: Colors.white,
                  backgroundColor: LightColor.mainColor,
                  iconSize: MediaQuery.of(context).size.height / 37.3,
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.height / 49.78,
                      vertical: MediaQuery.of(context).size.height / 179.2),
                ),
                GButton(
                  gap: MediaQuery.of(context).size.height / 89.6,
                  icon: Icons.description,
                  iconColor: LightColor.mainColor,
                  iconActiveColor: Colors.white,
                  text: 'rapports',
                  textColor: Colors.white,
                  backgroundColor: LightColor.mainColor,
                  iconSize: MediaQuery.of(context).size.height / 37.3,
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.height / 49.78,
                      vertical: MediaQuery.of(context).size.height / 179.2),
                ),
                GButton(
                  gap: MediaQuery.of(context).size.height / 89.6,
                  icon: Icons.search,
                  iconColor: LightColor.mainColor,
                  iconActiveColor: Colors.white,
                  text: 'autre',
                  textColor: Colors.white,
                  backgroundColor: LightColor.mainColor,
                  iconSize: MediaQuery.of(context).size.height / 37.3,
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.height / 49.78,
                      vertical: MediaQuery.of(context).size.height / 179.2),
                ),
              ],
              selectedIndex: _index,
              onTabChange: (index) {
                setState(() {
                  _index = index;
                });
                controller.jumpToPage(index);
              },
            ),
          ),
        ),
      ),
    );
  }
}
