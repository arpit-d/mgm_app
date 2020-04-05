import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:mgm_app/notification/NotificationManager.dart';
import 'package:mgm_app/services/database.dart';
import 'package:provider/provider.dart';
import 'package:mgm_app/services/auth.dart';
import 'package:mgm_app/models/vaccList.dart';
import 'package:mgm_app/screens/home/vacc_tile.dart';
import 'dart:async';
import 'package:mgm_app/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ConsultFollowUp(),
    ));

class ConsultFollowUp extends StatefulWidget {
  @override
  _ConsultFollowUpState createState() => _ConsultFollowUpState();
}

class _ConsultFollowUpState extends State<ConsultFollowUp> {
  void _bottSheet(context) async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return ModalContent();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consultation Follow Up Reminder'),
        backgroundColor: Color(0xFF05b39e),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF05b39e),
        child: Icon(Icons.add),
        onPressed: () {
          _bottSheet(context);
        },
      ),
      body: ConsultFollowUpBodyPage(),
    );
  }
}

class ConsultFollowUpBodyPage extends StatefulWidget {
  @override
  _ConsultFollowUpBodyPageState createState() =>
      _ConsultFollowUpBodyPageState();
}

class _ConsultFollowUpBodyPageState extends State<ConsultFollowUpBodyPage> {
  CollectionReference vacc = Firestore.instance.collection('User');

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    print(user.name);
    return Container(
        child: StreamBuilder(
            stream: vacc
                .document(user.uid)
                .collection('ConsultReminder')
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
                                  subtitle: Text(user.data['date'] + ' at ' + user.data['time']),
                                ),
                              );
                            }),
                      ),
                      
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

class ApptMent {
  String type;
  ApptMent(this.type);
  static List<ApptMent> getApptType() {
    return <ApptMent>[
      ApptMent('Emergency'),
      ApptMent('Routine Checkup'),
      ApptMent('Eye checkup'),
      ApptMent('Dentist Visit'),
      ApptMent('Full Body Checkup Tests'),
      ApptMent('Minor Illness'),
      ApptMent('Dermatologist'),
    ];
  }
}

class ModalContent extends StatefulWidget {
  @override
  _ModalContentState createState() => _ModalContentState();
}

class _ModalContentState extends State<ModalContent> {
  NotificationManager manager = NotificationManager();
  final _formKey = GlobalKey<FormState>();
  DateTime _apptDateTime;
  var d = DateTime.now();
  List<ApptMent> _appt = ApptMent.getApptType();
  List<DropdownMenuItem<ApptMent>> _dropDownMenuItems;
  ApptMent _selectedAppt;
  @override
  void initState() {
    _dropDownMenuItems = buildDropdownMenuItems(_appt);
    _selectedAppt = _dropDownMenuItems[0].value;
    super.initState();
  }

  List<DropdownMenuItem<ApptMent>> buildDropdownMenuItems(List appts) {
    List<DropdownMenuItem<ApptMent>> items = List();
    for (ApptMent appt in appts) {
      items.add(DropdownMenuItem(
        value: appt,
        child: Text(appt.type),
      ));
    }
    return items;
  }

  onChangeDropdownItem(ApptMent selectedAppt) {
    setState(() {
      _selectedAppt = selectedAppt;
    });
  }

  _submit(NotificationManager manager, dayNo) {
    manager.showApptNoti(
        1,
        'Consultation Reminder',
        'Your have a ' +
            _selectedAppt.type +
            ' appointment today at ' +
            hour.toString() +
            ':' +
            minute.toString(),
        hour,
        minute,
        dayNo);
  }

  getDayNo(_date) {
    var dayNo = d.weekday;
    return dayNo;
  }

  getRealDate(_date) {
    var day = DateFormat('EEEE').format(_date);
    print(day);
    var realDate = '${_date.day} - ${_date.month} - ${_date.year} : $day';
    print(realDate);
    return realDate;
  }
  getDrDate(_date) {
    var drDate = '${_date.day}-${_date.month}-${_date.year}';
    print('$drDate');
    return drDate;
  }

  int hour, minute, _hour, _minute;
  var hm;
  var _date;
  var _selected;
  var realDate;
  firstDateFunc(d) {
    var currentYear = DateTime(d.year);
    return currentYear;
  }

  lastDateFunc(d) {
    var weekFromNow = d.add(Duration(days: 7));

    return weekFromNow;
  }

  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Container(
          child: Column(
            //mainAxisSize: MainAxisSize.max,
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              DropdownButton(
                elevation: 4,
                value: _selectedAppt,
                items: _dropDownMenuItems,
                onChanged: onChangeDropdownItem,
                icon: Tab(icon: Image.asset("lib/assets/list.png")),
              ),
              SizedBox(height: 20),
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                elevation: 4.0,
                onPressed: () {
                  showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now().subtract(Duration(days: 0)),
                          lastDate: lastDateFunc(d))
                      .then((date) {
                    setState(() {
                      _date = date;
                      realDate = getRealDate(_date);
                    });
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.date_range,
                                  size: 18.0,
                                  color: Colors.teal,
                                ),
                                Text(
                                  realDate == null ? '' : ' $realDate',
                                  style: TextStyle(
                                      color: Colors.teal,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Text(
                        "  Change",
                        style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
                color: Colors.white,
              ),
              SizedBox(
                height: 20.0,
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                elevation: 4.0,
                onPressed: () {
                  showTimePicker(
                    initialTime: TimeOfDay.now(),
                    context: context,
                  ).then(
                    (selectedTime) async {
                      hour = selectedTime.hour;
                      minute = selectedTime.minute;
                      setState(() {
                        print(selectedTime);
                        _hour = hour;
                        _minute = minute;
                        hm = (' ' + hour.toString() + ':' + minute.toString());
                      });
                    },
                  );
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.access_time,
                                  size: 18.0,
                                  color: Colors.teal,
                                ),
                                Text(
                                  hm == null ? '' : '$hm',
                                  style: TextStyle(
                                      color: Colors.teal,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Text(
                        " Change",
                        style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
                color: Colors.white,
              ),
              SizedBox(height: 20),
              Center(
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  elevation: 4.0,
                  onPressed: () async {
                    var dateNo = getDayNo(_date);
                    if(realDate == null || hm == null){
                      Text('Invalid');
                    }else {
                    _submit(manager, dateNo);
                    await _auth.enterConsultationData(
                        _selectedAppt.type, realDate, hm);
                        await _auth.drConsult(
                        _selectedAppt.type, realDate, hm, getDrDate(_date), user.name);
                        print('hello');
                        Navigator.of(context).pop();
                    }
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
                                        'Book Appointment',
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
            ],
          ),
        ),
      ),
    );
  }
}
