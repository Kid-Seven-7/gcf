import 'package:flutter/material.dart';
import 'package:gcf_projects_app/globals.dart';
import 'login_engine.dart';
import 'database_engine.dart';
import 'package:dbcrypt/dbcrypt.dart';
import 'add_user.dart';

class LoginPage extends StatefulWidget {
  @override
  State createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  AnimationController _iconAnimationController;
  Animation<double> _iconAnimation;

  final textName = new TextEditingController();
  final textPassword = new TextEditingController();

  DBCrypt dBCrypt = DBCrypt();
  LoginEngine loginEngine = new LoginEngine();
  DataBaseEngine dataBaseEngine = new DataBaseEngine();

  @override
  void dispose() {
    textName.dispose();
    textPassword.dispose();
    super.dispose();
  }

  @override
  void initState() {
    //TEST
    pageNumber += 1;
    print('Login Page Number: $pageNumber');
    //TEST
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
                height: _iconAnimation.value * 100,
                width: _iconAnimation.value * 100,
              ),
              new Form(
                child: Theme(
                  data: ThemeData(
                    brightness: Brightness.dark,
                    primarySwatch: Colors.green,
                    inputDecorationTheme: new InputDecorationTheme(
                        labelStyle: new TextStyle(
                      color: Color.fromARGB(255, 140, 188, 63),
                      fontSize: 20.0,
                    )),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(40.0),
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
                        new Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                        ),
                        new MaterialButton(
                          color: Color.fromARGB(255, 140, 188, 63),
                          child: new Text("Login"),
                          onPressed: () {
                            if (loginEngine.checkLogin(
                                textName.text, textPassword.text)) {
                              var hash = dBCrypt.hashpw(
                                  textPassword.text, dBCrypt.gensalt());
                              print(hash);
                              dataBaseEngine.checkUser(
                                  textName.text, textPassword.text, context);
                            } else {
                              print("Do an awesome popup");
                            }
                          },
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(70.0)),
                          splashColor: Colors.white,
                        ),
                        new MaterialButton(
                          color: Color.fromARGB(0, 0, 0, 0),
                          child: new Text("Create New Account"),
                          onPressed: (){
                          Navigator.push(
                            context, MaterialPageRoute(builder: (context) => AddUser()));
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
