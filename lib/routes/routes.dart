import 'package:final_project/routes/route_name.dart';
import 'package:final_project/screens/home.dart';
import 'package:final_project/screens/landing_screen.dart';
import 'package:final_project/screens/login_screen.dart';
import 'package:final_project/screens/register_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes{
  static final Map<String,Widget Function(BuildContext)> routes ={
    RouteName.initRouteName :(context) => LandingScreen(),
    RouteName.registerRouteName :(context) => RegisterScreen(),
    RouteName.loginRouteName :(context) => LogInScreen(),
    RouteName.homeRouteName :(context) => HomeScreen(),
  };
}