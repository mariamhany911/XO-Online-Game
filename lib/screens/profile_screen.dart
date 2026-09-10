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

  Future<void> getPalyer() async {
    player = await _playerService.getUser(_authservice.getUid());
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
      appBar: AppBar(title: Text("Profile")),
      body: SingleChildScrollView(
        child: player == null
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        Text(
                          "Player Name",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                            letterSpacing: 5,
                          ),
                        ),
                        Text(
                          player!.username,
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: myYellow,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(height: 80),
                      Text(
                        "Player Satatistics",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                          letterSpacing: 5,
                        ),
                      ),

                      SizedBox(
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          color: myPurple,
                          margin: EdgeInsets.all(20),

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              Text(
                                "Win games : ",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "${player!.wins}",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
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
                          color: myPurple,

                          margin: EdgeInsets.all(20),

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              Text(
                                "draw games : ",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "${player!.draws}",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
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
                          color: myPurple,

                          margin: EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              Text(
                                "lose games : ",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "${player!.loses}",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
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
    );
  }
}
