import 'dart:io';
import 'alert_popups.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart'
    as ImageFormatter; //This is to prevent ambiguous_import error
import 'package:flutter/material.dart';
import '../backend/system_padding.dart';
import '../backend/database_engine.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

String projectID;

class CameraPage extends StatefulWidget {
  @override
  CameraPage(String projectIDdata) {
    projectID = projectIDdata;
  }
  State createState() => new CameraPageState();
}

class CameraPageState extends State<CameraPage> {
  File _image;

  picker() async {
    File img = await ImagePicker.pickImage(
        source: ImageSource.camera, maxWidth: 600, maxHeight: 400);
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
                    hintText: 'e.g tools'),
                onChanged: (data) {
                  expenseName = data ;
                }
              )),
              new Expanded(
                  child: new TextField(
                scrollPadding: EdgeInsets.all(30),
                autofocus: true,
                decoration: new InputDecoration(
                    labelStyle: TextStyle(fontSize: 25),
                    hintStyle: TextStyle(fontSize: 15),
                    labelText: 'Amount',
                    hintText: 'e.g 10'),
                onChanged: (data) {
                  expenseAmount = data;
                },
                keyboardType: TextInputType.numberWithOptions(
                    signed: false, decimal: false),
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
                child: const Text('ADD EXPENSE'),
                onPressed: () async {
                  if ((expenseAmount != "" && isNumeric(expenseAmount)) && (expenseName != "") ) {
                    var path1 = _image.toString().split("'");
                    if (path1[1] != null) {
                      String path = path1[1];

                      try {
                        DataBaseEngine dataBaseEngine = new DataBaseEngine();
                        File(path).readAsBytes().then((onValue) {
                          var imageFormatter =
                              ImageFormatter.decodeImage(onValue);

                          var imageID = new Uuid();
                          String imageName = expenseAmount +
                              "_" +
                              projectID +
                              "_" +
                              "expense_" +
                              imageID.v1();

                          final StorageReference storageReference =
                              firebaseStorage.ref().child(imageName);

                          final StorageUploadTask storageUploadTask =
                              storageReference.putFile(_image);

                          (storageUploadTask.onComplete).then((onValue) {
                            (onValue.ref.getDownloadURL()).then((onValue) {
                              Map newImage = Map<String, String>();

                              newImage['expenseName'] = expenseName;
                              newImage['imageID'] = imageID.v1();
                              newImage['name'] = imageName;
                              newImage['amount'] = expenseAmount;
                              newImage['projectID'] = projectID;
                              newImage['imageUrl'] = onValue.toString();
                              dataBaseEngine.addData(
                                  "expensesImages", newImage);
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
