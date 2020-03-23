import 'package:mgm_app/screens/home/profile.dart';
import 'package:mgm_app/services/auth.dart';
import 'package:mgm_app/services/database.dart';
import 'package:provider/provider.dart';
import 'package:mgm_app/models/user.dart';
import 'vacc_reminder.dart';
import 'pill_reminder.dart';
import 'consult_followup.dart';
import 'patient_med.dart';
import 'discharge_summary.dart'; 
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mgm_app/screens/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'hosp_loc.dart';
import 'package:mgm_app/models/vaccList.dart';
void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner:false,
  home: VaccHome(),
));
class VaccHome extends StatefulWidget {
  @override
  _VaccHomeState createState() => _VaccHomeState();
}

class _VaccHomeState extends State<VaccHome> {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(title: Text('Vaccination Reminder'),
            backgroundColor: Colors.red[400]),
            body: VaccBody(),
                    
      );
  }
}

class VaccBody extends StatefulWidget {
  @override
  _VaccBodyState createState() => _VaccBodyState();
}

class _VaccBodyState extends State<VaccBody> {

  FirebaseUser currentUser;
 String emailResult;
  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  void _loadCurrentUser() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      email(user).then((String result) {
      setState(() { // call setState to rebuild the view
        this.currentUser = user;
        this.emailResult = result;
       });
      });
    });
  }

  Future<String> email(user) async {
    var d;
    if (user != null) {
      await Firestore.instance.collection('User').document(user.uid).get().then((data){
        d = (data.data['dob'].toString());  
      });
      return d;
    } else {
      return "no current user";
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('$emailResult'??'no'),
    );
  }
}




