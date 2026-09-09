import 'package:final_project/constants/colors.dart';
import 'package:final_project/firebase_options.dart';
import 'package:final_project/routes/route_name.dart';
import 'package:final_project/routes/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

  final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.dark);
  final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
    );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, _) {
     return MaterialApp(
      scaffoldMessengerKey:scaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
        themeMode: currentMode,

         theme: ThemeData.light().copyWith(
            scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(backgroundColor:Colors.white),
            colorScheme: ColorScheme.light(
              primary: myPurple,
              secondary: myYellow,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: myYellow,
                foregroundColor: myPurple,
              ),
            ),
            textTheme: ThemeData.light().textTheme.apply(
              bodyColor: Colors.black,
              displayColor: Colors.black,
            ),
          ),


        darkTheme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.black,
          appBarTheme: AppBarTheme(backgroundColor:Colors.black),
          colorScheme: ColorScheme.dark(
            primary: myPurple,
            secondary: myYellow
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: myYellow,
      foregroundColor: myPurple,
    ),
  ),
          textTheme: ThemeData.dark().textTheme.apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          )// themeData textTheme

        ), //themeData

        routes: AppRoutes.routes,
        initialRoute: RouteName.initRouteName,
    );
  });
}
}