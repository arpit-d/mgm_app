import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mgm_app/models/user.dart';
import 'package:mgm_app/services/auth.dart';
import 'package:mgm_app/screens/home/home.dart';
import 'package:provider/provider.dart';
class VaccList{

  final String vaccName, vaccDesc, vaccNext, vaccId;
  final int ageGroup;
  final List vaccine;

  VaccList({this.vaccName, this.ageGroup, this.vaccId, this.vaccDesc, this.vaccine, this.vaccNext});

  
}
final polio = VaccList(
    vaccName: 'Polio',
    ageGroup: 1, // less than 18
    vaccId: '1',
    vaccNext: vaccNext(),
  );
  final hepA = VaccList(
    vaccName: 'Hepatitis-A',
    ageGroup: 1, // less than 18
    vaccId: '2',
    vaccNext: vaccNext(),
  );
  final hepB = VaccList(
    vaccName: 'Hepatitis-B',
    ageGroup: 2, // greater than 18
    vaccId: '3',
    vaccNext: vaccNext(),
  );

vaccNext(){}