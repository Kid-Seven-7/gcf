
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD:lib/login.dart
import 'package:gcf_projects_app/add_user.dart';
import 'package:gcf_projects_app/globals.dart';

=======
import 'package:gcf_projects_app/backend/globals.dart';
import '../backend/login_engine.dart';
import '../backend/database_engine.dart';
>>>>>>> origin/jmkhosi:lib/frontend/login.dart
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
  final textEmail = new TextEditingController();

  DBCrypt dBCrypt = DBCrypt();

  //Regex allowed characters
  static final RegExp nameRegExp = RegExp('[a-zA-Z]');

  //  _formKey and _autoValidate
  final formKey = GlobalKey<FormState>();
  bool autoValidate = false;


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
                height: _iconAnimation.value * 90,
                width: _iconAnimation.value * 90,
              ),
              new Form(
                key: formKey,
                autovalidate: autoValidate,
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
                    padding: const EdgeInsets.all(30.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new TextFormField(
                          decoration: new InputDecoration(hintText: 'Enter your name', labelText: "Name", icon: Icon(Icons.person_outline)),
                          keyboardType: TextInputType.text,
                          controller: textName,

                          //Adding the validator to check the name inputs are correct.
                          validator: validateNameInputs,

                        ),
                        new TextFormField(
                          decoration: new InputDecoration(labelText: "Email", icon: Icon(Icons.mail_outline)),
                          keyboardType: TextInputType.text,
                          controller: textEmail,

                          onSaved: (val) => textEmail.text = val,

                          //Adding the validator to check the name inputs are correct.
                          validator: validateEmailInputs,
                        ),
                        new TextFormField(
                          decoration:
                          new InputDecoration(hintText: 'Enter your password', labelText: "Password",icon: Icon(Icons.lock_outline)),
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          controller: textPassword,

                          //Adding the validator to check the password inputs are correct.
                          validator: validatePasswordInputs,

                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                        ),
                        new FlatButton(
                          color: Color.fromARGB(255, 140, 188, 63),
                          child: new Text("Login"),
                          onPressed: () {
                            //If all the validation is correct save data
                            validateAndSaveInputs();

                            FirebaseAuth.instance.signInWithEmailAndPassword(email: textEmail.text, password: textPassword.text).then((FirebaseUser user){
                               Navigator.of(context).pushReplacementNamed('/homepage');
                            }).catchError((e){
                              print(e);
                            });

                            var hash = dBCrypt.hashpw(
                                textPassword.text, dBCrypt.gensalt());
                            print(hash);

                           /* if (loginEngine.checkLogin(
                                textName.text, textPassword.text)) {
                              var hash = dBCrypt.hashpw(
                                  textPassword.text, dBCrypt.gensalt());
                              print(hash);
                              dataBaseEngine.checkUser(
                                  textName.text, textPassword.text, context);
                            } else {
                              print("Do an awesome popup");
                            }*/

                          },
                          shape: new RoundedRectangleBorder(
<<<<<<< HEAD:lib/login.dart
                              borderRadius: new BorderRadius.circular(20.0)),
                          splashColor: Colors.white,
                        ),
                        new MaterialButton(
                        color: Color.fromARGB(0, 0, 0, 0),
                        child: new Text("Create New Account"),
                        onPressed: (){
                        Navigator.push(
                        context, MaterialPageRoute(builder: (context) => AddUser()));},
=======
                              borderRadius: new BorderRadius.circular(60.0)),
                          splashColor: Colors.white,
                        ),
                        new MaterialButton(
                          color: Color.fromARGB(0, 0, 0, 0),
                          child: new Text("Create New Account"),
                          onPressed: (){
                          Navigator.push(
                            context, MaterialPageRoute(builder: (context) => AddUser()));
                          },
>>>>>>> origin/jmkhosi:lib/frontend/login.dart
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }


  String validateEmailInputs(String value) {
    if (value.isEmpty)
      return 'Email can\'t be empty.';
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

bool validateAndSaveInputs() {

  if (formKey.currentState.validate()) {
//    If all data are correct then save data to our variables
    print('Form is Valid');
    formKey.currentState.save();
    return true;
  } else {
//    If all data are not valid then start auto validation.

      print('Form is Invalid');
      return false;
  }
}


  void validateAndSubmitInputs() {
    if (validateAndSaveInputs()) {

    }
  }

String validateNameInputs(String value) {
    if (value.isEmpty)
      return 'Name can\'t be empty.';
    if (value.length < 3)
      return 'Name can\'t be less than 2 charater.';
    if(!nameRegExp.hasMatch(value))
      return'Name must contain only letters (a-z||A-Z).';
  else
      return null;
  }

  String validatePasswordInputs(String value) {
    if (value.isEmpty)
      return 'Password can\'t be empty.';

    if (value.length < 8) {
      return 'The Password must be at least 8 characters.';
    }

    return null;
  }
}
