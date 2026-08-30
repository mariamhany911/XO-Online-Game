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

  Future<void> updateWins(String uid , int wins) async{
    try{
      await _instance.collection("players").doc(uid).update({"wins":wins});
    }
    catch (e){
      print(e);
    }
  } 
  Future<void> updateLoses(String uid , int loses) async{
    try{
      await _instance.collection("players").doc(uid).update({"loses":loses});
    }
    catch (e){
      print(e);
    }
  } 
  Future<void> updateDraws(String uid , int draws) async{
    try{
      await _instance.collection("players").doc(uid).update({"draws":draws});
    }
    catch (e){
      print(e);
    }
  } 

}