import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
<<<<<<< HEAD
import 'package:gcf_projects_app/home_page.dart';
import 'login.dart';
import 'add_user.dart';
import 'splash.dart';
=======
import 'frontend/home_page.dart';
import 'frontend/splash.dart';
>>>>>>> origin/jmkhosi

void main() {

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
    .then((_) {
      runApp(new MyApp());
    });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GCF',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/adduserpage': (BuildContext context) => new AddUser(),
        '/loginpage' : (BuildContext context) => new LoginPage(),
        '/homepage' : (BuildContext context) => new HomeScreen()
      },
    );
  }
}
