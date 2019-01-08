import 'package:flutter/material.dart';

import 'package:gcf_projects_app/frontend/stats_page.dart';

/*
  Parameter:

  Function:

  Return:

*/
Widget commercialStatistics(BuildContext context, Log log) {
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

/*
  Parameter:

  Function:

  Return:

*/
Widget residentialStatistics(BuildContext context, Log log) {
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
                "R"+log.projectBudget, //Tile subtitle
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
                dateDiff(log), //Tile subtitle
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
                      Text("Profit \n" + getProfit(log).toString()+"% \nof budget\n"),
                      CircularProgressIndicator(
                        value: getProfit(log)/100,
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Text("Profit/day \n" + getProfitPerDay(log).toStringAsFixed(2)+"% \nof budget\n"),
                      CircularProgressIndicator(
                        backgroundColor: Color.fromARGB(255, 255, 0, 0),
                        value: getProfitPerDay(log)/100,
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Text("Expenses \n" + getExpenses(log).toString()+"% \nof budget\n"),
                      CircularProgressIndicator(
                        value: getExpenses(log)/100,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            logDivider(context),
          ],
        ),
      ));
}

/*
  Parameter:

  Function:

  Return:

*/
Widget allStatistics(BuildContext context, Log log) {
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
                dateDiff(log), //Tile subtitle
                Icons.access_time //Tile icon
            ),
          ],
        ),
      ));
}

/*
  Parameter:

  Function:

  Return:

*/
Widget logDivider(BuildContext context) {
  return Divider(
    color: Color.fromARGB(255, 140, 188, 63),
  );
}

/*
  Parameter:

  Function:

  Return:

*/
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

/*
  Parameter:
    Log
  Function:
    Calculates the percentage of the profit
  Return:
    Percent of profit
*/
double getProfit(Log log){
  double budget = double.parse(log.projectBudget);
  double expenses = 900000.00;
  double profit  = budget - expenses;
  double percent = profit / (budget/100);

  return percent;
}

/*
  Parameter:
    Log
  Function:
    Calculates the percentage of the expenses
  Return:
    Percent of expenses
*/
double getExpenses(Log log){
  double budget = double.parse(log.projectBudget);
  double expenses = 250000.00;
  double percent = expenses / (budget/100);

  return percent;
}

/*
  Parameter:
    Log
  Function:
    Divides the profit by the number of days taken
  Return:
    The profit per day
*/
double getProfitPerDay(Log log){
  return (getProfit(log)/dateDiffAsInt(log));
}

/*
  Parameter:
    Log
  Function:
    Calculates the time between the start and end of project
  Return:
    A string stating how long a project will take
*/
String dateDiff(Log log){
  String startYear = "";
  String startMonth = "";
  String startDay = "";
  String endYear = "";
  String endMonth = "";
  String endDay = "";

  for (int i = 0; i < 10; i++){
    if (i < 4){
      startYear += log.projectStartDate[i];
      endYear += log.projectEndDate[i];
    }else if (i > 4 && i < 7){
      startMonth += log.projectStartDate[i];
      endMonth += log.projectEndDate[i];
    }else if (i > 7){
      startDay += log.projectStartDate[i];
      endDay += log.projectEndDate[i];
    }
  }

  var end = new DateTime.utc(int.parse(endYear), int.parse(endMonth), int.parse(endDay));
  var start = new DateTime.utc(int.parse(startYear), int.parse(startMonth), int.parse(startDay));
  String hours = "";
  String diffString;

  Duration difference = end.difference(start);
  diffString = difference.toString();
  for (int i = 0; diffString[i] != ':'; i++){
    hours += diffString[i];
  }

  int days = (int.parse(hours)/24).round();

  String ret = (days > 1) ? " Days" : " Day" ;

  return (days.toStringAsFixed(0) + ret);
}

/*
  Parameter:
    Log
  Function:
    Calculates the time between the start and end of project
  Return:
    A string stating how long a project will take
*/
int dateDiffAsInt(Log log){
  String startYear = "";
  String startMonth = "";
  String startDay = "";
  String endYear = "";
  String endMonth = "";
  String endDay = "";

  for (int i = 0; i < 10; i++){
    if (i < 4){
      startYear += log.projectStartDate[i];
      endYear += log.projectEndDate[i];
    }else if (i > 4 && i < 7){
      startMonth += log.projectStartDate[i];
      endMonth += log.projectEndDate[i];
    }else if (i > 7){
      startDay += log.projectStartDate[i];
      endDay += log.projectEndDate[i];
    }
  }

  var end = new DateTime.utc(int.parse(endYear), int.parse(endMonth), int.parse(endDay));
  var start = new DateTime.utc(int.parse(startYear), int.parse(startMonth), int.parse(startDay));
  String hours = "";
  String diffString;

  Duration difference = end.difference(start);
  diffString = difference.toString();
  for (int i = 0; diffString[i] != ':'; i++){
    hours += diffString[i];
  }

  int days = (int.parse(hours)/24).round();

  return (days);
}
