import 'dart:math';
import 'package:mgm_app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mgm_app/models/vaccList.dart';


class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  CollectionReference vaccTaken = Firestore.instance.collection('User');

  Future regUserData(String email) async {
    return await vaccTaken.document(uid).setData({
      'email': email,
    });
  }

  Future updateUserData(String vaccName,String dateAdmin) async {
   return await vaccTaken.document(uid).collection('VaccineAdministered').document().setData({
     'name': vaccName,
      'vaccine given': dateAdmin,
  }
 );
  }
  //vacc list from snapshot

  UserData _userDataFromSnapshot(DocumentSnapshot ds) {
    print(ds.data);
    return UserData(
      uid: uid,
      name: ds.data['name'],
      vaccineName: ds.data['vaccine given'],
    );
    
  }

  Stream<List<UserData>> get userData {
  return vaccTaken
      .document(uid)
      .collection('Vaccine Administered')
      .getDocuments()
      .asStream()
      .map((qs) {
    return qs.documents.map((ds) => _userDataFromSnapshot(ds));
  });
}


  
    //get vacc stream
    
  }


//get vacc stream
