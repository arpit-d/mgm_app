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
      //.map((FirebaseUser user) => _userFromFirebaseUser(user));
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

  Future enterVaccineData(String vaccName, String dateAdmin) async {
    try{
      final FirebaseUser user = await FirebaseAuth.instance.currentUser();
      final String uid = user.uid.toString();
      await DatabaseService(uid: user.uid).updateUserData(vaccName, dateAdmin);
      return _userFromFirebaseUser(user);

    }
    catch(e){

    }
  }

  //register with email/pass
  Future registerWithEmailAndPassword(String email, String password, String userName, String dateTime) async {
    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      //create new document for user with their uid
      await DatabaseService(uid: user.uid).regUserData(email,userName, dateTime);
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