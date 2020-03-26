import 'dart:math';
import 'package:mgm_app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mgm_app/models/vaccList.dart';


class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  CollectionReference vaccTaken = Firestore.instance.collection('User');

  Future regUserData(String email, String userName, String dateTime, String deviceToken) async {
    return await vaccTaken.document(uid).setData({
      'email': email,
      'userName': userName,
      'dob': dateTime,
      'deviceToken': deviceToken
    });
  }

  Future updateUserData(String pillName,String startTime, String reminderTime) async {
   return await vaccTaken.document(uid).collection('PillReminder').document().setData({
     'name': pillName,
      'startTime': startTime,
      'reminderTime': reminderTime,
  }
 );
  } 
  
}


