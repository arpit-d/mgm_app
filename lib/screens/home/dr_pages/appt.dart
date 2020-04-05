import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

 void main()=> runApp(MaterialApp(
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
        title: Text('Daily Appointments'),
        backgroundColor: Colors.blueGrey
      ),
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
  String getDate(){
    return '${date.day}-${date.month}-${date.year}';
  }
  
  CollectionReference vacc = Firestore.instance.collection('DrConsult');
  @override
  Widget build(BuildContext context) {
    return Container(
        child: StreamBuilder(
            stream: vacc
                .document('data')
                .collection(getDate())
                .snapshots(),
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
                              return Card(
                                child: ListTile(
                                  title: Text(user.data['type'],
                                      style: TextStyle(fontSize: 14)),
                                  //subtitle: Text(user.data['date'] + ' at ' + user.data['time']),
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
                  child: Text('No reminder set'),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }));
  }
}