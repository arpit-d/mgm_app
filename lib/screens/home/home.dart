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
  home: Home(),
  theme: new ThemeData(
        primaryColor: const Color(0xFF43a047),
        accentColor: const Color(0xFFffcc00),
        primaryColorBrightness: Brightness.dark,
      ),
));

class Home extends StatefulWidget {
  
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
 

  final AuthService _auth = AuthService();
  

    
  
  @override
  Widget build(BuildContext context) {

    
 

    
    return Scaffold(
        appBar: AppBar(
            title: Text('MGM Hospital'),
            backgroundColor: Colors.red[400],
            actions: <Widget>[
              FlatButton.icon(onPressed: ()async{
                await _auth.signOut();
              }, 
              icon: Icon(Icons.person), 
              label: Text('logout'))
            ]
        ),
        body: BodyPage(),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.red
                ),
                child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                      child: Text('Hello ',
                      style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
               ),
              ),
              ListTile(
                title: Text('Profile'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Profile()),
                  );
                },
              )
            ],
          ),
        ),
      ); 
    
  }
}
class BodyPage extends StatefulWidget {
  @override
  _BodyPageState createState() => _BodyPageState();
}

class _BodyPageState extends State<BodyPage> {

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
          child: Center(
            child: Column(
         // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
            // VACCINATION REMINDER
                Card(
              margin: EdgeInsets.fromLTRB(12, 25, 12, 6),
              child: InkWell(
                  splashColor: Colors.red.withAlpha(80),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => VaccHome()),
                    );
                  },
              
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    contentPadding: EdgeInsets.fromLTRB(11, 3, 3, 3),
                    title: Text(
                      'Vaccination Reminder',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0
                      ),
                      ),
                      subtitle: Text(
                        'List of all types of vaccinations administered from birth to present age',
                        style: TextStyle(
                          fontSize: 17
                        ),
                      ),
                      isThreeLine: true,
                  ),
                ],
              ),
            ),
            ),
            Divider(
              height: 6.0,
              color: Colors.grey,
            ),
            //PILL REMINDER
            Card(
              margin: EdgeInsets.fromLTRB(12, 10, 12, 7),
              child: InkWell(
                  splashColor: Colors.red.withAlpha(80),
                  // onTap: () {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => PillHome()),
                  //   );
                  // },
              
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    contentPadding: EdgeInsets.fromLTRB(11, 3, 3, 3),
                    title: Text(
                      'Pill Reminder',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0
                      ),
                      ),
                      subtitle: Text(
                        'Pills you have to take and at what time and quantity',
                        style: TextStyle(
                          fontSize: 17
                        ),
                      ),
                  ),
                ],
              ),
            ),
            ),
            Divider(
              height: 6.0,
              color: Colors.grey,
            ),
            //CONSULT FOLLOW UP
            Card(
              margin: EdgeInsets.fromLTRB(12, 10, 12, 6),
              child: InkWell(
                  splashColor: Colors.red.withAlpha(80),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ConsultFollowUp()),
                    );
                  },
              
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    contentPadding: EdgeInsets.fromLTRB(11, 3, 3, 3),
                    title: Text(
                      'Consultation Follow Up Reminder',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0
                      ),
                      ),
                      subtitle: Text(
                        'Details of last and any future consultations',
                        style: TextStyle(
                          fontSize: 17
                        ),
                      ),
                  ),
                ],
              ),
            ),
            ),
            Divider(
              height: 6.0,
              color: Colors.grey,
            ),
            //PATIENT HISTORY
            Card(
              margin: EdgeInsets.fromLTRB(12, 10, 12, 6),
              child: InkWell(
                  splashColor: Colors.red.withAlpha(80),
                  onTap: () {
                   Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MedHist()),
                    );
                  },
              
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    contentPadding: EdgeInsets.fromLTRB(11, 3, 3, 3),
                    title: Text(
                      'Patient Medical History',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0
                      ),
                      ),
                      subtitle: Text(
                        'Details of all past illness and treatments taken at MGM',
                        style: TextStyle(
                          fontSize: 17
                        ),
                      ),
                  ),
                ],
              ),
            ),
            ),
            Divider(
              height: 6.0,
              color: Colors.grey,
            ),
            //DISCHARGE SUMMARY
            Card(
              margin: EdgeInsets.fromLTRB(12, 10, 12, 6),
              child: InkWell(
                  splashColor: Colors.red.withAlpha(80),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DischargeSum()),
                    );
                  },
              
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    contentPadding: EdgeInsets.fromLTRB(11, 3, 3, 3),
                    title: Text(
                      'Discharge Summary',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0
                      ),
                      ),
                      subtitle: Text(
                        'Details of last discharge with all medical notes and payments bills',
                        style: TextStyle(
                          fontSize: 17
                        ),
                      ),
                  ),
                ],
              ),
            ),
            ),
            SizedBox(
              height: 8,
            ),
            Divider(
              height: 6.0,
              color: Colors.grey,
            ),
            //NEARBY HOSPITAL
            Card(
              margin: EdgeInsets.fromLTRB(12, 10, 12, 6),
              child: InkWell(
                  splashColor: Colors.red.withAlpha(80),
                  onTap: () {
                   Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HospLocation()),
                    );
                  },
              
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    contentPadding: EdgeInsets.fromLTRB(11, 3, 3, 3),
                    title: Text(
                      'Nearby Hospital',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0
                      ),
                      ),
                      subtitle: Text(
                        'Location of nearby hospital',
                        style: TextStyle(
                          fontSize: 17
                        ),
                      ),
                  ),
                ],
              ),
            ),
            ),
          ],
        ),
        ),
    );
    
  }
}