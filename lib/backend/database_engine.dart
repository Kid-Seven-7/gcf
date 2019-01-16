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

  Future<bool> validateData(Map<String, String> data) async {
    if (data['name'].isEmpty) {
      return (false);
    }
    if (data['email'].isEmpty) {
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
    bool userFound = await userExists(data['number']);
    if (userFound) {
      return (false);
    }
    return (true);
  }

  Future<bool> processData(Map<String, String> data) async {
    bool dataValid = await validateData(data);
    if (!dataValid) {
      return (false);
    }

    data['password'] = createHash(data['password']);
    addData('pendingUsers', data);
    return (true);
  }

  Map createMap(String name, String password, String number, String email) {
    Map<String, String> newUser = new Map();
    newUser['name'] = name;
    newUser['password'] = password;
    newUser['number'] = number;
    newUser['email'] = email;
    return newUser;
  }

  Future<bool> userExists(String number) async {
    bool userFound = false;

    await firestore
        .collection("users")
        .reference()
        .where("number", isEqualTo: number)
        .getDocuments()
        .then((onValue) {
      var _data = onValue.documents;
      if (_data.length > 0) {
        userFound = true;
      }
    }).catchError((onError) {
      print("Error Found::Error Code::39J8HF32::$onError");
    });
    return userFound;
  }
}
