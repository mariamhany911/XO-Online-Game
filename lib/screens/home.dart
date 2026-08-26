import 'package:final_project/routes/route_name.dart';
import 'package:final_project/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authservice = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Container(
        color: Colors.red,
        width: MediaQuery.of(context).size.width /2,
        child: IconButton(
          onPressed: (){
            _authservice.logout();
            Navigator.pushNamed(context, RouteName.loginRouteName);
          },
         icon: Icon(Icons.logout)),
       ) ,
      body: Column(
        children: [
          SvgPicture.asset(
            "lib/assets/logo",
            width: 100,
            height: 100,
            ),
        ],
      ),
    );
  }
}