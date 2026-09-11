import 'package:final_project/constants/colors.dart';
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

  Future<void> getPlayer() async {
    player = await _playerService.getUser(_authservice.getUid());
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: SingleChildScrollView(
        child: player == null
            ? Center(child: CircularProgressIndicator())
            : Card(
              color: myPurple,
              margin: EdgeInsets.all(50),
              child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: myYellow,
                            child: player == null ? Center(child: CircularProgressIndicator(),): Text(player!.username.substring(0,2).toUpperCase(),style: TextStyle(fontSize: 25,color: Colors.black),),
                          ),
                          Text(
                            player!.username,
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.black
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          "Player Satatistics",
                          style: TextStyle(
                            fontSize: 20,
                            color: const Color.fromARGB(255, 72, 70, 70),
                            letterSpacing: 5,

                          ),
                        ),
              
                        SizedBox(
                          height: 100,
                          width: MediaQuery.of(context).size.width,
                          child: Card(
                            color: myYellow,
                            margin: EdgeInsets.all(20),
              
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
              
                              children: [
                                Text(
                                  "Win games : ",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black
                                  ),
                                ),
                                Text(
                                  "${player!.wins}",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 100,
                          width: MediaQuery.of(context).size.width,
              
                          child: Card(
                            color: myYellow,
              
                            margin: EdgeInsets.all(20),
              
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
              
                              children: [
                                Text(
                                  "draw games : ",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black
                                  ),
                                ),
                                Text(
                                  "${player!.draws}",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 100,
                          width: MediaQuery.of(context).size.width,
              
                          child: Card(
                            color: myYellow,
              
                            margin: EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
              
                              children: [
                                Text(
                                  "lose games : ",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black
                                  ),
                                ),
                                Text(
                                  "${player!.loses}",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
            ),
      ),
    );
  }
}
