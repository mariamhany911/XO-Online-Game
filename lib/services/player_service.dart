import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/models/player.dart';

class PlayerService{

  final FirebaseFirestore _instance = FirebaseFirestore.instance;

  Future<void> createUser(String uid , Player player) async{
    try{
      await _instance.collection("players").doc(uid).set({
        'username':player.username,
        'wins': player.wins,
        'loses': player.loses,
        'draws': player.draws
      });
    }
    catch (e){
      print(e);
    }
  }
  Future<Player?> getUser(String uid) async{
    try{
      final result = await _instance.collection("players").doc(uid).get();
      if (result.exists) {
      return Player(
        username: result['username'],
        wins: result['wins'],
        loses: result['loses'],
        draws: result['draws'],
      );
    }
      return null;

    }
    catch (e){
      print(e);
      return null;
    }
  }

  Future<void> updateWins(String uid ) async{
    try{
      await _instance.collection("players").doc(uid).update({"wins":FieldValue.increment(1)});
    }
    catch (e){
      print(e);
    }
  } 
  Future<void> updateLoses(String uid) async{
    try{
      await _instance.collection("players").doc(uid).update({"loses":FieldValue.increment(1)});
    }
    catch (e){
      print(e);
    }
  } 
  Future<void> updateDraws(String uid ) async{
    try{
      await _instance.collection("players").doc(uid).update({"draws":FieldValue.increment(1)});
    }
    catch (e){
      print(e);
    }
  } 

}