import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/models/room.dart';
import 'package:final_project/models/room_state_enum.dart';

class RoomService {
  final FirebaseFirestore _instance = FirebaseFirestore.instance;

  Future<String?> createRoom(Room room) async {
    try {
      final result = await _instance.collection("rooms").add({
        'creatorName': room.creatorName,
        'creatorId': room.creatorId,
        'opponentName': room.opponentName,
        'opponentId': room.opponentId,
        'roomState': room.roomState.name,
      });
      return result.id;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Room?> getRoom(String roomId) async {
    try {
      final result = await _instance.collection("rooms").doc(roomId).get();
      if (result.exists) {
        return Room(
          roomId: roomId,
          creatorName: result['creatorName'],
          creatorId: result['creatorId'],
          roomState: RoomState.values.byName(result['roomState']),
        );
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> updateOpponentName(String roomId, String opponentName) async {
    try {
      await _instance.collection("rooms").doc(roomId).update({
        "opponentName": opponentName,
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateOpponentId(String roomId, String opponentId) async {
    try {
      await _instance.collection("rooms").doc(roomId).update({
        "opponentId": opponentId,
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateRoomState(String roomId, RoomState roomState) async {
    try {
      await _instance.collection("rooms").doc(roomId).update({
        "roomState": roomState.name,
      });
    } catch (e) {
      print(e);
    }
  }

  Future<List<Room>> getAvailableRooms() async {
    final snapshot = await _instance
        .collection("rooms")
        .where('roomState', whereIn: ["waiting", "playing"])
        .get();
    List<Room> availableRooms = [];
    for (final doc in snapshot.docs) {
      final room = Room(
        roomId: doc.id,
        creatorName: doc["creatorName"],
        creatorId: doc["creatorId"],
        roomState: RoomState.values.byName(doc["roomState"]),
      );
      availableRooms.add(room);
    }
    return availableRooms;
  }

  Stream<Room?> streamRoom(String roomId){
    return _instance.collection("rooms").doc(roomId).snapshots()
    .map((doc){

      if(!doc.exists){
        return null;
        }
        
        return Room(
       roomId: doc.id,
        creatorName: doc["creatorName"],
        creatorId: doc["creatorId"],
        opponentName: doc["opponentName"],
        opponentId: doc["opponentId"],
        roomState: RoomState.values.byName(doc["roomState"])
        );
        });
  }
}
