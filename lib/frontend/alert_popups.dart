import 'package:flutter/material.dart';
import 'package:gcf_projects_app/backend/globals.dart';

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

void popUpInfo(BuildContext context, String header, String message) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.fromLTRB(24.0, 10.0, 24.0, 5.0),
          title: new Text(header),
          content: new Text(message),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      });
}

class UserProfileUpdate extends StatefulWidget {
  @override
  _UserProfileUpdateState createState() => _UserProfileUpdateState();
}

class _UserProfileUpdateState extends State<UserProfileUpdate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade500,
        title: Text("Profile Update"),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {},
        ),
        actions: <Widget>[
          new FlatButton(
            onPressed: () {},
            child: Text(
              "Save",
              style: Theme.of(context)
                  .textTheme
                  .subhead
                  .copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Text("Hello World"),
    );
  }
}
