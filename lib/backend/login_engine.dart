// import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../frontend/home_page.dart';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:gcf_projects_app/backend/globals.dart';
import '../frontend/alert_popups.dart';
import 'package:validators/validators.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();
DBCrypt dBCrypt = DBCrypt();
Firestore firestore = Firestore();
int amount = 0;
bool checkComplete = false;

class LoginEngine {
  bool checkLogin(String name, String password) {
    if ((name == null || name == "") || (password == null || password == "")) {
      return (false);
    }
    return (true);
  }

  void checkUser(String name, String password, BuildContext context) async {
    int counter = 1;
    try {
      firestore.settings(timestampsInSnapshotsEnabled: true, sslEnabled: true);

      getLength(context, firestore);

      firestore
          .collection('users')
          .reference()
          .where("name", isEqualTo: name)
          .getDocuments()
          .then((data) {
        for (var doc in data.documents) {
          String dataName = doc['name'];
          String dataPassword = doc['password'];
          String dataRole = doc['role'];
          String dataNumber = doc['number'];

          checkDetails(context, name, password, dataName, dataPassword,
              dataRole, counter, dataNumber);
          counter++;
          if (checkComplete) {
            break;
          }
        }
      }).catchError((onError) {
        popUpInfo(context, "Error: Connection failed",
            "Unable to connect to the database. Please check your data connection and try again.");
      });

      // firestore.collection('users').getDocuments().asStream().listen((data) {});
    } catch (_) {
      popUpInfo(context, "Error: Connection failed",
          "Unable to connect to the database. Please check your data connection and try again.");
    }
  }

  void getLength(BuildContext context, var firestore) async {
    try {
      await firestore.collection('users').getDocuments().then((data) {
        amount = data.documents.length;
      }).catcgError(() {
        popUpInfo(context, "Error: Connection failed",
            "Unable to connect to the database. Please check your data connection and try again.\n Error Code: 6573HF");
      });
    } catch (_) {}
  }

  //Checks if users' name and password matches those in the database
  void checkDetails(
      BuildContext context,
      String name,
      String password,
      String dataName,
      String dataPassword,
      String role,
      int index,
      String dataNumber) async {
    if ((name == dataName)) {
      try {
        if (dBCrypt.checkpw(password, dataPassword)) {
          if (role == 'Administrator') {
            isAdmin = true;
          }

          checkComplete = true;
          userName = name;
          roleStatus = role;
          number = dataNumber;

          await storage.deleteAll().catchError((onError) {});
          if (rememberMe == "yes") {
            await storage
                .write(key: "name", value: name)
                .catchError((onError) {});
            await storage
                .write(key: "role", value: role)
                .catchError((onError) {});
            await storage
                .write(key: "rememberMe", value: "yes")
                .catchError((onError) {});
            await storage
                .write(key: "number", value: dataNumber)
                .catchError((onError) {});
          }
          Navigator.of(context).pushReplacement(
              new MaterialPageRoute(builder: (context) => HomeScreen()));
        } else {
          throw Exception("Password doesn't match");
        }
      } catch (_) {
        popUpInfo(context, 'Login Failed',
            'Incorrect name/password. Please try again.');
        //This is to silence the warning after assert failure
      }
    } else {
      if (index == amount) {
        if (!checkComplete) {
          popUpInfo(context, 'Login Failed',
              'Incorrect name/password. Please try again.');
        }
      }
    }
  }
}
