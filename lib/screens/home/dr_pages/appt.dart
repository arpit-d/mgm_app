import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mgm_app/screens/home/consult_followup.dart';
import 'package:mgm_app/screens/home/dr_pages/diagnosis.dart';

void main() => runApp(MaterialApp(
      home: Appt(),
    ));

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

  showModalContent(context, userName, type) {
    
    return showModalBottomSheet(context: context, builder: (BuildContext bc) {
      final _formKey = GlobalKey<FormState>();
      return Form(
        key: _formKey,
        child: Container(
         
          child: Column(
             mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
             Center(
               child: Text('Patient Diagnosis Card')
             ),
             SizedBox(height: 15),
             Padding(
               padding: const EdgeInsets.only(left: 10),
               child: Text(
                 'Patient Name: $userName'
               ),
             ),
             SizedBox(height: 15),
             Text(
               'Appointment Type: $type'
             ),
             
            ],
          )
        ),
      );
    }
    );
  }

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
                                  
                              return Card(
                                child: InkWell(
                                  splashColor: Colors.blueGrey.withAlpha(80),
                                  onTap: () {
                                    showModalContent(context,userName,type);
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
                                        title:
                                            Text('Time: ' + user.data['time']),
                                      )
                                    ],
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

