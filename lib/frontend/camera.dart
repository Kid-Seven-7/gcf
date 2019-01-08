import 'dart:io';
import 'alert_popups.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart'
    as ImageFormatter; //This is to prevent ambiguous_import error
import 'package:flutter/material.dart';
import '../backend/system_padding.dart';
import '../backend/database_engine.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gcf_projects_app/backend/globals.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

String projectID;
String _currentTable = "";
String _expenseTable = "expensesImages";

class CameraPage extends StatefulWidget {
  @override
  CameraPage(String projectIDdata, String table) {
    projectID = projectIDdata;
    _currentTable = table;
  }
  State createState() => new CameraPageState();
}

class CameraPageState extends State<CameraPage> {
  File _image;

  picker() async {
    File img = await ImagePicker.pickImage(
        source: ImageSource.camera, maxWidth: 1400, maxHeight: 600);
    // File img = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      _image = img;
      //Add to database here
      setState(() {
        _showDialog();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      appBar: AppBar(
        backgroundColor: Colors.green.shade500,
        title: Text("Capture"),
        leading: IconButton(icon: Icon(Icons.image), onPressed: () {}),
        actions: <Widget>[
          Image.asset('assets/images/gcf_white.png'),
        ],
      ),
      body: new Container(
        child: new Center(
          child: _image == null
              ? new Text(
                  'Click the camera icon to take a picture.',
                  style: TextStyle(color: Colors.white),
                )
              : Stack(children: <Widget>[
                  new Card(
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: Colors.green.shade500, width: 10.0),
                          borderRadius: BorderRadius.circular(20)),
                      color: Colors.grey[800],
                      elevation: 4,
                      child: Padding(
                          padding: EdgeInsets.all(10),
                          child: new Image.file(_image))),
                ]),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: picker,
        child: new Icon(Icons.camera_alt),
      ),
    );
  }

