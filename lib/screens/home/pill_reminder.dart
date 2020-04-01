
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mgm_app/services/auth.dart';
import 'package:mgm_app/notification/NotificationManager.dart';
import 'package:mgm_app/services/moor_database.dart';
import 'package:mgm_app/shared/loading.dart';

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
        print(selectedTime);
        // insert into database
        var medicineId = await database.insertMedicine(
            MedicinesTableData(
                name: _name,
                dose: _dose, id: null,));
        // sehdule the notification
        manager.showNotificationDaily(medicineId, _name, _dose, hour, minute);
        // The medicine Id and Notitfaciton Id are the same
        print('New Med id' + medicineId.toString());
        // go back
        Navigator.pop(context, medicineId);
      });
    }
  }
}
class PillBody extends StatefulWidget {
  
  @override
  _PillBodyState createState() => _PillBodyState();
}

class _PillBodyState extends State<PillBody> {

  Future<List<MedicinesTableData>> getMedicineList() async {
    return await database.getAllMedicines();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      
    });
    return buildMedicinesView();
    
  }

  

  FutureBuilder buildMedicinesView() {
    return FutureBuilder(
      future: getMedicineList(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data);
          if (snapshot.data.length == 0) {
            // No data
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'lib/assets/no_not.png',
                  height: 180,
                  width: 180,
                  fit: BoxFit.cover,
                ),
                
              ],
            );
          }
          return MedicineGridView(snapshot.data);
          
      } else {
        return Container();
      }
      }
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

