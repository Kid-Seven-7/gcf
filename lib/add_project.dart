import 'package:flutter/material.dart';

class SecondScreen extends StatelessWidget {
  List<DropdownMenuItem<String>> _project_types;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
//        leading: Image.asset('assets/images/gcf_white.png'),
        backgroundColor: Color.fromARGB(255, 140, 188, 63),
        title: Text("Add Project"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10.0),
            alignment: Alignment.centerLeft,
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Project Name'),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Project Location'),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Client'),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Project Type'),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Project Foreman'),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Project Budget'),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Project Start Date'),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Project End Date'),
          ),
        ],
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            child: Icon(Icons.check),
            backgroundColor: Color.fromARGB(255, 140, 188, 63),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
