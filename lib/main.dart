import 'package:final_project/firebase_options.dart';
import 'package:final_project/routes/route_name.dart';
import 'package:final_project/routes/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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
    final myPurple = Color.fromARGB(255, 176, 38, 255);
    final myYellow = Color.fromARGB(255, 255, 215, 0);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,

        darkTheme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.black,

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
}
}