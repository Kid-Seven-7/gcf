import 'package:flutter/material.dart';

import 'package:gcf_projects_app/frontend/stats_page.dart';
import 'package:gcf_projects_app/backend/globals.dart';

/*
  Parameter:

  Function:

  Return:

*/
Widget commercialStatistics(BuildContext context, Log log) {
  comTotal += int.parse(log.projectBudget);
//  allTotal += int.parse(log.projectBudget);
  return Container(
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            logListTile(
                context,
                log.projectName, //Tile title
                "Budget : R" + formatNumber.format(int.parse(log.projectBudget)), //Tile subtitle
                Icons.business //Tile icon
            ),
          ],
        ),
      )
  );
}

/*
  Parameter:

  Function:

  Return:

*/
Widget residentialStatistics(BuildContext context, Log log) {
  resTotal += int.parse(log.projectBudget);
//  allTotal += int.parse(log.projectBudget);
  return Container(
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            logListTile(
                context,
                log.projectName, //Tile title
                "Budget : R" + formatNumber.format(int.parse(log.projectBudget)), //Tile subtitle
                Icons.home //Tile icon
            ),
          ],
        ),
      )
  );
}

/*
  Parameter:

  Function:

  Return:

*/
Widget allStatistics(BuildContext context, Log log) {
  allTotal += int.parse(log.projectBudget);
  return Container(
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            logListTile(
                context,
                log.projectName, //Tile title
                "Budget : R" + formatNumber.format(int.parse(log.projectBudget)), //Tile subtitle
                log.projectType == "Business"
                    ? Icons.business //Tile icon
                    : Icons.home //Tile icon
            ),
          ],
        ),
      )
  );
}

/*
  Parameter:

  Function:

  Return:

*/
Widget logDivider(BuildContext context) {
  return Divider(
    color: gcfBG,
  );
}

/*
  Parameter:

  Function:

  Return:

*/
Widget logListTile(
    BuildContext context, String title, String subtitle, IconData icon) {
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
double getProfit(Log log) {
  double budget = double.parse(log.projectBudget);
  double expenses = log.projectExpenses == null ? 0 : double.parse(log.projectExpenses);
  double profit = budget - expenses;
  double percent = profit / (budget / 100);

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
double getExpenses(Log log) {
  double budget = double.parse(log.projectBudget);
  double expenses = log.projectExpenses == null ? 0 : double.parse(log.projectExpenses);
  double percent = expenses / (budget / 100);

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
double getProfitPerDay(Log log) {
  return (getProfit(log) / dateDiffAsInt(log));
}

/*
  Parameter:
    Log
  Function:
    Calculates the time between the start and end of project
  Return:
    A string stating how long a project will take
*/
String dateDiff(Log log) {
  String startYear = "";
  String startMonth = "";
  String startDay = "";
  String endYear = "";
  String endMonth = "";
  String endDay = "";

  for (int i = 0; i < 10; i++) {
    if (i < 4) {
      startYear += log.projectStartDate[i];
      endYear += log.projectEndDate[i];
    } else if (i > 4 && i < 7) {
      startMonth += log.projectStartDate[i];
      endMonth += log.projectEndDate[i];
    } else if (i > 7) {
      startDay += log.projectStartDate[i];
      endDay += log.projectEndDate[i];
    }
  }

  var end = new DateTime.utc(
      int.parse(endYear), int.parse(endMonth), int.parse(endDay));
  var start = new DateTime.utc(
      int.parse(startYear), int.parse(startMonth), int.parse(startDay));
  String hours = "";
  String diffString;

  Duration difference = end.difference(start);
  diffString = difference.toString();
  for (int i = 0; diffString[i] != ':'; i++) {
    hours += diffString[i];
  }

  int days = (int.parse(hours) / 24).round();

  String ret = (days > 1) ? " Days" : " Day";

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
int dateDiffAsInt(Log log) {
  String startYear = "";
  String startMonth = "";
  String startDay = "";
  String endYear = "";
  String endMonth = "";
  String endDay = "";

  for (int i = 0; i < 10; i++) {
    if (i < 4) {
      startYear += log.projectStartDate[i];
      endYear += log.projectEndDate[i];
    } else if (i > 4 && i < 7) {
      startMonth += log.projectStartDate[i];
      endMonth += log.projectEndDate[i];
    } else if (i > 7) {
      startDay += log.projectStartDate[i];
      endDay += log.projectEndDate[i];
    }
  }

  var end = new DateTime.utc(
      int.parse(endYear), int.parse(endMonth), int.parse(endDay));
  var start = new DateTime.utc(
      int.parse(startYear), int.parse(startMonth), int.parse(startDay));
  String hours = "";
  String diffString;

  Duration difference = end.difference(start);
  diffString = difference.toString();
  for (int i = 0; diffString[i] != ':'; i++) {
    hours += diffString[i];
  }

  int days = (int.parse(hours) / 24).round();

  return (days);
}