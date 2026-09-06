import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/models/room_state_enum.dart';

class Room {
  final String? roomId;
  final String creatorName;
  final String creatorId;
  final String? opponentName;
  final String? opponentId;
  final RoomState roomState;
  final bool xTurn ;
  final List<String> board;
  final String? winnerId;
  final bool updateStat;
  final Timestamp? turnStartAt;
  Room({
    required this.roomId,
    required this.creatorName,
    required this.creatorId,
    this.roomState = RoomState.waiting,
    this.opponentName,
    this.opponentId,
    this.xTurn = true,
    this.updateStat = false,
    this.winnerId,
    this.turnStartAt,
    List<String>? board
  }):board=board??List.filled(9, "");
}