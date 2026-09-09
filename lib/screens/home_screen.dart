import 'package:final_project/constants/colors.dart';
import 'package:final_project/main.dart';
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
      appBar:AppBar(
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            radius: 10,
            backgroundColor: myPurple,
            child: Text(player!.username.substring(0,2).toUpperCase()),
          ),
        ),
        title: Text("Home",style: TextStyle(fontWeight: FontWeight.bold),),
        actions: [

          ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, _) {
    final isDark = currentMode == ThemeMode.dark;
    return Row(
      children: [
        Icon(
          Icons.light_mode,
        ),
        Switch(
          value: isDark,
          onChanged: (value) {
            themeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
          },
        ),
        Icon(
          Icons.dark_mode,
        ),
      ],
    );
      },
    ),
        ],
      ),
      
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset("lib/assets/logo.svg", width: 300, height: 300,),
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
        backgroundColor: myYellow,
        icon: IconButton(
          onPressed: () {},
          icon: Icon(Icons.add, color: myPurple),
        ),
        label: Text(
          "Create your own room",
          style: TextStyle(color: myPurple),
        ),
      ),
    );
  }
}
