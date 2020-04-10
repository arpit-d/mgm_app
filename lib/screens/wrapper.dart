import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mgm_app/screens/authenticate/authenticate.dart';
import 'package:mgm_app/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:mgm_app/models/user.dart';
import 'package:provider/provider.dart';

import 'home/dr_pages/dr_home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    
   
    if(user == null){
      return Authenticate();
    }
    else if(user.uid == 'JFolRdBc9iVASTD9MztQziwt8tw2' || user.uid=='MBophNUiUkTSJgFt39YylbfD6Rz1'){
      return DrHome();
    }
    else {
    return Home();
    }
  }
    
}   