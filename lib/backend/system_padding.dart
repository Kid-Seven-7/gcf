import 'package:flutter/material.dart';

class SystemPadding extends StatelessWidget {
  final Widget child;

  SystemPadding({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var mediaQuery = MediaQuery.of(context);
    return new AnimatedContainer(
        padding: EdgeInsets.only(top: 50),
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}