import 'package:flutter/material.dart';

class AddUser extends StatefulWidget{
  @override
  State createState() => new AddUserState();
}

class AddUserState extends State<AddUser>{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 140, 188, 63),
        title: Text('Add user'),
      ),
      body: ListView(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(labelText: 'Username'),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Password'),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Cell Number'),
          ),
          RaisedButton(
            color: Color.fromARGB(255, 140, 188, 63),
            child: Text('Add User'),
            onPressed: (){},
          )
        ],
      ),
    );
  }
}