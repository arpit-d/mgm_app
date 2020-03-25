import 'package:intl/intl.dart';
import 'package:mgm_app/screens/home/profile.dart';
import 'package:mgm_app/services/auth.dart';
import 'package:mgm_app/services/database.dart';
import 'package:mgm_app/shared/loading.dart';
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
 	
import 'package:intl/intl.dart';
void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner:false,
  home: VaccHome(),
));
class VaccHome extends StatefulWidget {
  @override
  _VaccHomeState createState() => _VaccHomeState();
}

class _VaccHomeState extends State<VaccHome> {
  VaccList vacc = VaccList();
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
VaccList vacc = VaccList();
  FirebaseUser currentUser;
  String bdayResult;
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
        this.bdayResult = result;
       });
      });
    });
  }

  Future<String> email(user) async {
    var d;
    if (user != null) {
      await Firestore.instance.collection('User').document(user.uid).get().then((data){
        d = (data.data['dob']);  
      });
      return d;
    } else {
      return "no current user";
    }
  }
  String age;
  String bday(){
    if(bdayResult!=null){
    var userBday = bdayResult.split('-');
    print(userBday);
    var userB=userBday[2];
    DateTime n = DateTime.now();
    var nYear = n.year.toString();
    var a = int.parse(nYear);
    var b = int.parse(userB);
    int realAge = a-b;
    print(realAge);
    //DateTime parsedBday = DateTime.parse('$userBday');
    return realAge.toString();
  }else {
    return 'helllo';
  
  }
  }
   
   nextDose(){
     var ageNow = bday();
     print(ageNow);
   }

  @override
  Widget build(BuildContext context) {
    CollectionReference vacc = Firestore.instance.collection('Vaccine');
    if(bdayResult == null){
      return Loading();
    }
    else {
      var t = bday();
    print('$t');
    if (int.parse(t) > 18) {
    return Container(
          child: Column(
            children: <Widget>[
              Text('$bdayResult'),
              StreamBuilder(
        stream: vacc.document('18-plus').collection('Data').snapshots(),
        builder: (context,snapshot) {
              if(snapshot.hasData){
                return Container(
                  child: Column(
                    children: <Widget>[
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (BuildContext context, int index){
                        print(snapshot.data);
                        DocumentSnapshot user = snapshot.data.documents[index];
                        return Card(
                                                  child: ListTile(
                            
                              title: Text(user.data['name'],
                              style: TextStyle(fontSize: 14)),
                              subtitle: Text(user.data['dose']),
                          ),
                        );
                        
                      })
                    ],
                  ),
                );
              }else if (snapshot.connectionState == ConnectionState.done && !snapshot.hasData){
                return Center(
                  child: Text('No vaccine'),
                );
              }else {
                return CircularProgressIndicator();
              }
        }
      ),
            ],
          ),
    );
  } else if (int.parse(t)<18){
    return Container(
          child: Column(
            children: <Widget>[
              Text('$bdayResult'),
              StreamBuilder(
        stream: vacc.document('Birth').collection('Data').snapshots(),
        builder: (context,snapshot) {
              if(snapshot.hasData){
                return Container(
                  child: Column(
                    children: <Widget>[
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (BuildContext context, int index){
                        print(snapshot.data);
                        DocumentSnapshot user = snapshot.data.documents[index];
                        return Card(
                                                  child: ListTile(
                            
                              title: Text(user.data['name'],
                              style: TextStyle(fontSize: 14)),
                              subtitle: Text(user.data['dose']),
                          ),
                        );
                        
                      })
                    ],
                  ),
                );
              }else if (snapshot.connectionState == ConnectionState.done && !snapshot.hasData){
                return Center(
                  child: Text('No vaccine'),
                );
              }else {
                return CircularProgressIndicator();
              }
        }
      ),
            ],
          ),
    );
  }
  else {
    return Text('no');
  }
  }
  }
}




