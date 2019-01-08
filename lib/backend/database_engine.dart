import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../frontend/home_page.dart';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:gcf_projects_app/backend/globals.dart';
import '../frontend/alert_popups.dart';
import 'package:validators/validators.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();

class DataBaseEngine {
  @override
  DBCrypt dBCrypt = DBCrypt();
  Firestore firestore = Firestore();

  String createHash(String value) {
    if (value.isNotEmpty) {
      String salt = dBCrypt.gensalt();
      return dBCrypt.hashpw(value, salt);
    }
    return null;
  }

  void addData(String collection, Map<String, dynamic> data) {
    try {
      //CHECK IF DATA EXISTS IN DATABASEE
      firestore
          .collection(collection)
          .document()
          .setData(data)
          .catchError((error) {
        print(error);
      });
    } catch (_) {}
  }

  bool validateData(Map<String, String> data) {
    if (data['name'].isEmpty) {
      return (false);
    }
    if (data['password'].isEmpty || data['password'].length < 8) {
      return (false);
    }
    if (data['number'].isEmpty ||
        data['number'].length < 10 ||
        !isNumeric(data['number'])) {
      return (false);
    }
    if (userExists(data['number'])) {
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

  bool userExists(String number) {
    bool userFound = false;
    return userFound;
  }
}
