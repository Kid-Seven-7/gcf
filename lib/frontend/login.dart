import 'package:flutter/material.dart';
import 'package:gcf_projects_app/backend/globals.dart';
import '../backend/login_engine.dart';
import '../backend/database_engine.dart';
import 'package:dbcrypt/dbcrypt.dart';
import 'add_user.dart';
import 'alert_popups.dart';

LoginEngine loginEngine = new LoginEngine();

class LoginPage extends StatefulWidget {
  @override
  State createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  AnimationController _iconAnimationController;
  Animation<double> _iconAnimation;
  bool _checked = false;

  void onChanged(bool value) {
    setState(() {
      _checked = value;
    });
  }

  final textName = new TextEditingController();
  final textPassword = new TextEditingController();

  DBCrypt dBCrypt = DBCrypt();

  @override
  void dispose() {
    textName.dispose();
    textPassword.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _iconAnimationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 1000));

    _iconAnimation = new CurvedAnimation(
      parent: _iconAnimationController,
      curve: Curves.easeIn,
    );
    _iconAnimation.addListener(() => this.setState(() {}));
    _iconAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Image(
            image: new AssetImage("assets/images/login_back.png"),
            fit: BoxFit.cover,
            color: Colors.black87,
            colorBlendMode: BlendMode.darken,
          ),
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Image(
                image: new AssetImage("assets/images/GCF-logo.png"),
                height: _iconAnimation.value * 86,
                width: _iconAnimation.value * 90,
              ),
              new Form(
                child: Theme(
                  data: ThemeData(
                    brightness: Brightness.dark,
                    primarySwatch: Colors.green,
                    inputDecorationTheme: new InputDecorationTheme(
                        labelStyle: new TextStyle(
                      color: Color.fromARGB(255, 140, 188, 63),
                      fontSize: 18.0,
                    )),
                  ),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(30.0, 20.0, 20.0, 0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new TextFormField(
                          decoration: new InputDecoration(labelText: "Name"),
                          keyboardType: TextInputType.text,
                          controller: textName,
                        ),
                        new TextFormField(
                          decoration:
                              new InputDecoration(labelText: "Password"),
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          controller: textPassword,
                        ),
                        new Row(
                          children: <Widget>[
                            new Text(
                              "Remember me",
                              style: TextStyle(color: Colors.white),
                            ),
                            new Checkbox(
                              value: _checked,
                              onChanged: (bool value) {
                                onChanged(value);
                                if (value) {
                                  rememberMe = "yes";
                                } else {
                                  rememberMe = "no";
                                }
                              },
                              activeColor: Color.fromARGB(255, 140, 188, 63),
                            )
                          ],
                        ),
                        new FlatButton(
                          color: Color.fromARGB(255, 140, 188, 63),
                          child: new Text("Login"),
                          onPressed: () {
                            if (loginEngine.checkLogin(
                                textName.text, textPassword.text)) {
                              loginEngine.checkUser(
                                  textName.text, textPassword.text, context);
                            } else {
                              popUpInfo(context, "Error",
                                  "Fields can't be empty!. Please put your login name and password.");
                            }
                          },
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(60.0)),
                          splashColor: Colors.white,
                        ),
                        new Padding(
                          padding: EdgeInsets.only(top: 15),
                        ),
                        new MaterialButton(
                          color: Color.fromARGB(0, 0, 0, 0),
                          child: new Text("Create New Account"),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddUser()));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
