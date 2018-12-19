import 'package:flutter/material.dart';

import 'log_page.dart';

//TODO add general info
Widget generalInfo(BuildContext context, Log log) {
  return Container(
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            logListTile(
                context,
                "Project Name", //Tile title
                log.projectName, //Tile subtitle
                Icons.library_books //Tile icon
            ),
            logDivider(context),
            logListTile(
                context,
                "Description", //Tile title
                log.projectDescription, //Tile subtitle
                Icons.assignment //Tile icon
            ),
            logDivider(context),
            logListTile(
                context,
                "Foreman on Site", //Tile title
                log.projectForeman, //Tile subtitle
                Icons.contacts //Tile icon
            ),
            logDivider(context),
            logListTile(
                context,
                "Site location", //Tile title
                log.projectLocation, //Tile subtitle
                Icons.location_on //Tile icon
            ),
          ],
        ),
      ));
}

//TODO add budget info
Widget budgetInfo(BuildContext context, Log log) {
  return Container(
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            logListTile(
                context,
                "Project Name", //Tile title
                log.projectName, //Tile subtitle
                Icons.library_books //Tile icon
            ),
            logDivider(context),
            logListTile(
                context,
                "Budget", //Tile title
                log.projectBudget, //Tile subtitle
                Icons.monetization_on //Tile icon
            ),
            logDivider(context),
            logListTile(
                context,
                "Foreman on Site", //Tile title
                log.projectForeman, //Tile subtitle
                Icons.contacts //Tile icon
            ),
            logDivider(context),
            logListTile(
                context,
                "Time taken", //Tile title
                "Some value", //Tile subtitle
                Icons.access_time //Tile icon
            ),
            logDivider(context),
            Container(
              margin: EdgeInsets.all(25.0),
              padding: EdgeInsets.only(right: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text("item1 %\n"),
                      CircularProgressIndicator(
                        value: 0.15,
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Text("item2 %\n"),
                      CircularProgressIndicator(
                        value: 0.65,
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Text("item3 %\n"),
                      CircularProgressIndicator(
                        backgroundColor: Color.fromARGB(255, 255, 0, 0),
                        value: 0.85,
                      ),
                    ],
                  )
                ],
              ),
            ),

            logDivider(context),

          ],
        ),
      ));
}

//TODO add time info
Widget timeInfo(BuildContext context, Log log) {
  return Container(
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            logListTile(
                context,
                "Project Name", //Tile title
                log.projectName, //Tile subtitle
                Icons.library_books //Tile icon
            ),
            logDivider(context),
            logListTile(
                context,
                "Start Date", //Tile title
                log.projectStartDate, //Tile subtitle
                Icons.calendar_today //Tile icon
            ),
            logDivider(context),
            logListTile(
                context,
                "End Date", //Tile title
                log.projectEndDate, //Tile subtitle
                Icons.event //Tile icon
            ),
            logDivider(context),
            logListTile(
                context,
                "Time taken", //Tile title
                "Some value", //Tile subtitle
                Icons.access_time //Tile icon
            ),
          ],
        ),
      ));
}

Widget logDivider(BuildContext context) {
  return Divider(
    color: Color.fromARGB(255, 140, 188, 63),
  );
}

Widget logListTile(BuildContext context, String title, String subtitle,
    IconData icon) {
  var checked = true;

  return ListTile(
    leading: Icon(icon),
    isThreeLine: true,
    title: Text(
      title,
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
    subtitle: Text(subtitle),
    onTap: () {
      debugPrint("$title checked is $checked");
      checked = !checked;
    },
  );
}
