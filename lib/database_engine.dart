import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_page.dart';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:gcf_projects_app/globals.dart';
import 'alert_popups.dart';

class DataBaseEngine {
  BuildContext _context;
  DBCrypt dBCrypt = DBCrypt();
  int amount = 0;
  bool checkComplete = false;

  //Function gets data from the database and checks if the user exists in the database
  //Function to check user is checkDetails()

  void checkUser(String name, String password, BuildContext context) {
    _context = context;
    int counter = 1;
    try {
      Firestore firestore = Firestore();
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
        // Navigator.push(
        //   _context,
        //   MaterialPageRoute(builder: (context) => HomeScreen()),
        // );
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (context) => HomeScreen()));
      } catch (_) {
        //This is to silence the warning after assert failure
      }
    } else {
      if (index == amount) {
        if (!checkComplete) {
          errorAlert(context, 'Login Failed',
              'Incorrect name/password. Please try again.');
        }
      }
    }
  }

  void addData(String collection, Map<String, dynamic> data) {
    try {
      Firestore.instance.collection(collection).document().updateData(data);
    } catch (_) {
      print('Do some awesome pop-up');
    }
  }
}
