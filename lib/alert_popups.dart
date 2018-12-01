import 'package:flutter/material.dart';
import 'package:gcf_projects_app/globals.dart';
import 'dart:io';

// Future<bool> loginError(BuildContext context) {
//   return showDialog<bool>(
//       context: context,
//       barrierDismissible: false, // tap to close
//       builder: (BuildContext context) {
//         return new AlertDialog(
//           shape: CircleBorder(),
//           title: new Text('Fields cannot be empty',),
//           actions: <Widget>[
//             new FlatButton(
//               child: const Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop(true);
//               },
//             ),
//           ],
//         );
//       });
// }

void errorAlert(BuildContext context, String header, String message) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.fromLTRB(24.0, 10.0, 24.0, 15.0),
          title: new Text(header),
          content: new Text(message),
          actions: <Widget>[
             new FlatButton(
              child: new Text('Exit'),
              onPressed: ()=> exit(0),
            ),  
            new FlatButton(
              child: new Text('Ok'),
              onPressed: (){
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      });
}