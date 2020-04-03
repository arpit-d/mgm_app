
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mgm_app/models/user.dart';
import 'package:mgm_app/services/auth.dart';
import 'package:mgm_app/notification/NotificationManager.dart';
import 'package:mgm_app/services/moor_database.dart';
import 'package:mgm_app/shared/loading.dart';
import 'package:provider/provider.dart';

void main ()=> runApp(MaterialApp(
  home: PillHome(),
));

final MyDatabase database = MyDatabase();
final NotificationManager notificationManager = NotificationManager();
class PillHome extends StatefulWidget {
  @override
  _PillHomeState createState() => _PillHomeState();
}

class _PillHomeState extends State<PillHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pill Reminder'),
        backgroundColor: Colors.red[400],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()  {
          return bottSheet(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red[400],
      ),
      body: PillBody(),
    );
  }
  void bottSheet(context) async {
    showModalBottomSheet(context: context, builder: (BuildContext bc){
      return ModalContent();
    });
  }
}
class ModalContent extends StatefulWidget {
  @override
  _ModalContentState createState() => _ModalContentState();
}

class _ModalContentState extends State<ModalContent> {
  static final _formKey = new GlobalKey<FormState>();
  String _name;
  String _dose;
  NotificationManager manager = NotificationManager();
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.fromLTRB(25, 20, 25, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Add New Medicine',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // back to main screen
                    Navigator.pop(context, null);
                  },
                  child: Icon(
                    Icons.close,
                    size: 30,
                    color: Theme.of(context).primaryColor.withOpacity(.65),
                  ),
                )
              ],
            ),
            _buildForm(),
            SizedBox(
              height: 5,
            ),
            
            SizedBox(
              height: 15,
            ),
            Container(
              width: double.infinity,
              child: RaisedButton(
                padding: EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                ),
                onPressed: () {
                  _submit(manager);
                },
                color: Theme.of(context).accentColor,
                textColor: Colors.white,
                highlightColor: Theme.of(context).primaryColor,
                child: Text(
                  'Add Medicine'.toUpperCase(),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ));
  }


   _buildForm() {
    TextStyle labelsStyle =
        TextStyle(fontWeight: FontWeight.w400, fontSize: 25);
    return SingleChildScrollView(
          child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              style: TextStyle(fontSize: 25),
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: labelsStyle,
              ),
              validator: (input) => (input.length < 5) ? 'Name is short' : null,
              onSaved: (input) => _name = input,
            ),
            TextFormField(
              style: TextStyle(fontSize: 25),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Dose',
                labelStyle: labelsStyle,
              ),
              validator: (input) => (input.length > 50) ? 'Dose is long' : null,
              onSaved: (input) => _dose = input,
            )
          ],
        ),
      ),
    );
  }

  void _submit(NotificationManager manager) async {
    final AuthService _auth = AuthService();
    if (_formKey.currentState.validate()) {
      // form is validated
      _formKey.currentState.save();
      print(_name);
      print(_dose);
      //show the time picker dialog
      showTimePicker(
        initialTime: TimeOfDay.now(),
        context: context,
      ).then((selectedTime) async {
        int hour = selectedTime.hour;
        int minute = selectedTime.minute;
        var hm = hour.toString()+':'+minute.toString();
        print(selectedTime);
        // insert into database
        await _auth.enterPillData(_name, _dose, hm);
        // sehdule the notification
        manager.showNotificationDaily(1,_name, _dose, hour, minute);
        // The medicine Id and Notitfaciton Id are the same
        
        // go back
        Navigator.pop(context);
      });
    }
  }
}
class PillBody extends StatefulWidget {
  
  @override
  _PillBodyState createState() => _PillBodyState();
}

class _PillBodyState extends State<PillBody> {
 CollectionReference vacc = Firestore.instance.collection('User');

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return SingleChildScrollView(
          child: Container(
          child: StreamBuilder(
              stream: vacc
                  .document(user.uid)
                  .collection('PillReminder')
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
                          
                                  child: Container(
                                    child: ListTile(
                                      title: Text(user.data['name'],
                                          style: TextStyle(fontSize: 14)),
                                      subtitle: Text(user.data['dose']),
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
                    child: Text('No reminder set'),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              })),
    );
  }

}

class MedicineGridView extends StatefulWidget {
  final List<MedicinesTableData> list;
  MedicineGridView(this.list);

  @override
  _MedicineGridViewState createState() => _MedicineGridViewState();
}

class _MedicineGridViewState extends State<MedicineGridView> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 1,
      shrinkWrap: true,
      childAspectRatio: 5,
      children: widget.list.map((medicine){
        return MedicineCard(medicine);
      }).toList(),
    );
  }
}

class MedicineCard extends StatefulWidget {
  final MedicinesTableData medicine;
  MedicineCard(this.medicine);

  @override
  _MedicineCardState createState() => _MedicineCardState();
}

class _MedicineCardState extends State<MedicineCard> {
  Future<void> _deleteReminder(context,medicine) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Delete Reminder?'),
          actions: <Widget>[
            FlatButton(
              child: Text('No',
              style: TextStyle(
                fontSize: 19,
                color: Colors.black87,
              ),
            ),
              onPressed: (){
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Yes',
              style: TextStyle(
                fontSize: 19,
              ),
            ),
              onPressed: (){
                _deleteCard(medicine,context);

              },
            ),
          ],
        );
      }
    );
  }

  _deleteCard(medicine,context) async{
    await database.deleteMedicine(medicine);
     notificationManager.removeReminder(medicine.id);
    print("medicine deleted" + medicine.toString());
    Navigator.of(context).pop();
    

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: InkWell(

        onTap: (){
          _deleteReminder(context,widget.medicine);
        },
          child: Card(
            margin: EdgeInsets.all(4),
          child: ListTile(
            title: Text(widget.medicine.name),
            subtitle: Text(widget.medicine.dose),
          ),
        ),
      ),
      
    );
  }
}

