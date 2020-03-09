import 'package:mgm_app/screens/authenticate/authenticate.dart';
import 'package:mgm_app/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:mgm_app/models/user.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    if(user == null){
      return Authenticate();
    }
    else{
      return Home();
    }

    
    // return either the Home or Authenticate widget
   // return Authenticate();
    
  }
}