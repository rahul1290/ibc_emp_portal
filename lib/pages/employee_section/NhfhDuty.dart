import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ibcportal/common/appbarPage.dart';
import 'package:ibcportal/dbhelper.dart';
import 'package:ibcportal/common/global.dart' as global;
import 'package:http/http.dart' as http;
import 'dart:async';

class NhfhDuty extends StatefulWidget {
  @override
  _NhfhDutyState createState() => _NhfhDutyState();
}

class _NhfhDutyState extends State<NhfhDuty> {
  final dbhelper = Databasehelper.instance;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool loader = false;
  String date;
  String requirement;
  String dropdownValue;
  TextEditingController _requirement;
  bool _btnStatus = false;
  String punchTime = '';
  // List _nhfh;
  List _nhfh = [{"name": "26/01/2020 (Republic Day)","id": "26/01/2020"},
                {"name": "02/10/2020 (Gandhi Jayanti)","id": "02/10/2020"},
                {"name": "25/10/2020 (Vijayadashmi)","id": "25/10/2020"},
                {"name": "14/11/2020 (Diwali)","id": "14/11/2020"},
                {"name": "15/11/2020 (Govardhan Puja)","id": "15/11/2020"}];

  @override
  void initState() {
    super.initState();
   // _nhfhList();
    _requirement = TextEditingController();
  }

  void _nhfhList() async {
    print('fucntion called');
    List <dynamic> userdetail = await dbhelper.get(1);
    String url = global.baseUrl+"nhfhs";
    print(url);
    Map<String, String> headers = {"Content-type": "application/json","ibckey":userdetail[0]['key']};
    http.Response response = await http.get(url, headers: headers);
    int statusCode = response.statusCode;
    if(statusCode == 200){
      _nhfh = jsonDecode(response.body);
    } else if(statusCode == 500){

    }
  }

  void _checkAttendance() async {
    print('function called');
    List <dynamic> userdetail = await dbhelper.get(1);
    String url = global.baseUrl+"user-attendance/date";
    Map<String, String> headers = {"Content-type": "application/json","ibckey":userdetail[0]['key']};
    String json = '{"date":"'+ dropdownValue +'"}';
    http.Response response = await http.post(url, headers: headers, body: json);
    int statusCode = response.statusCode;
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
    String url = global.baseUrl+"user-nhfh-duty";
    print(url);
    Map<String, String> headers = {"Content-type": "application/json","ibckey":userdetail[0]['key']};

    String json = '{"date":"'+ dropdownValue +'","requirement":"'+ requirement +'"}';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppbarPage('Nh / Fh Duty'),
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
                          Text('Nh/Fh Duty',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue[900]),),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Date:'),
                              DropdownButton(
                                items: _nhfh.map((item){
                                  return DropdownMenuItem(
                                    child: Text(item['name']),
                                    value: item['id'].toString(),
                                  );
                                }).toList(),
                                onChanged: (newVal) {
                                  setState(() {
                                    dropdownValue = newVal;
                                    _checkAttendance();
                                  });
                                },
                                value: dropdownValue ?? null,
                              )
                            ],
                          ),
                          _btnStatus ? Text(punchTime,style: TextStyle(color: Colors.redAccent),) : Text(punchTime,style: TextStyle(color: Colors.redAccent,),),
                          TextFormField(
                          controller: _requirement,
                          decoration: InputDecoration(
                              labelText: 'Requirement',
                          ),
                          onSaved: (String value){
                            requirement = value;
                          },
                          validator: (String value){
                            if(value.isEmpty){
                              return 'Give Requirement';
                            }
                          },
                        ),
                          SizedBox(height: 30),
                          RaisedButton(
                              color: Colors.lightGreen,
                              splashColor: Colors.red,
                              child: Text('Send',style: TextStyle(color: Colors.white, fontSize: 16),),
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