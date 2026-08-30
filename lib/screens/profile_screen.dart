import 'package:final_project/models/player.dart';
import 'package:final_project/services/auth_service.dart';
import 'package:final_project/services/player_service.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  
  final PlayerService _playerService = PlayerService();
  final AuthService _authservice = AuthService();
  Player? player;

  Future<void> getPalyer()async {
      player =await _playerService.getUser(_authservice.getUid());
      setState(() {});
    }

  @override
  void initState() {
    super.initState();
    getPalyer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: player == null
    ? Center(
        child: CircularProgressIndicator(),
      )
    : Column(
        children: [
           Column(
            mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Player Name "),
                Text(player!.username)
              ],
            ),
          
          SizedBox(
            height: 100,
            child: Card(
              margin: EdgeInsets.all(20),
            
              child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
            
                children: [
                  Text("Win games : "),
                  Text("${player!.wins}")
                ],
              ),
            ),
          ),
          SizedBox(
            height: 100,

            child: Card(
              margin: EdgeInsets.all(20),
            
              child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
            
                children: [
                  Text("draw games : "),
                  Text("${player!.draws}")
                ],
              ),
            ),
          ),
          SizedBox(
            height: 100,

            child: Card(
            margin: EdgeInsets.all(20),
            child: Row(
            mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Text("lose games : "),
                Text("${player!.loses}")
              ],
            ),
          ),
      ),
        ],
      ),
    );
  }
}