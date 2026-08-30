import 'package:final_project/models/room_state_enum.dart';

class Room {
  final String? roomId;
  final String creatorName;
  final String creatorId;
  final String? opponentName;
  final String? opponentId;
  final RoomState roomState;
  Room({
    required this.roomId,
    required this.creatorName,
    required this.creatorId,
    this.roomState = RoomState.waiting,
    this.opponentName,
    this.opponentId
  });
}