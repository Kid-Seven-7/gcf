import 'login.dart';
import 'dart:async';
import 'alert_popups.dart';
import 'notifications.dart';
import 'package:uuid/uuid.dart';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gcf_projects_app/backend/mail_engine.dart';
import 'package:gcf_projects_app/backend/database_engine.dart';

class CodeReset extends StatefulWidget {
  _CodeResetState createState() => _CodeResetState();
}

class _CodeResetState extends State<CodeReset> {
  var codeController = new TextEditingController();
  var newPasswordController = new TextEditingController();
  var confirmPasswordController = new TextEditingController();

  bool checkFields(String code, String newPassword, String confirmPassword) {
    return (code.isNotEmpty &&
        newPassword.isNotEmpty &&
        confirmPassword.isNotEmpty);
  }

  Future<bool> doesCodeMatch(String code) async {
    bool codeMatches = false;
    await Firestore.instance
        .collection("users")
        .reference()
        .where("reset-code", isEqualTo: code)
        .getDocuments()
        .then((onValue) {
      var _data = onValue.documents;
      if (_data.length > 0) codeMatches = true;
    }).catchError((onError) {
      print("Error found::Code::7HY45R:: $onError");
    });
    return codeMatches;
  }

  bool doesPasswordMatch(String newPassword, String confirmPassword) {
    return (newPassword == confirmPassword);
  }

  String createHash(String newPassword) {
    DBCrypt dbCrypt = new DBCrypt();
    String _salt = dbCrypt.gensalt();
    return dbCrypt.hashpw(newPassword, _salt);
  }

  void updatePassword(String code, Map<String, String> password) async {
    await Firestore.instance
        .collection("users")
        .reference()
        .where("reset-code", isEqualTo: code)
        .getDocuments()
        .then((onValue) async {
      var _data = onValue.documents;
      var _docID = _data[0].documentID;
      await Firestore.instance
          .collection("users")
          .document(_docID)
          .updateData(password)
          .catchError((onError) {
        print("Error Found::Error Code::84DJ3N3::$onError");
      });
    }).catchError((onError) {
      print("Error found::Error Code::8FNGH3D::$onError");
    });
  }

  String changeResetCode(){
    var _code = new Uuid();
    return _code.v4().toString().substring(0, 8);
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
                          "Enter code and new password",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                        ),
                        TextField(
                          controller: codeController,
                          decoration: InputDecoration(hintText: 'Reset Code'),
                          maxLengthEnforced: true,
                          maxLength: 8,
                        ),
                        TextField(
                          controller: newPasswordController,
                          decoration: InputDecoration(hintText: 'New Password'),
                        ),
                        TextField(
                          controller: confirmPasswordController,
                          decoration:
                              InputDecoration(hintText: 'Confirm Password'),
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                        ),
                        FlatButton(
                          color: Color.fromARGB(255, 140, 188, 63),
                          child: Text('Update Password'),
                          onPressed: () async {
                            //Checking if all fields are all in there
                            if (checkFields(
                                codeController.text,
                                newPasswordController.text,
                                confirmPasswordController.text)) {
                              //Checking if the code exists in the database
                              bool codeFound =
                                  await doesCodeMatch(codeController.text);
                              if (codeFound) {
                                //Checking if passwords match
                                if (doesPasswordMatch(
                                    newPasswordController.text,
                                    confirmPasswordController.text)) {
                                  DataBaseEngine dataBaseEngine =
                                      new DataBaseEngine();
                                  Map _newPassword = new Map<String, String>();
                                  String _newHashedPassword =
                                      createHash(newPasswordController.text);
                                  _newPassword['password'] = _newHashedPassword;
                                  _newPassword['reset-code'] = changeResetCode();
                                  updatePassword(
                                      codeController.text, _newPassword);
                                  codeSentPopup(
                                      context,
                                      "Password Updated",
                                      "Your password has been reset and updated successfully",
                                      "reset-done");
                                } else {
                                  popUpInfo(context, "Error",
                                      "Password doesn't match. Make sure the confirmation password matches the new password.");
                                }
                              } else {
                                popUpInfo(context, "Error",
                                    "Code provided is invalid. Please check if the code you entered matches the one sent to you via email and try again");
                              }
                            } else {
                              popUpInfo(context, "Error",
                                  "Empty fields found. Please fill up all the fields before clicking Update Password.");
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
