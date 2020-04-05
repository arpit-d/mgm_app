import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mgm_app/screens/home/dr_pages/appt.dart';
import 'package:mgm_app/services/auth.dart';

void main() => runApp(MaterialApp(
  home: DrHome(),
));
class DrHome extends StatefulWidget {
  @override
  _DrHomeState createState() => _DrHomeState();
}

class _DrHomeState extends State<DrHome> {
   final AuthService _auth = AuthService();

   FirebaseUser user;


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Dashboard'),
        backgroundColor: Colors.blueGrey,
        actions: <Widget>[
              FlatButton.icon(onPressed: ()async{
                await _auth.signOut();
              }, 
              icon: Icon(Icons.person), 
              label: Text('logout'))
        ]
      ),
      body: DrHomePage(),
    );
  }
}
class DrHomePage extends StatefulWidget {
  @override
  _DrHomePageState createState() => _DrHomePageState();
}

class _DrHomePageState extends State<DrHomePage> {
  final AuthService _auth = AuthService();

   FirebaseUser currentUser;

  

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
                      MaterialPageRoute(builder: (context) => Appt()),
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Appt()),
                    );
                  },
              
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
                      MaterialPageRoute(builder: (context) => Appt()),
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
              ],
            ),
          ),
     );
  }
}