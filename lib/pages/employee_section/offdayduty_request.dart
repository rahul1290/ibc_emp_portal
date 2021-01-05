import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ibcportal/common/appbarPage.dart';
import 'package:ibcportal/dbhelper.dart';
import 'package:ibcportal/common/global.dart' as global;
import 'package:http/http.dart' as http;
import 'dart:async';

class OffdayDutyRequest extends StatefulWidget {
  @override
  _OffdayDutyRequestState createState() => _OffdayDutyRequestState();
}

class _OffdayDutyRequestState extends State<OffdayDutyRequest> {
  final dbhelper = Databasehelper.instance;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool loader = false;
  bool _btnStatus = false;
  String dutyDate;
  String Requirment;
  String punchTime = '';
  int wod = 7;
  String radioButtonItem;
  TextEditingController _dutyDate;


  @override
  void initState() {
    super.initState();
    _dutyDate = TextEditingController();
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
                Text('Your Off day duty request submitted successfully.'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              color: Colors.greenAccent,
              child: Text('Ok'),
              onPressed: () => {
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
                Text('Your off day duty request not submitted.\n try again.'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              color: Colors.redAccent,
              child: Text('Ok'),
              onPressed: () => {
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

  void _checkAttendance() async {
    final FormState form = _formkey.currentState;
    form.save();

    List <dynamic> userdetail = await dbhelper.get(1);
    String url = global.baseUrl+"/user/attendance";
    Map<String, String> headers = {"Content-type": "application/json","ibckey":userdetail[0]['key']};

    String json = '{"date":"'+ dutyDate +'"}';
    http.Response response = await http.post(url, headers: headers, body: json);
    int statusCode = response.statusCode;
    print(statusCode);
    if(statusCode == 200){
      setState(() {
        Map body = jsonDecode(response.body);
        punchTime = 'In-time:'+ body['in_time'] +'Out-time:'+ body['in_time'] + 'Hours:'+ body['hours'];
        _btnStatus = true;
      });
    } else if(statusCode == 500){
      setState(() {
        punchTime = 'No punch record.';
        _btnStatus = false;
      });
    }
  }

  void _formSubmit() async {
    final FormState form = _formkey.currentState;
    form.save();
    List <dynamic> userdetail = await dbhelper.get(1);
    String url = global.baseUrl+"/user/half_day-requests";
    Map<String, String> headers = {"Content-type": "application/json","ibckey":userdetail[0]['key']};

    String json = '{"date":"'+ dutyDate +'","requirement":"'+ Requirment +'","wod":"'+ wod.toString() +'"}';
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
      controller: _dutyDate,
      readOnly: true,
      decoration: InputDecoration(
          labelText: 'Off Day Duty Date',
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
                  _dutyDate.text = formatted;
                  _checkAttendance();
                }
              })
            },
            child: Icon(Icons.calendar_today),
          )),
      onSaved: (String value){
        dutyDate = value;
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
        labelText: 'Requirement',
      ),
      keyboardType: TextInputType.multiline,
      onSaved: (String value){
        Requirment = value;
      },
      validator: (String value){
        if(value.isEmpty){
          return 'Give requirement for off day duty';
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppbarPage('Off Day Duty'),
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
                height: 35.0,
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
                          Text('Off Day Duty',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue[900]),),
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 10),
                          _buildLeaveFrom(),
                          _btnStatus ? Text(punchTime,style: TextStyle(color: Colors.redAccent),) : Text(punchTime,style: TextStyle(color: Colors.redAccent,),),
                          _buildReason(),
                          SizedBox(height: 10),

                          Text('Week Of Day',style: TextStyle(color: Colors.blueGrey),),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              //mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Radio(
                                  value: 1,
                                  groupValue: wod,
                                  onChanged: (val) {
                                    setState(() {
                                      radioButtonItem = 'MON';
                                      wod = 1;
                                    });
                                  },
                                ),
                                Text('MON',style: TextStyle(fontSize: 10.0,),),
                                Radio(
                                  value: 2,
                                  groupValue: wod,
                                  onChanged: (val) {
                                    setState(() {
                                      radioButtonItem = 'TUE';
                                      wod = 2;
                                    });
                                  },
                                ),
                                Text('TUE',style: TextStyle(fontSize: 10.0),),
                                Radio(
                                  value: 3,
                                  groupValue: wod,
                                  onChanged: (val) {
                                    setState(() {
                                      radioButtonItem = 'WED';
                                      wod = 3;
                                    });
                                  },
                                ),
                                Text('WED',style: TextStyle(fontSize: 10.0),),
                                Radio(
                                  value: 4,
                                  groupValue: wod,
                                  onChanged: (val) {
                                    setState(() {
                                      radioButtonItem = 'THU';
                                      wod = 4;
                                    });
                                  },
                                ),
                                Text('THU',style: TextStyle(fontSize: 10.0),),
                                Radio(
                                  value: 5,
                                  groupValue: wod,
                                  onChanged: (val) {
                                    setState(() {
                                      radioButtonItem = 'FRI';
                                      wod = 5;
                                    });
                                  },
                                ),
                                Text('FRI',style: TextStyle(fontSize: 10.0),),

                                Radio(
                                  value: 6,
                                  groupValue: wod,
                                  onChanged: (val) {
                                    setState(() {
                                      radioButtonItem = 'SAT';
                                      wod = 6;
                                    });
                                  },
                                ),
                                Text('SAT',style: TextStyle(fontSize: 10.0),),

                                Radio(
                                  value: 7,
                                  groupValue: wod,
                                  onChanged: (val) {
                                    setState(() {
                                      radioButtonItem = 'SUN';
                                      wod = 7;
                                    });
                                  },
                                ),
                                Text('SUN',style: TextStyle(fontSize: 10.0),),
                              ],
                            ),
                          ),

                          RaisedButton(
                              color: Colors.lightGreen,
                              splashColor: Colors.red,

                              child: Text('Submit',style: TextStyle(color: Colors.white, fontSize: 16),),
                              onPressed: _btnStatus ? (){
                                if(_formkey.currentState.validate()){
                                  _formSubmit();
                                }
                              } : null ),
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