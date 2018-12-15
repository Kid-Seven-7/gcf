import 'package:flutter/material.dart';

import 'log_page.dart';

//TODO add general info
Widget generalInfo(BuildContext context, Log log) {
  return   Container(
      child: Card(
        child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.library_books),
              title: Text(
                "Project Name",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(log.projectName),
            ),
            Divider(
              color: Color.fromARGB(255, 140, 188, 63),
            ),
            ListTile(
              leading: Icon(Icons.assignment),
              title: Text(
                "Description",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(log.projectDescription),
            ),
            Divider(
              color: Color.fromARGB(255, 140, 188, 63),
            ),
            ListTile(
              leading: Icon(Icons.contacts),
              title: Text(
                "Foreman on Site",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(log.projectForeman),
            ),
            Divider(
              color: Color.fromARGB(255, 140, 188, 63),
            ),
            ListTile(
              leading: Icon(Icons.access_time),
              title: Text(
                "Time taken",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text("Some value"),
            ),
          ],
        ),
      )
  );
}

//TODO add budget info
Widget budgetInfo(BuildContext context, Log log) {
  return   Container(
      child: Card(
        child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.library_books),
              title: Text(
                "Project Name",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(log.projectName),
            ),
            Divider(
              color: Color.fromARGB(255, 140, 188, 63),
            ),
            ListTile(
              leading: Icon(Icons.assignment),
              title: Text(
                "Description",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(log.projectDescription),
            ),
            Divider(
              color: Color.fromARGB(255, 140, 188, 63),
            ),
            ListTile(
              leading: Icon(Icons.contacts),
              title: Text(
                "Foreman on Site",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(log.projectForeman),
            ),
            Divider(
              color: Color.fromARGB(255, 140, 188, 63),
            ),
            ListTile(
              leading: Icon(Icons.access_time),
              title: Text(
                "Time taken",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text("Some value"),
            ),
          ],
        ),
      )
  );
}

//TODO add time info
Widget timeInfo(BuildContext context, Log log) {
  return   Container(
      child: Card(
        child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.library_books),
              title: Text(
                "Project Name",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(log.projectName),
            ),
            Divider(
              color: Color.fromARGB(255, 140, 188, 63),
            ),
            ListTile(
              leading: Icon(Icons.assignment),
              title: Text(
                "Description",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(log.projectDescription),
            ),
            Divider(
              color: Color.fromARGB(255, 140, 188, 63),
            ),
            ListTile(
              leading: Icon(Icons.contacts),
              title: Text(
                "Foreman on Site",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(log.projectForeman),
            ),
            Divider(
              color: Color.fromARGB(255, 140, 188, 63),
            ),
            ListTile(
              leading: Icon(Icons.access_time),
              title: Text(
                "Time taken",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text("Some value"),
            ),
          ],
        ),
      )
  );
}