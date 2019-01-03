import 'login.dart';
import 'dart:async';
import 'alert_popups.dart';
import 'notifications.dart';
import 'package:flutter/material.dart';
import '../backend/database_engine.dart';

class AddUser extends StatefulWidget {
  @override
  State createState() => new AddUserState();
}

class AddUserState extends State<AddUser> {
  var nameController = new TextEditingController();
  var passwordController = new TextEditingController();
  var numberController = new TextEditingController();

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
                  height: 120,
                  width: 120),
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
                        new TextFormField(
                          decoration: new InputDecoration(labelText: "Name"),
                          keyboardType: TextInputType.text,
                          controller: nameController,
                        ),
                        new TextFormField(
                          decoration:
                              new InputDecoration(labelText: "Password"),
                          keyboardType: TextInputType.text,
                          controller: passwordController,
                          obscureText: true,
                        ),
                        new TextFormField(
                          decoration: new InputDecoration(labelText: "Number"),
                          keyboardType: TextInputType.number,
                          controller: numberController,
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                        ),
                        FlatButton(
                          color: Color.fromARGB(255, 140, 188, 63),
                          child: Text('Create Account'),
                          onPressed: () {
                            //Create a map
                            //Pass it to database_engine
                            DataBaseEngine databaseEngine =
                                new DataBaseEngine();

                            //Creating a map
                            var newUserData = databaseEngine.createMap(
                                nameController.text,
                                passwordController.text,
                                numberController.text);
                            if (databaseEngine.processData(newUserData)) {
                              String nameN = nameController.text;
                              String numberN = numberController.text;
                              
                              print('Pop up good');
                              sendMessage(context, "New User Request",
                                  "$nameN has requested permission to use the app. Phone number is $numberN");
                              popUpInfo(context, "Success",
                                  "Your account has been created.");
                              Timer(Duration(seconds: 3), () {
                                Navigator.of(context).pushReplacement(
                                    new MaterialPageRoute(
                                        builder: (context) => LoginPage()));
                              });
                            } else {
                              print('Pop up bad');
                              popUpInfo(
                                  context,
                                  "Error",
                                  "1. All fields must not be left.\n" +
                                      "2. Password must be 8 or more characters.\n" +
                                      "3. Number must be 10 digits (Only numbers).");
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
