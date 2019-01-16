import 'dart:async';
import 'alert_popups.dart';
import 'package:flutter/material.dart';
import 'package:gcf_projects_app/backend/mail_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Forgot extends StatefulWidget {
  @override
  State createState() => new ForgotState();
}

class ForgotState extends State<Forgot> {
  var emailController = new TextEditingController();

  bool checkField(String email) {
    return email.isNotEmpty;
  }

  Future<bool> checkEmailExists(String email) async {
    bool isFound = false;

    await Firestore.instance
        .collection("users")
        .reference()
        .where("email", isEqualTo: email)
        .getDocuments()
        .then((onValue) {
      var _data = onValue.documents;

      if (_data.length > 0) isFound = true;
    }).catchError((onError) {
      print("Error found::Error::AKJDHSG4:: $onError");
    });

    return isFound;
  }

  String createCode() {
    var _code = new Uuid();

    return _code.v4().toString().substring(0, 8);
  }

  void sendCode(String email, String code) {
    MailEngine mailEngine = new MailEngine();
    mailEngine.sendMail(
        email,
        "Hello GCF APP USER!," +
            "\nTo reset your account use this code:\n" +
            "\nCODE: $code",
        "GCF ACCOUNT RESET CODE",
        "9MHF6HB");
  }

  void writeCodeToDb(String email, String code) async {
    await Firestore.instance
        .collection("users")
        .reference()
        .where("email", isEqualTo: email)
        .getDocuments()
        .then((onValue) async {
      var _data = onValue.documents;
      var _docID = _data[0].documentID;
      Map _code = new Map<String, String>();
      _code['reset-code'] = code;
      await Firestore.instance
          .collection("users")
          .document(_docID)
          .updateData(_code)
          .catchError((onError) {});
    }).catchError((onError) {
      print("Updating code failed.");
    });
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
                  height: 90,
                  width: 90),
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
                    padding: const EdgeInsets.all(30.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Padding(
                          padding: const EdgeInsets.only(top: 0.0),
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                        ),
                        new Text(
                          "Please enter the email associated with your account to reset.",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                        ),
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(hintText: 'Email'),
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                        ),
                        FlatButton(
                          color: Color.fromARGB(255, 140, 188, 63),
                          child: Text('Reset'),
                          onPressed: () async {
                            //Check if email field is not empty
                            if (checkField(emailController.text)) {
                              //check if emails exits in the database
                              bool emailExists =
                                  await checkEmailExists(emailController.text);
                              if (emailExists) {
                                String _code = createCode();
                                sendCode(emailController.text, _code);
                                writeCodeToDb(emailController.text, _code);
                                codeSentPopup(context, "Reset Code Sent", "An email with the reset code has been sent to your account. Use it to reset your accout password.", "to-reset");
                              } else {
                                popUpInfo(context, "Error",
                                    "The email you provided doesn't exist in our database. Please check your email and try again.");
                              }
                            } else {
                              popUpInfo(context, "Error",
                                  "Please enter your email first before pressing the reset button.");
                            }
                          },
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          splashColor: Colors.white,
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
