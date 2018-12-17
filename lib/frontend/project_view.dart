import 'package:flutter/material.dart';

class ProjectView extends StatefulWidget{
  @override
  State createState() => new ProjectViewState();
}

class ProjectViewState extends State<ProjectView>{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 140, 188, 63),
        title: Text('Project Name'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Client Name')
          ),
          ListTile(
            title: Text('Location')
          ),
          ListTile(
            title: Text('Foreman')
          ),
          ListTile(
            title: Text('Project Type')
          ),
          ListTile(
            title: Text('Budget')
          ),
          ListTile(
            title: Text('Start Date')
          ),
          ListTile(
            title: Text('End date')
          ),
        ],
      ),
    );
  }
}