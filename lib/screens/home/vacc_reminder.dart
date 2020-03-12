import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mgm_app/services/database.dart';
import 'package:provider/provider.dart';
import 'package:mgm_app/services/auth.dart';
import 'package:mgm_app/models/vaccList.dart';
import 'package:mgm_app/screens/home/vacc_tile.dart';
import 'dart:async';
import 'package:mgm_app/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner:false,
  home: VaccHome(),
));
class VaccHome extends StatefulWidget {
  @override
  _VaccHomeState createState() => _VaccHomeState();
}

class Vaccine {
  String vaccName;
  //String date;
  Vaccine(this.vaccName);

  static List<Vaccine> getVaccine(){
    return <Vaccine>[
      Vaccine('Rabies'),
      Vaccine('Ebola'),
      Vaccine('SARS'),
      Vaccine('Polio'),
      Vaccine('Chickenpox'),
      Vaccine('Hepatatis A'),
      Vaccine('Hepatatis B'),
    ];
  }
  }

class _VaccHomeState extends State<VaccHome> {
  

 void  _bottSheet(context) async {
     showModalBottomSheet(
      context: context,
      builder: (BuildContext bc){
        return ModalContent(
        );
      }
    ); 
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vaccination Reminder'),
        backgroundColor: Color(0xFF05b39e),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _bottSheet(context);
        },
        child: Icon(Icons.add),
        backgroundColor:  Color(0xFF05b39e),
      ),
      body: VaccBody(),
      
    );
  }
}



class ModalContent extends StatefulWidget {
  @override
  _ModalContentState createState() => _ModalContentState();
}

class _ModalContentState extends State<ModalContent> {
final _formKey = GlobalKey<FormState>();
  DateTime _dateTime;
  VaccList v = new VaccList();
  List<Vaccine> _vaccines = Vaccine.getVaccine();
  List<DropdownMenuItem<Vaccine>> _dropDownMenuItems;
  Vaccine _selectedVaccine;
  @override
  void initState(){
    _dropDownMenuItems = buildDropdownMenuItems(_vaccines);
    _selectedVaccine = _dropDownMenuItems[0].value;
    super.initState();
  }

  List<DropdownMenuItem<Vaccine>> buildDropdownMenuItems(List vaccines) {
    List<DropdownMenuItem<Vaccine>> items = List();
    for(Vaccine vaccine in vaccines) {
      items.add(DropdownMenuItem(value: vaccine, child: Text(vaccine.vaccName),));
    }
    return items;
  }

  onChangeDropdownItem(Vaccine selectedVaccine) {
    setState(() {
      _selectedVaccine = selectedVaccine;

    });
  }
  var converted;

  
  
  String convertDate(DateTime _dateTime){
    var dateTime = DateTime.parse(_dateTime.toString());
    var formattedDate = "${dateTime.day}-${dateTime.month}-${dateTime.year}";
    return formattedDate;
  }

final AuthService _auth = AuthService();


  @override
  Widget build(BuildContext context) {
     return Container(
 
          padding: EdgeInsets.fromLTRB(5,5, 5, 5),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 15),
                  Text(
                    "Select vaccine you have been given!",
                    style: TextStyle(
                      fontSize: 20,
                      
                    ),
                    ),
                  
                  SizedBox(height: 20),
                  DropdownButton(
                    value: _selectedVaccine,
                    items: _dropDownMenuItems,
                    onChanged: onChangeDropdownItem,
                     
                  ),
                  SizedBox(height: 20),
                  Text('Selected: ${_selectedVaccine.vaccName}'),
                  SizedBox(height: 20),
                  RaisedButton(
                    child: Text('Pick a Date'),
                    onPressed: (){
                      showDatePicker(context: context, initialDate: _dateTime == null?DateTime.now():_dateTime,
                       firstDate: DateTime(2000), 
                       lastDate: DateTime.now()
                       ).then((date){
                         setState((){
                           _dateTime = date;
                            converted = convertDate(_dateTime);
                         });
                       });
                      
                    },
                  
                  ),
                  
                  SizedBox(height: 20),

                  Text(
                    '$converted',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 20),
                  RaisedButton(
                    onPressed:() async {
                     await _auth.enterVaccineData(_selectedVaccine.vaccName, converted);
                    },
                    child: Text('Submit'),
                  )
                    
                  



                ],
         ),
            )
         
        );
  }

  

}
class VaccBody extends StatefulWidget {
  @override
  _VaccBodyState createState() => _VaccBodyState();
}



class _VaccBodyState extends State<VaccBody> {
  
  @override
  Widget build(BuildContext context) {
    CollectionReference vaccTaken = Firestore.instance.collection('User');
    final user = Provider.of<User>(context);
    var uid=user.uid;
    print(uid);
    return StreamBuilder(
      stream: vaccTaken.document(uid).collection('Vaccine Administered').snapshots(),
      builder: (context,snapshot) {
        if(snapshot.hasData){
          return Container(
          child: Column(
            children: <Widget>[
              Expanded(child: ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index){
                  print(snapshot.data);
                  DocumentSnapshot user = snapshot.data.documents[index];
                  return Text(
                    'data is there'
                    //title: Text(user.data['name']),
                    //subtitle: Text(user.data['vaccine given']),
                  );
                  
                }
              ))
            ],
          )
        );
        }else if (snapshot.connectionState == ConnectionState.done && !snapshot.hasData) {
        // Handle no data
        return Center(
            child: Text("No users found.")
        );
      }
      else {
        return CircularProgressIndicator();
      }
      }
    );
  }
}




