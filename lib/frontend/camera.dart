import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraPage extends StatefulWidget {
  @override
  State createState() => new CameraPageState();
}

class CameraPageState extends State<CameraPage> {
  File _image;

  picker() async {
    File img = await ImagePicker.pickImage(source: ImageSource.camera);
    // File img = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      _image = img;
      //Add to database here
      setState(() {});
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
              ? new Text('Click the camera icon to take a picture.', style: TextStyle(color: Colors.white),)
              : new Image.file(_image),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: picker,
        child: new Icon(Icons.camera_alt),
      ),
    );
  }
}
