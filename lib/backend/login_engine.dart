// import 'package:flutter/material.dart';
import 'package:gcf_projects_app/backend/globals.dart';

class LoginEngine
{
  bool checkLogin(String name, String password)
  {
    if ((name == null || name == "") || (password == null || password == ""))
    {
      return (false);
    }
    return (true);
  }
}