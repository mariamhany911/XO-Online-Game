import 'package:final_project/routes/route_name.dart';
import 'package:final_project/screens/available_rooms_screen.dart';
import 'package:final_project/screens/game_screen.dart';
import 'package:final_project/screens/home_screen.dart';
import 'package:final_project/screens/landing_screen.dart';
import 'package:final_project/screens/login_screen.dart';
import 'package:final_project/screens/profile_screen.dart';
import 'package:final_project/screens/register_screen.dart';
import 'package:final_project/screens/room_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes{
  static final Map<String,Widget Function(BuildContext)> routes ={
    RouteName.initRouteName :(context) => LandingScreen(),
    RouteName.registerRouteName :(context) => RegisterScreen(),
    RouteName.loginRouteName :(context) => LogInScreen(),
    RouteName.homeRouteName :(context) => HomeScreen(),
    RouteName.profileRouteName :(context) => ProfileScreen(),
    RouteName.availableRoomsRouteName:(context)=> AvailableRooms(),
    RouteName.roomRouteName:(context)=> RoomScreen(),
    RouteName.gameRouteName:(context)=> GameScreen(),
  };
}