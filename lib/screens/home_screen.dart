import 'package:final_project/models/player.dart';
import 'package:final_project/models/room.dart';
import 'package:final_project/routes/route_name.dart';
import 'package:final_project/services/auth_service.dart';
import 'package:final_project/services/player_service.dart';
import 'package:final_project/services/room_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authservice = AuthService();
  final RoomService _roomService = RoomService();
  final PlayerService _playerService = PlayerService();

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset("lib/assets/logo.svg", width: 300, height: 300),
            Container(
              margin: EdgeInsets.all(30),
              padding: EdgeInsets.symmetric(vertical: 50, horizontal: 40),
              height: MediaQuery.of(context).size.height * .35,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        RouteName.availableRoomsRouteName,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(80, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text("Join a room"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RouteName.profileRouteName);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(80, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text("Profile"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await _authservice.logout();

                      Navigator.pushNamed(context, RouteName.loginRouteName);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(80, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text("Logout"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Create a room"),
                content: Text("You're going to make your own room , create?"),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancle"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final roomId = await _roomService.createRoom(
                        Room(
                          roomId: null,
                          creatorName: player!.username,
                          creatorId: _authservice.getUid(),
                        ),
                      );
                      Navigator.pushNamed(
                        context,
                        RouteName.roomRouteName,
                        arguments: roomId,
                      );
                    },
                    child: Text("Create a room"),
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: Color.fromARGB(255, 255, 215, 0),
        icon: IconButton(
          onPressed: () {},
          icon: Icon(Icons.add, color: Color.fromARGB(255, 176, 38, 255)),
        ),
        label: Text(
          "Create your own room",
          style: TextStyle(color: Color.fromARGB(255, 176, 38, 255)),
        ),
      ),
    );
  }
}
