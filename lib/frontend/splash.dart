import 'package:flutter/material.dart';
import 'package:gcf_projects_app/backend/globals.dart';
import 'dart:async';
import 'login.dart';
import 'dart:io';
import 'alert_popups.dart';
import 'home_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

String status = "";
bool connected = false;
final storage = new FlutterSecureStorage();

class SplashScreen extends StatefulWidget {
  @override
  State createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _iconAnimationController;
  Animation<double> _iconAnimation;
  Timer timer1, timer2, timer3;

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

    timer1 = Timer(Duration(seconds: 1), () {
      status = "Checking connection...";
    });
    timer2 = Timer(Duration(seconds: 2), () {
      checkConnection();
    });
    timer3 = Timer(Duration(seconds: 5), () {
      if (isConnected) {
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (context) => LoginPage()));
      } else {
        popUpInfo(context, 'Network Error',
            'Failed to connect to the network. Please check if your wifi/mobile data is on.');
        const seconds = const Duration(seconds: 2);
        new Timer.periodic(seconds, (Timer t) {
          status = "Retrying...";
          checkConnection();
          if (!isConnected) {
            status = 'No connection found';
          } else {
            status = 'Connected';
            t.cancel();
            Timer(Duration(seconds: 1), () {
              if (isConnected && !skipLogin) {
                Navigator.of(context).pushReplacement(
                    new MaterialPageRoute(builder: (context) => LoginPage()));
              }
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    timer1.cancel();
    timer2.cancel();
    timer3.cancel();
    super.dispose();
  }

  void checkConnection() async {
    checkUser();
    try {
      final result = await InternetAddress.lookup('google.com',
          type: InternetAddressType.any);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        status = "Connected";
        isConnected = true;
      }
    } on SocketException catch (_) {
      status = "No connection found";
      status = "Retrying...";
      isConnected = false;
    }
  }

  void checkUser() async {
    try {
      Map<String, String> userData =
          await storage.readAll().catchError((onError) {});

      if (userData['name'] != null) {
        if (userData['rememberMe'] == "yes") {
          skipLogin = true;

          userName = userData['name'];
          roleStatus = userData['role'];
          number = userData['number'];
          userData['name'] = userName;
          userData['role'] = roleStatus;
          userData['number'] = number;

          if (roleStatus == "Administrator"){
            isAdmin = true;
          }

          _iconAnimationController.dispose();
          //Going to Home Page
          Navigator.of(context).pushReplacement(
              new MaterialPageRoute(builder: (context) => HomeScreen()));
        } else {
          skipLogin = false;
        }
      }
    } catch (_) {}
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
