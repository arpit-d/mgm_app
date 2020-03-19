import 'dart:math';
import 'package:mgm_app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mgm_app/models/vaccList.dart';


class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  CollectionReference vaccTaken = Firestore.instance.collection('User');

  Future regUserData(String email, String userName, String converted) async {
    return await vaccTaken.document(uid).setData({
      'email': email,
      'userName': userName,
      'dob': converted,
    });
  }

  Future updateUserData(String vaccName,String dateAdmin) async {
   return await vaccTaken.document(uid).collection('VaccineAdministered').document().setData({
     'name': vaccName,
      'vaccine given': dateAdmin,
  }
 );
  } 
  
}


