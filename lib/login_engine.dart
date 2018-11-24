// import 'package:flutter/material.dart';

class LoginEngine
{
  bool checkLogin(String name, String password)
  {
    if ((name == null || name == "") || (password == null || password == ""))
    {
      print ("Login invalid");
      return (false);
    }
    return (true);
  }
}