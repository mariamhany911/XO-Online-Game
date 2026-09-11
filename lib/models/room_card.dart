import 'package:final_project/constants/colors.dart';
import 'package:final_project/models/room_state_enum.dart';
import 'package:final_project/routes/route_name.dart';
import 'package:final_project/services/auth_service.dart';
import 'package:final_project/services/player_service.dart';
import 'package:final_project/services/room_service.dart';
import 'package:flutter/material.dart';

class RoomCard extends StatelessWidget {

  final RoomService _roomService = RoomService();
  final AuthService _authService = AuthService();
  final PlayerService _playerService = PlayerService();


  final String creator;
  final String creatorId;
  final String state;
  final String roomId;

   RoomCard({
    super.key,
    required this.creator,
    required this.creatorId,
    required this.state,
    required this.roomId,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 3,
      height: MediaQuery.of(context).size.height / 3,
      child: Card(
        color: myPurple,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("Game Room"),
            Text("Owner : $creator"),
            Text("Status of room : $state "),
            ElevatedButton(
              onPressed: state=="waiting" && _authService.getUid()!=creatorId ? () async{

                final opponentId = _authService.getUid();
                final opponent = await _playerService.getUser(opponentId);

                await _roomService.updateOpponentId(roomId, opponentId);
                await _roomService.updateOpponentName(roomId, opponent!.username);
                await _roomService.updateRoomState(roomId,RoomState.ready);

                Navigator.pushNamed(
                  context,
                  RouteName.roomRouteName,
                  arguments: roomId,
                );
              }: null ,
              child: Text("Join"),
            ),
          ],
        ),
      ),
    );
  }
}
