import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_page.dart';
import 'package:dbcrypt/dbcrypt.dart';

class DataBaseEngine {
  BuildContext _context;
  DBCrypt dBCrypt = DBCrypt();

  void checkUser(String name, String password, BuildContext context) {
    _context = context;

    try {
      Firestore firestore = Firestore();
      firestore.settings(timestampsInSnapshotsEnabled: true, sslEnabled: true);

      firestore.collection('users').getDocuments().asStream().listen((data) {
        for (var doc in data.documents) {
          String dataName = doc['name'];
          String dataPassword = doc['password'];

          checkDetails(name, password, dataName, dataPassword);
        }
      });
    } catch (_) {
      print('Failed to connect to the database');
    }
  }

  void checkDetails(
      String name, String password, String dataName, String dataPassword) {
    print('name: $name');
    print('dataName: $dataName');
    if ((name == dataName)) {
      try {
        assert(dBCrypt.checkpw(password, dataPassword), true);
        Navigator.push(
          _context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } catch (_) {
        print('Incorrect Details papa');
      }
    }
  }
}
