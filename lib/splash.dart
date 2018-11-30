import 'package:flutter/material.dart';
import 'package:gcf_projects_app/globals.dart';
import 'dart:async';
import 'login.dart';
import 'dart:io';

String status = "";
bool connected = false;

class SplashScreen extends StatefulWidget {
  @override
  State createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _iconAnimationController;
  Animation<double> _iconAnimation;

  @override
  void initState() {
    super.initState();

    _iconAnimationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 2000));

    _iconAnimation = new CurvedAnimation(
      parent: _iconAnimationController,
      curve: Curves.bounceInOut,
    );
    _iconAnimation.addListener(() => this.setState(() {}));
    _iconAnimationController.forward();

    Timer(Duration(seconds: 1), () {
      status = "Checking connection...";
    });
    Timer(Duration(seconds: 2), () {
      checkConnection();
    });
    Timer(Duration(seconds: 5), () {
      if (isConnected) {
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (context) => LoginPage()));
      }
      else{
        print("Do an awesome popup please :)");
      }
    });
  }

  void checkConnection() async {
    //TEST
    pageNumber += 1;
    print('Splash Page Number: $pageNumber');
    //TEST
    try {
      final result = await InternetAddress.lookup('google.com',
          type: InternetAddressType.any);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        status = "Connected";
        isConnected = true;
      }
    } on SocketException catch (_) {
      status = "No connection found";
      isConnected = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(fit: StackFit.expand, children: <Widget>[
        Container(
          decoration: BoxDecoration(color: Colors.black),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Image(
                      image: new AssetImage("assets/images/GCF-logo.png"),
                      height: _iconAnimation.value * 110,
                      width: _iconAnimation.value * 110,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                    ),
                    Text(
                      "GCF Projects",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(
                          Color.fromARGB(255, 140, 188, 63))),
                  new MaterialButton(
                    color: Colors.black,
                    child: new Text(
                      "",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => LoginPage()),
                      // );
                    },
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(70.0)),
                    splashColor: Colors.white,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                  ),
                  Text(
                    status,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          ],
        )
      ]),
    );
  }
}
