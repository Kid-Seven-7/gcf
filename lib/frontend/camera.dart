import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class CameraPage extends StatefulWidget {
  @override
  State createState() => new CameraPageState();
}

class CameraPageState extends State<CameraPage>{
  File _image;

  picker() async{
    File img = await ImagePicker.pickImage(source: ImageSource.camera);
    // File img = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      _image = img;
      setState(() {});
    }
  }
  
  @override
  Widget build(BuildContext context) {
        return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          backgroundColor: Color.fromARGB(255, 140, 188, 63),
          title: new Text('Capture'),
        ),
        body: new Container(
          child: new Center(
            child: _image == null
                ? new Text('Image not found.')
                : new Image.file(_image),
          ),
        ),
        floatingActionButton: new FloatingActionButton(
          onPressed: picker,
          child: new Icon(Icons.camera_alt),
        ),
      ),
    );
  }
}