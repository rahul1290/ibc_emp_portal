import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ibcportal/common/appbarPage.dart';
import 'package:ibcportal/dbhelper.dart';
import 'package:ibcportal/common/global.dart' as global;
import 'package:http/http.dart' as http;
import 'dart:async';

class HalfDayRequest extends StatefulWidget {
  @override
  _HalfDayRequestState createState() => _HalfDayRequestState();
}

class _HalfDayRequestState extends State<HalfDayRequest> {
  final dbhelper = Databasehelper.instance;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool loader = false;
  String leaveFrom;
  String ReasonLeave;
  TextEditingController _leaveFrom;


  @override
  void initState() {
    super.initState();
    _leaveFrom = TextEditingController();
  }


    Future<void> _successDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('Request sent',style: TextStyle(color: Colors.lightGreen),),),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Your half day request submitted successfully.'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              color: Colors.greenAccent,
              child: Text('Ok'),
              onPressed: () => {
                _formkey.currentState.reset(),
                //Navigator.popAndPushNamed(context, '/esdashboard')
                Navigator.pop(context),
                Navigator.pop(context)
              },
            ),
          ],
        );
      },
    );
  }


  Future<void> _errorDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('Alert!',style: TextStyle(color: Colors.redAccent),),),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Your half day request not submitted.\n try again.'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              color: Colors.redAccent,
              child: Text('Ok'),
              onPressed: () => {
                //_formkey.currentState.reset(),
                //Navigator.popAndPushNamed(context, '/esdashboard')
                Navigator.pop(context),
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _logoutDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('Alert!',style: TextStyle(color: Colors.redAccent),),),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Your session has been expired.\n Please login again.'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              color: Colors.redAccent,
              child: Text('Ok'),
              onPressed: () => {
                dbhelper.deletedata(),
                Navigator.pushReplacementNamed(context, '/login'),
              },
            ),
          ],
        );
      },
    );
  }


  void _formSubmit() async {
    final FormState form = _formkey.currentState;
    form.save();

    List <dynamic> userdetail = await dbhelper.get(1);
    String url = global.baseUrl+"/user/half_day-requests";
    Map<String, String> headers = {"Content-type": "application/json","ibckey":userdetail[0]['key']};

    String json = '{"date":"'+ leaveFrom +'","reason":"'+ ReasonLeave +'"}';
    http.Response response = await http.post(url, headers: headers, body: json);
    int statusCode = response.statusCode;

    if(statusCode == 200){
      setState(() {
        loader = true;
      });
      _successDialog();
    } else if(statusCode == 500){
      _errorDialog();
    } else if(statusCode == 404){
      _logoutDialog();
    }
  }

  Widget _buildLeaveFrom(){
    return TextFormField(
      controller: _leaveFrom,
      readOnly: true,
      decoration: InputDecoration(
          labelText: 'Half Day Leave Date',
          suffixIcon: GestureDetector(
            onTap: ()=>{
              showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020, 11),
                lastDate: DateTime(2021,12),
              ).then((selectedDate) {
                if(selectedDate!=null){
                  final DateTime now = selectedDate;
                  final DateFormat formatter = DateFormat('dd/MM/yyyy');
                  final String formatted = formatter.format(now);
                  _leaveFrom.text = formatted;
                }
              })
            },
            child: Icon(Icons.calendar_today),
          )),
      onSaved: (String value){
        leaveFrom = value;
      },
      validator: (String value){
        if(value.isEmpty){
          return 'Select date';
        }
      },
    );
  }


  Widget _buildReason(){
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Reason for Half Day',
      ),
      keyboardType: TextInputType.multiline,
      onSaved: (String value){
        ReasonLeave = value;
      },
      validator: (String value){
        if(value.isEmpty){
          return 'Give reason for Half day';
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppbarPage('Half Day Leave'),
        body: loader ? Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(height: 15.0,),
                Text('  Loading...',style: TextStyle(color: Colors.redAccent,fontWeight: FontWeight.bold,),),
              ],
            ),
          ),
          //child: CircularProgressIndicator(),
        ):
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              Container(
                height: 30.0,
                width: MediaQuery.of(context).size.width,
                color: Colors.deepOrange[50],
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.all(8.0),
                  children: <Widget>[
                    Container(
                      child: InkWell(
                        onTap: (){
                          Navigator.pushNamed(context, '/dashboard');
                        },
                        child: Row(
                          children: <Widget>[
                            Text('Dashboard',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black87),),
                            Text(' >> ',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red),)
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: InkWell(
                        onTap: (){
                          Navigator.pushNamed(context, '/esdashboard');
                        },
                        child: Row(
                          children: <Widget>[
                            Text('Employee Section',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black87),),
                            Text(' >> ',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red),)
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Text('Half Day Leave',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue[900]),),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Form(
                      key: _formkey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 10),
                          _buildLeaveFrom(),
                          _buildReason(),
                          SizedBox(height: 10),
                          RaisedButton(
                              color: Colors.lightGreen,
                              splashColor: Colors.red,
                              child: Text('Submit',style: TextStyle(color: Colors.white, fontSize: 16),),
                              onPressed: (){
                                if(_formkey.currentState.validate()){
                                  _formSubmit();
                                }
                              }),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}