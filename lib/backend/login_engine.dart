import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:gcf_projects_app/backend/globals.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../frontend/login.dart';
import 'package:flutter/foundation.dart';

final storage = new FlutterSecureStorage();
DBCrypt dBCrypt = DBCrypt();
Firestore firestore = Firestore();
int amount = 0;
bool checkComplete = false;

bool checkPassword(Map<String, String> passData) {
  String _password = passData['password'];
  String _dataPassword = passData['dataPassword'];

  return dBCrypt.checkpw(_password, _dataPassword);
}

Future<bool> checkDetails(BuildContext context, String password,
    String dataPassword, String _number) async {
  String _password =
  await storage.read(key: "password").catchError((onError) {});
  String _numberKeyStore =
  await storage.read(key: "_number").catchError((onError) {});

  if (_password != null) {
    if (_password == password) {
      return true;
    }
  }

  Map<String, String> passData = new Map<String, String>();
  passData['password'] = password;
  passData['dataPassword'] = dataPassword;

  bool isPasswordCorrect = await compute(checkPassword, passData);

  if (isPasswordCorrect) {
    await storage
        .write(key: "password", value: password)
        .catchError((onError) {});
    storage.write(key: "firstRun", value: "complete").catchError((onError) {});
    storage.write(key: "_number", value: _number).catchError((onError) {});

    return true;
  } else {
    return false;
  }
}

class LoginEngine {
  bool checkLogin(String number, String password) {
    if ((number == null || number == "") ||
        (password == null || password == "")) {
      return (false);
    }
    return (true);
  }

  Future<bool> checkUser(
      String _number, String password, BuildContext context) async {
    bool isCorrect = false;
    firestore.settings(
        persistenceEnabled: true,
        timestampsInSnapshotsEnabled: true,
        sslEnabled: true);

    await firestore
        .collection("users")
        .reference()
        .where("number", isEqualTo: _number)
        .getDocuments()
        .then((onValue) async {
      var _docs = onValue.documents[0];
      var _dbData = _docs;

      String dataPassword = _dbData['password'];
      if (dataPassword != null) {
        //check password if is correct
        await checkDetails(context, password, dataPassword, _number)
            .then((onValue) async {
          if (onValue == true) {
            isCorrect = true;
            //Initialize Values
            userName = _dbData['name'];
            roleStatus = _dbData['role'];
            number = _dbData['number'];
            isAdmin = (roleStatus == "Administrator") ? true : false;

            await storage.delete(key: "name").catchError((onError) {});
            await storage.delete(key: "role").catchError((onError) {});
            await storage.delete(key: "rememberMe").catchError((onError) {});

            if (rememberMe == "yes") {
              await storage
                  .write(key: "name", value: userName)
                  .catchError((onError) {});
              await storage
                  .write(key: "role", value: roleStatus)
                  .catchError((onError) {});
              await storage
                  .write(key: "rememberMe", value: "yes")
                  .catchError((onError) {});
              await storage
                  .write(key: "number", value: number)
                  .catchError((onError) {});
            }
          } else {
            isCorrect = false;
          }
        }).catchError((onError) {
          isCorrect = false;
        });
      } else {
        isCorrect = false;
      }
    }).catchError((onError) {
      isCorrect = false;
    });
    return isCorrect;
  }
}