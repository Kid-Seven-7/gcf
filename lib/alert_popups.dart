import 'package:flutter/material.dart';

Future<bool> loginError(BuildContext context) {
  return showDialog<bool>(
      context: context,
      barrierDismissible: false, // tap to close
      builder: (BuildContext context) {
        return new AlertDialog(
          shape: CircleBorder(),
          title: new Text('Fields cannot be empty',),
          actions: <Widget>[
            new FlatButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      });
}