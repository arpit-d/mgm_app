import 'package:firebase_auth/firebase_auth.dart';
import 'package:mgm_app/models/user.dart';
import 'package:mgm_app/services/database.dart';

class AuthService{
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  //create user obj based on firebaseUser
  User _userFromFirebaseUser(FirebaseUser user){
    return user != null ? User(uid: user.uid) : null;
  }
  //auth change user stream
  Stream<User> get user{
    return _auth.onAuthStateChanged
      .map(_userFromFirebaseUser);
  }

  //sign in anon
  Future signInAnon() async {
    try{
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
      
    } 
    catch(e){
      print(e.toString());
      return null;
    }
  }
  //sign in with email/pass 
  Future signInWithEmailAndPassword(String email, String password) async {
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }
Future<String> inputData() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String userName = user.email.toString();
    return userName;
  }

 
  Future enterConsultationData(String type,String realDate, String hm) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
      final String uid = user.uid.toString();
      await DatabaseService(uid: user.uid).updateUserData(type, realDate, hm);
      return _userFromFirebaseUser(user);
  }

  Future enterPillData(String name,String dose, String hm) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
      final String uid = user.uid.toString();
      await DatabaseService(uid: user.uid).updatePillData(name, dose, hm);
      return _userFromFirebaseUser(user);
  }

  //register with email/pass
  Future registerWithEmailAndPassword(String email, String password, String userName, String dateTime, String deviceToken) async {
    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      String uid = user.uid.toString();
      //create new document for user with their uid
      await DatabaseService(uid: user.uid).regUserData(email,userName, dateTime, uid);
      return _userFromFirebaseUser(user);
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }
  //sign out
  Future signOut() async{
    try{
      return await _auth.signOut();
    }
    catch(e){
      print(e.toString());
    }
  }

}