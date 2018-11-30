import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_page.dart';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:gcf_projects_app/globals.dart';

class DataBaseEngine {
  BuildContext _context;
  DBCrypt dBCrypt = DBCrypt();

  //Function gets data from the database and checks if the user exists in the database
  //Function to check user is checkDetails()

  void checkUser(String name, String password, BuildContext context) {
    _context = context;

    try {
      Firestore firestore = Firestore();
      firestore.settings(timestampsInSnapshotsEnabled: true, sslEnabled: true);

      firestore.collection('users').getDocuments().asStream().listen((data) {
        for (var doc in data.documents) {
          String dataName = doc['name'];
          String dataPassword = doc['password'];
          String dataRole = doc['role'];

          checkDetails(name, password, dataName, dataPassword, dataRole);
        }
      });
    } catch (_) {
      print('Failed to connect to the database');
    }
  }

  //Checks if users' name and password matches those in the database
  void checkDetails(
      String name, String password, String dataName, String dataPassword, String role) {

    if ((name == dataName)) {
      try {
        assert(dBCrypt.checkpw(password, dataPassword), true);
        if (role == 'admin'){
          isAdmin = true;
          print('IsAdmin: $isAdmin');
        }
        Navigator.push(
          _context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } catch (_) {
        print('Incorrect Details papa');
      }
    }
  }

  void  addData(String collection, Map<String, dynamic> data){
    try{
      Firestore.instance.collection(collection).document().updateData(data);
    } catch (_){
      print('Do some awesome pop-up');
    }
  }
}
