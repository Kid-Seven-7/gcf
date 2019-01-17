import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//ALL GLOBALS NEEDED ARE TO BE KEPT IN THIS FILE ONLY
//To keep value of variables between file call this dart file this way (import 'package:gcf_projects_app/globals.dart')
//If you call this file this way (import 'globals.dart') it won't be able to keep it's value between files

//READTHIS ^^^
int pageNumber = 0; //This variable serves as a test
//it keeps it's value through-out the whole program :)
//

//ADD VARIABLES HERE
bool isConnected = false; //This variable gets updated on the splash screen
bool  isAdmin = false;

//User Variables
String  userName;
String  roleStatus;
String  number;
String  rememberMe = "no";

Map<String, String> userData;

//app variables
bool  skipLogin = false;
String currentPage = "";
int notifications = 0;

//app icons
var messageIcon = Icons.markunread;

//Style
final formatNumber = new NumberFormat("#,##0.00", "en_US");
Color gcfGreen = Color.fromARGB(255, 140, 188, 63);
Color gcfBG = Colors.black87;