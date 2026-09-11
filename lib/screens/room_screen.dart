import 'package:final_project/constants/colors.dart';
import 'package:final_project/main.dart';
import 'package:final_project/models/room.dart';
import 'package:final_project/models/room_state_enum.dart';
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
  bool _navigatedToGame = false;

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
          return const Center(child: Text("Something went wrong"));
        }
        if(!snapshot.hasData){
          WidgetsBinding.instance.addPostFrameCallback((_) {
            scaffoldMessengerKey.currentState?.showSnackBar(
              SnackBar(content: Text("The room was cancelled"))
            );
            Navigator.pushNamedAndRemoveUntil(context, RouteName.homeRouteName, (route)=>false);
          });
          return Center(child: CircularProgressIndicator(),);
        }
        if (snapshot.hasData) {
          final room = snapshot.data!;
          if (room.roomState == RoomState.playing &&
              _authService.getUid() == room.opponentId && !_navigatedToGame) {
                _navigatedToGame=true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushNamed(
                context,
                RouteName.gameRouteName,
                arguments: roomId,
              );
            });
            
          }
          if (room.opponentId == null &&
              _authService.getUid() != room.creatorId) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushNamed(context, RouteName.availableRoomsRouteName);
            });
          }
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
                              color: myPurple,
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
                            room.opponentName ?? "Waiting for the\n opponent",
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
                              color: myYellow,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _authService.getUid() == room.creatorId
                          ? Container(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,

                                    children: [
                                      ElevatedButton(
                                        onPressed: room.opponentId != null
                                            ? () async {
                                                await _roomService
                                                    .updateTurnStartAt(roomId);

                                                await _roomService
                                                    .updateRoomState(
                                                      roomId,
                                                      RoomState.playing,
                                                    );
                                                Navigator.pushReplacementNamed(
                                                  context,
                                                  RouteName.gameRouteName,
                                                  arguments: roomId,
                                                );
                                              }
                                            : null,
                                        child: Text(
                                          "Start Game",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: room.opponentId != null
                                            ? () async {
                                                await _roomService
                                                    .updateOpponentId(
                                                      roomId,
                                                      null,
                                                    );
                                                await _roomService
                                                    .updateOpponentName(
                                                      roomId,
                                                      null,
                                                    );
                                                await _roomService
                                                    .updateRoomState(
                                                      roomId,
                                                      RoomState.waiting,
                                                    );
                                              }
                                            : null,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,

                                          children: [
                                            Text(
                                              "kick Player",
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            Icon(Icons.person_remove),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      await _roomService.deleteRoom(roomId);
                                    },
                                    child: Text("Cancel room",style: TextStyle(fontSize: 20),),
                                  ),
                                ],
                              ),
                            )
                          : ElevatedButton(
                              onPressed: () async {
                                await _roomService.updateOpponentId(
                                  roomId,
                                  null,
                                );
                                await _roomService.updateOpponentName(
                                  roomId,
                                  null,
                                );
                                await _roomService.updateRoomState(
                                  roomId,
                                  RoomState.waiting,
                                );
                                Navigator.pushNamed(
                                  context,
                                  RouteName.availableRoomsRouteName,
                                );
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,

                                children: [
                                  Text(
                                    "Leave game",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Icon(Icons.exit_to_app),
                                ],
                              ),
                            ),
                    ],
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
