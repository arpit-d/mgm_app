import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mgm_app/models/user.dart';
import 'package:mgm_app/screens/home/consult_followup.dart';
import 'package:mgm_app/screens/home/dr_pages/diagnosis.dart';
import 'package:mgm_app/services/auth.dart';
import 'package:provider/provider.dart';

void main() => runApp(MaterialApp(
      home: Appt(),
    ));
var userUid;
class Appt extends StatefulWidget {
  @override
  _ApptState createState() => _ApptState();
}

class _ApptState extends State<Appt> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Daily Appointments'), backgroundColor: Colors.blueGrey),
      body: ApptHome(),
    );
  }
}

class Patient {
  String userN;
  String typ;
  Patient({this.userN, this.typ});
}

class ApptHome extends StatefulWidget {
  @override
  _ApptHomeState createState() => _ApptHomeState();
}

class _ApptHomeState extends State<ApptHome> {
  @override
  void initState() {
    super.initState();
    getRealDate();
  }

  DateTime date;
  getRealDate() {
    setState(() {
      this.date = DateTime.now();
    });
  }

  String getDate() {
    return '${date.day}-${date.month}-${date.year}';
  }

  String password = '';
  String email = '';
final AuthService _auth = AuthService();
  CollectionReference vacc = Firestore.instance.collection('DrConsult');
  @override
  Widget build(BuildContext context) {
    return Container(
        child: StreamBuilder(
            stream: vacc.document('data').collection(getDate()).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (BuildContext context, int index) {
                              print(snapshot.data);
                              DocumentSnapshot user =
                                  snapshot.data.documents[index];
                              var userName = user.data['patientName'];
                              var type = user.data['type'];
                              var time = user.data['time'];
                                  userUid = user.data['uid'];
                              var realTime = time.substring(0, time.indexOf(":"));
                              var realMin = time.substring(time.indexOf(':')+1,time.length-0);
                              
                              var rM = int.parse(realMin); // user appt min
                              var rT = int.parse(realTime); // user appt hour
                              
                              
                              return Card(
                                child: SingleChildScrollView(
                                  child: InkWell(
                                    splashColor: Colors.blueGrey.withAlpha(80),
                                    onTap: () { 
                                      var timeNow = TimeOfDay.now();
                                      
                                      var hr = timeNow.hour.toString();
                                      
                                      var realHr = int.parse(hr); // current hour
                                      
                                      var min = timeNow.minute.toString();
                                      var realMin = int.parse(min); // current min
                                      
                                      if (realHr > rT ) {
                                       return showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          builder: (context) =>
                                              SingleChildScrollView(
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom),
                                              child: DiagHome(
                                                  userN: userName, typ: type),
                                            ),
                                          ),
                                        );
                                      } else if (realHr == rT){
                                          if (realMin>rM) {
                                              return showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          builder: (context) =>
                                              SingleChildScrollView(
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom),
                                              child: DiagHome(
                                                  userN: userName, typ: type),
                                            ),
                                          ),
                                        );
                                          }
                                          else {
                                            return Scaffold.of(context).showSnackBar(new SnackBar(content: Text('Appt yet to start')));
                                          }
                                      }   
                                      else {
                                        return Scaffold.of(context).showSnackBar(new SnackBar(content: Text('Appt yet to start')));
                                      }
                                    },
                                    child: Column(
                                      children: <Widget>[
                                        ListTile(
                                          leading: Icon(Icons.person),
                                          title: Text('Patient Name: ' +
                                              user.data['patientName']),
                                        ),
                                        ListTile(
                                          leading: Icon(Icons.assignment),
                                          title: Text('Appointment Type: ' +
                                              user.data['type']),
                                        ),
                                        ListTile(
                                          leading: Icon(Icons.access_alarms),
                                          title: Text(
                                              'Time: ' + user.data['time']),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      )
                    ],
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.done &&
                  !snapshot.hasData) {
                return Center(
                  child: Text('No appointments set today'),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }));
  }
}

class DiagHome extends StatefulWidget {
  static final _formKey = new GlobalKey<FormState>();
  final String userN, typ;
  DiagHome({this.userN, this.typ});

  @override
  _DiagHomeState createState() => _DiagHomeState();
}

class _DiagHomeState extends State<DiagHome> {
  FirebaseUser currentUser;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  void _loadCurrentUser() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() { // call setState to rebuild the view
        this.currentUser = user;
      });
    });
  }

  String _userName() {
    if (currentUser != null) {
      print(currentUser.displayName);
      return currentUser.displayName.toString();
    } else {
      return "no current user";
    }
  }
  String diagnosis = '';

  String advice = '';
final AuthService _auth = AuthService();
  final Patient patient = Patient();

  @override
  Widget build(BuildContext context) {
    final docUser = Provider.of<User>(context);
    
    
    print(_userName().toString());
    return Container(
      child: Column(
        children: [
          Form(
            key: DiagHome._formKey,
            child: Column(
              children: <Widget>[
                Text('Diagnostic Report'),
                SizedBox(height: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Patient Name: ',
                              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
                        ),
                        Text('${widget.userN}', style: TextStyle(fontSize: 17))
                      ],
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${widget.typ}',style: TextStyle(fontSize: 18)),
                    ),
                    SizedBox(height: 20),

                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                            hintText: 'Diagnosis',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(7)))),
                        validator: (val) => val.isEmpty ? 'Enter diagnosis' : null,
                        onChanged: (val) {
                          setState(() {
                            diagnosis = val;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                            hintText: 'Advice',
                            focusColor: Colors.teal,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(7)))),
                        validator: (val) => val.isEmpty ? 'Enter advice' : null,
                        onChanged: (val) {
                          setState(() {
                            advice = val;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                  shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  elevation: 4.0,
                  onPressed: () async {
                    await _auth.consultReport(docUser.name, diagnosis, advice, userUid);
                        
                        Navigator.of(context).pop();
                  },
                  child: Container(
                      alignment: Alignment.center,
                      height: 50.0,
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Center(
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    
                                    children: <Widget>[
                                      Center(
                                        child: Text(
                                          'Send Report', textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                  ),
                  color: Colors.teal,
                ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
