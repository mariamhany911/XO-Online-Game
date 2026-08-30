import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth =FirebaseAuth.instance;

 Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential?> register({required String email ,required String password}) async{

    try{
    final user = await  _auth.createUserWithEmailAndPassword(
      email: email,
       password: password
       );
    return user;
    }

    on FirebaseAuthException catch (e){
      print(e.message);
      return null;
    }

  }
  Future<UserCredential?> login({ required String email , required String password }) async{
    try{
    final user = await  _auth.signInWithEmailAndPassword(
      email: email,
       password: password
       );
    return user;
    }
    on FirebaseAuthException catch (e){
      print(e.message);
      return null;
    }
  }

  Future<void> logout(){
    return _auth.signOut();
  }

  String getUid(){
    return _auth.currentUser!.uid;
  }

}