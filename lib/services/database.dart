import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mgm_app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mgm_app/models/vaccList.dart';


class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  CollectionReference vaccTaken = Firestore.instance.collection('User');
  

  Future regUserData(String email, String userName, String dateTime, String uid) async {
    return await vaccTaken.document(uid).setData({
      'email': email,
      'userName': userName,
      'dob': dateTime,
      'uid': uid,
      'role': 'Patient'
    });
  }

  Future updatePillData(String name, String dose, String hm) async {
    return await vaccTaken.document(uid).collection('PillReminder').document().setData({
      'name': name,
      'dose': dose,
      'time': hm,
    });
  }

  Future updateUserData(String type,String realDate, String hm) async {
   return await vaccTaken.document(uid).collection('ConsultReminder').document().setData({
     'type': type,
      'date': realDate,
      'time': hm,
      
  }
 );
  } 
  
}


