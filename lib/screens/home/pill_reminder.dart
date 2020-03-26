
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mgm_app/services/auth.dart';


void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner:false,
  home: PillHome(),
));
class PillHome extends StatefulWidget {
  @override
  _PillHomeState createState() => _PillHomeState();
}

class _PillHomeState extends State<PillHome> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  _getToken(){
    _firebaseMessaging.getToken().then((deviceToken) {
      print('$deviceToken');
    });
  }
  _configureFirebaseListeners() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message ) async {
        print('onMessage: $message');
      },
      onLaunch: (Map<String, dynamic> message ) async {
        print('onMessage: $message');
      },
      onResume: (Map<String, dynamic> message ) async {
        print('onMessage: $message');
      },
    );
  }
  @override
  void initState() {
    super.initState();
    _getToken();
    _configureFirebaseListeners();
  }
  void  _bottSheet(context) async {
     showModalBottomSheet(
      context: context,
      builder: (BuildContext bc){
        return ModalContent();
      }
    ); 
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Pill Reminder'),
        backgroundColor: Color(0xFF05b39e),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _bottSheet(context);
        },
        child: Icon(Icons.add),
        backgroundColor:  Color(0xFF05b39e),
      ),
        body: PillBodyPage(),
    );
  }
}

class ModalContent extends StatefulWidget {
  @override
  _ModalContentState createState() => _ModalContentState();
}

class _ModalContentState extends State<ModalContent> {
  String convertDate(DateTime _dateTime) {
    
    var dateTime = DateFormat('dd-MM-yyyy');
    var formattedDate = dateTime.format(_dateTime);
    print(formattedDate);
    return formattedDate;
  }
   _dateStart(context) async {
     return await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: (DateTime(2020)), lastDate: (DateTime.now().add(Duration(days: 7)))).then((date){
       setState(() {
       var reminderT = date;
       starTime = convertDate(reminderT);


     });
     });
     
  }
  _dateEnd(context) async {
     return await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: (DateTime(2020)), lastDate: (DateTime.now().add(Duration(days: 7)))).then((date){
       setState(() {
       var reminderT = date;
       reminderTime = convertDate(reminderT);


     });
     });
     
  }
  final _formKey = GlobalKey<FormState>();
  var reminderTime;
  var starTime;
  String pillName;
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      
          child: Container(
            
        padding: EdgeInsets.all(5),
        child: Form(
          
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Pill Name:'
                ),
                onChanged: (val) {
                  setState(() {
                    pillName = val;
                  });
                },
              ),
              SizedBox(height: 15),
              GestureDetector(
                onTap: () {
                  return  _dateStart(context);
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Date',
                  ),
                ),)
                
              ),
              SizedBox(height: 15),
              GestureDetector(
                onTap: () {
                  return  _dateEnd(context);
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'End Date',
                  ),
                ),)
                
              ),
              Text('$starTime'),
              Text('$reminderTime'),
              MaterialButton(
                child: Text('Set Reminder'),
                onPressed: () async {
                  await _auth.enterPillData(pillName, starTime, reminderTime);
                },
              )
              
            ],
          ),
        ),
      ),
    );
  }
}

class DateT extends StatefulWidget {
  @override
  _DateTState createState() => _DateTState();
}

class _DateTState extends State<DateT> {
  @override
  Widget build(BuildContext context) {
    return Container(

    );
  }
}

class PillBodyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}

class Message {
  String title, body, message;
  Message({this.body,this.message,this.title});
}