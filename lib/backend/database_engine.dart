import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../frontend/home_page.dart';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:gcf_projects_app/backend/globals.dart';
import '../frontend/alert_popups.dart';
import 'package:validators/validators.dart';

class DataBaseEngine {
  BuildContext _context;
  DBCrypt dBCrypt = DBCrypt();
  Firestore firestore = Firestore();
  int amount = 0;
  bool checkComplete = false;

  //Function gets data from the database and checks if the user exists in the database
  //Function to check user is checkDetails()

  void checkUser(String name, String password, BuildContext context) {
    _context = context;
    int counter = 1;
    try {
      firestore.settings(timestampsInSnapshotsEnabled: true, sslEnabled: true);

      getLength(firestore);

      firestore.collection('users').getDocuments().asStream().listen((data) {
        for (var doc in data.documents) {
          String dataName = doc['name'];
          String dataPassword = doc['password'];
          String dataRole = doc['role'];

          checkDetails(context, name, password, dataName, dataPassword,
              dataRole, counter);
          counter++;
          if (checkComplete) {
            break;
          }
        }
      });
    } catch (_) {
      print('Failed to connect to the database');
    }
  }

  void getLength(Firestore firestore) async {
    var futureAmount =
        await firestore.collection('users').getDocuments().then((data) {
      amount = data.documents.length;
    });
  }

  String  createHash(String value){
    if (value.isNotEmpty){
      String salt = dBCrypt.gensalt();
      return dBCrypt.hashpw(value, salt);
    }
    return null;
  }

  //Checks if users' name and password matches those in the database
  void checkDetails(BuildContext context, String name, String password,
      String dataName, String dataPassword, String role, int index) {
    if ((name == dataName)) {
      try {
        assert(dBCrypt.checkpw(password, dataPassword), true);
        if (role == 'admin') {
          isAdmin = true;
        }

        checkComplete = true;
        userName = name;
        roleStatus = role;
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (context) => HomeScreen()));
      } catch (_) {
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

  void addData(String collection, Map<String, String> data) {
    try {
      //CHECK IF DATA EXISTS IN DATABASEE
      firestore.collection(collection).document().setData(data);
    } catch (e) {
      print("Problem: $e");
    }
  }

   validateData(Map<String, String> data) {
    if (data['name'].isEmpty) {
      return (false);
    }
    if (data['password'].isEmpty || data['password'].length < 8) {
      return (false);
    }
    if (data['number'].isEmpty || data['number'].length < 10 || !isNumeric(data['number'])) {
      return (false);
    }
    return (true);
  }

  bool processData(Map<String, String> data) {
    if (!validateData(data)) {
      return (false);
    }

    data['password'] = createHash(data['password']);
    addData('pendingUsers', data);
    return (true);
  }

  Map createMap(String name, String password, String number) {
    Map<String, String> newUser = new Map();
    newUser['name'] = name;
    newUser['password'] = password;
    newUser['number'] = number;
    return newUser;
  }
}
