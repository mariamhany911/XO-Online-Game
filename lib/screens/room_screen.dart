import 'package:final_project/models/room.dart';
import 'package:final_project/routes/route_name.dart';
import 'package:final_project/services/auth_service.dart';
import 'package:final_project/services/room_service.dart';
import 'package:flutter/material.dart';

class RoomScreen extends StatefulWidget {
  const RoomScreen({super.key});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  final RoomService _roomService = RoomService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final roomId = ModalRoute.of(context)!.settings.arguments as String;

    return StreamBuilder<Room?>(
      stream: _roomService.streamRoom(roomId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text("Somethimg went wrong"));
        }
        if (snapshot.hasData) {
          final room = snapshot.data!;
          return Scaffold(
            appBar: AppBar(title: Text("Game Room")),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Player 1",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                          Text(
                            room.creatorName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "X",
                            style: TextStyle(
                              fontSize: 60,
                              color: Color.fromARGB(255, 176, 38, 255),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "Player 2",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                          Text(
                            room.opponentName ?? "Waiting for the opponent",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "O",
                            style: TextStyle(
                              fontSize: 60,
                              color: Color.fromARGB(255, 255, 215, 0),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed:
                        _authService.getUid() == room.creatorId &&
                            room.opponentId != null
                        ? () {
                            Navigator.pushNamed(
                              context,
                              RouteName.gameRouteName,
                              arguments: roomId
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(minimumSize: Size(200, 60)),
                    child: Text("Start Game", style: TextStyle(fontSize: 30)),
                  ),
                ],
              ),
            ),
          );
        }
        return const Center(child: Text("Room not found"));
      },
    );
  }
}