  _showDialog() async {
    FirebaseStorage firebaseStorage =
        new FirebaseStorage(storageBucket: "gs://gcfdatabasetest.appspot.com");
    String expenseAmount = "";
    String expenseName = "";
    String siteName = "";
    String imageReason = "";

    await showDialog<String>(
      context: context,
      child: new SystemPadding(
        child: new AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content: new Row(
            children: <Widget>[
              new Expanded(
                  child: new TextField(
                      scrollPadding: EdgeInsets.all(30),
                      autofocus: true,
                      decoration: new InputDecoration(
                          labelStyle: TextStyle(fontSize: 25),
                          hintStyle: TextStyle(fontSize: 15),
                          labelText: 'Name',
                          hintText: (_currentTable == _expenseTable)
                              ? 'e.g tools'
                              : 'site name'),
                      onChanged: (data) {
                        if (_currentTable == _expenseTable) {
                          expenseName = data;
                        } else {
                          siteName = data;
                        }
                      })),
              new Expanded(
                  child: new TextField(
                scrollPadding: EdgeInsets.all(30),
                autofocus: true,
                decoration: new InputDecoration(
                    labelStyle: TextStyle(fontSize: 25),
                    hintStyle: TextStyle(fontSize: 15),
                    labelText: (_currentTable == _expenseTable)
                        ? 'Amount'
                        : 'Description',
                    hintText:
                        (_currentTable == _expenseTable) ? 'e.g 10' : 'reason'),
                onChanged: (data) {
                  if (_currentTable == _expenseTable) {
                    expenseAmount = data;
                  } else {
                    imageReason = data;
                  }
                },
                keyboardType: (_currentTable == _expenseTable)
                    ? TextInputType.numberWithOptions(
                        signed: false, decimal: false)
                    : TextInputType.text,
              ))
            ],
          ),
          actions: <Widget>[
            new FlatButton(
                child: Text('CANCEL'),
                onPressed: () {
                  picker();
                  Navigator.pop(context);
                }),
            new FlatButton(
                child: (_currentTable == _expenseTable)
                    ? const Text('ADD EXPENSE')
                    : const Text("UPLOAD PICTURE"),
                onPressed: () async {
                  //Uploading Image if data is correct
                  if (((expenseAmount != "" && isNumeric(expenseAmount)) &&
                          (expenseName != "") &&
                          (_currentTable == _expenseTable)) ||
                      ((_currentTable != _expenseTable) &&
                          (siteName != "" && imageReason != ""))) {
                    var path1 = _image.toString().split("'");
                    if (path1[1] != null) {
                      String path = path1[1];

                      try {
                        DataBaseEngine dataBaseEngine = new DataBaseEngine();
                        File(path).readAsBytes().then((onValue) {
                          var imageFormatter =
                              ImageFormatter.decodeImage(onValue);

                          var imageID = new Uuid();
                          String imageName = (_currentTable == _expenseTable)
                              ? expenseAmount +
                                  "_" +
                                  projectID +
                                  "_" +
                                  "expense_" +
                                  imageID.v1()
                              : siteName + "_" + imageID.v1();

                          final StorageReference storageReference =
                              firebaseStorage.ref().child(imageName);

                          final StorageUploadTask storageUploadTask =
                              storageReference.putFile(_image);
                          bool displayOnce = false;
                          try {
                            storageUploadTask.events.listen((onData) {
                              if (onData.type ==
                                  StorageTaskEventType.progress) {
                                if (!displayOnce) {
                                  popUpInfo(context, "Information",
                                      "Uploading Image...");
                                  displayOnce = true;
                                }
                              } else if (onData.type ==
                                  StorageTaskEventType.success) {
                                if (displayOnce) {
                                  Navigator.of(context).pop();
                                  displayOnce = false;
                                  popUpInfo(context, "Information",
                                      "Upload successful");
                                }
                              }
                            });
                          } catch (_) {}

                          (storageUploadTask.onComplete).then((onValue) {
                            (onValue.ref.getDownloadURL()).then((onValue) {
                              Map newImage = Map<String, String>();

                              if (_currentTable == _expenseTable) {
                                newImage['expenseName'] = expenseName;
                                newImage['imageID'] = imageID.v1();
                                newImage['name'] = imageName;
                                newImage['amount'] = expenseAmount;
                                newImage['projectID'] = projectID;
                                newImage['imageUrl'] = onValue.toString();
                                newImage['uploadedBy'] = userName;
                              } else {
                                newImage['siteName'] = siteName;
                                newImage['imageID'] = imageID.v1();
                                newImage['name'] = imageName;
                                newImage['projectID'] = projectID;
                                newImage['imageUrl'] = onValue.toString();
                                newImage['uploadedBy'] = userName;
                                newImage['uploadReason'] = imageReason;
                              }
                              dataBaseEngine.addData(
                                  (_currentTable == _expenseTable)
                                      ? _expenseTable
                                      : "projectImages",
                                  newImage);

                              if (_currentTable == _expenseTable) {
                                Firestore.instance
                                    .collection("activeProjects")
                                    .reference()
                                    .where("projectID", isEqualTo: projectID)
                                    .getDocuments()
                                    .then((onValue) {
                                  //Getting the latest expenses
                                  String expensesRaw =
                                      onValue.documents[0]['projectExpenses'];

                                  int expenses = int.parse(expensesRaw);
                                  int newExpense = int.parse(expenseAmount);
                                  int newAmount = expenses + newExpense;
                                  Map _updatedExpenses = Map<String, String>();
                                  _updatedExpenses['projectExpenses'] =
                                      newAmount.toString();

                                  //Updating the expenses field in the current project
                                  Firestore.instance.runTransaction(
                                      (transactionHandler) async {
                                    await transactionHandler
                                        .get(onValue.documents[0].reference);
                                    await transactionHandler.update(
                                        onValue.documents[0].reference,
                                        _updatedExpenses);
                                  }).catchError((onError) {
                                    popUpInfo(context, "Error",
                                        "Failed to add expense amount to the project. Check your network connection and try again\nError Code: 7SDFKYHVB");
                                  });
                                }).catchError((onError) {
                                  popUpInfo(context, "Error",
                                      "Failed to add expense amount to the project. Check your network connection and try again");
                                });
                              }
                            });
                          });
                        }).catchError((onError) {
                          popUpInfo(context, "Error",
                              "Unable to process image.\n Error Code: 677FJ4\n Details: $onError");
                        });
                      } catch (_) {
                        popUpInfo(context, "Error",
                            "Unable to process image.\n Error Code: 67FFJ4");
                      }
                    }
                  } else {
                    popUpInfo(context, "Alert",
                        "You must enter the expense amount in order to add the expense. Take another and put in the expense amount");
                  }
                  Navigator.pop(context);
                })
          ],
        ),
      ),
    );
  }

  bool isNumeric(String data) {
    if (data == null) return false;
    try {
      return double.parse(data) != null;
    } catch (_) {
      return false;
    }
  }
}
