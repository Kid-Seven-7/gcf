import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gcf_projects_app/frontend/login.dart';
import 'package:gcf_projects_app/frontend/alert_popups.dart';
import 'package:gcf_projects_app/frontend/notifications.dart';
import 'package:gcf_projects_app/backend/database_engine.dart';
import 'package:gcf_projects_app/backend/globals.dart';

class AddUser extends StatefulWidget {
  @override
  State createState() => new AddUserState();
}

class AddUserState extends State<AddUser> {
  var nameController = new TextEditingController();
  var passwordController = new TextEditingController();
  var numberController = new TextEditingController();
  var emailController = new TextEditingController();

  var modal = new Stack(
    children: [
      Scaffold(
        backgroundColor: gcfBG,
      ),
      new Opacity(
        opacity: 1.0,
        child: const ModalBarrier(
          dismissible: false,
          barrierSemanticsDismissible:
              false, //ADDED THIS BEFORE BUILDING//////////
        ),
      ),
      new Center(
        child: new CircularProgressIndicator(
          backgroundColor: Colors.red,
        ),
      ),
    ],
  );

  void popNavLogin(BuildContext context, String header, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.fromLTRB(24.0, 10.0, 24.0, 5.0),
            title: new Text(header),
            content: new Text(message),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    new MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              ),
            ],
          );
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
                          decoration: new InputDecoration(labelText: "Email"),
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
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
                          onPressed: () async {
                            //Create a map
                            //Pass it to database_engine
                            DataBaseEngine databaseEngine =
                                new DataBaseEngine();

                            //Creating a map
                            var newUserData = databaseEngine.createMap(
                                nameController.text,
                                passwordController.text,
                                numberController.text,
                                emailController.text);
                            //Init modal
                            Navigator.of(context).push(
                              new MaterialPageRoute(builder: (context){
                                return WillPopScope(
                                  onWillPop: () async => false,
                                  child: modal,
                                );
                              })
                            );
                            bool dataGood =
                                await databaseEngine.processData(newUserData);
                            if (dataGood) {
                              String nameN = nameController.text;
                              String numberN = numberController.text;

                              sendMessage(context, "New User Request",
                                  "$nameN has requested permission to use the app. Phone number is $numberN");
                              Navigator.pop(context);
                              popNavLogin(context, "Success",
                                  "Your account has been created.");
                            } else {
                              Navigator.pop(context);
                              popUpInfo(
                                  context,
                                  "Error",
                                  "1. All fields must not be left.\n" +
                                      "2. Password must be 8 or more characters.\n" +
                                      "3. Number must be 10 digits (Only numbers).\n" +
                                      "4. Make sure this number hasn't been used here before.");
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
