import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ibcportal/common/appbarPage.dart';
import 'package:ibcportal/common/bottomnavigation.dart';
import 'package:ibcportal/common/drawerPage.dart';
import 'package:ibcportal/dbhelper.dart';
import 'dart:convert';
import 'dart:async';
import 'package:intl/intl.dart';

import 'package:json_table/json_table.dart';
import 'package:ibcportal/common/global.dart' as global;

class Attendance extends StatefulWidget {
  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceData {
  int _department = 0;
  int _month = 0;
  int _year = 0;
}

class _AttendanceState extends State<Attendance> {

  final dbhelper = Databasehelper.instance;
  bool loader = true;
  bool tableloader = true;
  var jsonTable;
  String DefaultDept = '1';
  String Defaultuser;
  String Defaultmonth;
  String Defaultyear;
  List Users = List();
  List Departments  = List();
  List Month = [{'id':1,'name': 'Jan'},
                {'id':2,'name': 'Feb'},
                {'id':3,'name': 'Mar'},
                {'id':4,'name': 'Apr'},
                {'id':5,'name': 'May'},
                {'id':6,'name': 'Jun'},
                {'id':7,'name': 'Jul'},
                {'id':8,'name': 'Aug'},
                {'id':9,'name': 'Sep'},
                {'id':10,'name': 'Oct'},
                {'id':11,'name': 'Nov'},
                {'id':12,'name': 'Dec'}];
  List Year = [
                {'id':2008,'name':'2008'},
                {'id':2009,'name':'2009'},
                {'id':2010,'name':'2010'},
                {'id':2011,'name':'2011'},
                {'id':2012,'name':'2012'},
                {'id':2013,'name':'2013'},
                {'id':2014,'name':'2014'},
                {'id':2015,'name':'2015'},
                {'id':2016,'name':'2016'},
                {'id':2017,'name':'2017'},
                {'id':2018,'name':'2018'},
                {'id':2019,'name':'2019'},
                {'id':2020,'name':'2020'},
                {'id':2021,'name':'2021'}];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  _AttendanceData _data = new _AttendanceData();


  void userDepartment() async{
    List <dynamic> userdetail = await dbhelper.get(1);
    DefaultDept = userdetail[0]['department'];
    String url = global.baseUrl+"/user-department";
    Map<String, String> headers = {"Content-type": "application/json","ibckey":userdetail[0]['key']};
    http.Response response = await http.get(url, headers: headers);
    int statusCode = response.statusCode;
    String body = response.body;
    setState(() {
      Departments = jsonDecode(response.body);
      //print(Departments[0]['DeptName']);
    });
    userLists();
  }

  void userLists() async{
    List <dynamic> userdetail = await dbhelper.get(1);
    Defaultuser = userdetail[0]['ecode'];
    String url = global.baseUrl+"/user-supervised";
    Map<String, String> headers = {"Content-type": "application/json","ibckey":userdetail[0]['key']};
    http.Response response = await http.get(url, headers: headers);
    int statusCode = response.statusCode;
    String body = response.body;
    setState(() {
      Users = jsonDecode(response.body);
      loader = false;
    });
  }

  void fetchAttendance() async {
    setState(() {
      tableloader = true;
    });
    List <dynamic> Userdetail = await dbhelper.get(1);
    String url = global.baseUrl+"/Authctrl/attendance";
    Map<String, String> headers = {"Content-type": "application/json","ibckey":Userdetail[0]['key']};
    String json = '{"department": "'+DefaultDept+'", "employee": "'+ Defaultuser +'","month":"'+Defaultmonth+'","year":"'+Defaultyear+'"}';
    http.Response response = await http.post(url,headers: headers,body: json);
    int statusCode = response.statusCode;
    setState(() {
      if(statusCode == 200) {
        jsonTable = jsonDecode(response.body);
        tableloader = false;
      } else {
        jsonTable = '';
        tableloader = false;
      }
    });
  }

  void userAttendance() async {
    List <dynamic> Userdetail = await dbhelper.get(1);
    String url = global.baseUrl+"/user-attendance";
    Map<String, String> headers = {"Content-type": "application/json","ibckey":Userdetail[0]['key']};
    http.Response response = await http.get(url,headers: headers);
    int statusCode = response.statusCode;
    if(statusCode == 200) {
      setState(() {
        jsonTable = jsonDecode(response.body);
        //tableloader = false;
      });
      userDepartment();
    }
  }

  void getMonthYear() async {
    List <dynamic> Userdetail = await dbhelper.get(1);
    String url = global.baseUrl+"/month-year";
    Map<String, String> headers = {"Content-type": "application/json","ibckey":Userdetail[0]['key']};
    http.Response response = await http.get(url,headers: headers);
    List body = jsonDecode(response.body);
    setState(() {
      Defaultmonth = body[0]['month'].toString();
      Defaultyear = body[0]['year'].toString();
      print(Defaultyear);
    });
    userAttendance();
  }

  void logout() async {
    await dbhelper.deletedata();
    Navigator.pushNamed(context, '/login');
  }



  @override
  void initState(){
    super.initState();
    getMonthYear();
    //userLists();

  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarPage('ATTENDANCE'),
        //drawer: DrawerPage(),
        body: loader ? Container(
          child: Center(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
            ],
          ),
          ),
          //child: CircularProgressIndicator(),
        ): Container(
          //decoration: BoxDecoration(color: Colors.white),
            child: SingleChildScrollView(
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(20.0),
                    child : Column(
                      children: <Widget>[
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('Department', style: TextStyle(fontWeight: FontWeight.bold),),
                                  DropdownButton(
                                    items: Departments.map((item1){
                                      print(item1['DeptName']);
                                      return DropdownMenuItem(
                                        value: item1['id'].toString(),
                                        child: Text(item1['DeptName'].toString()),

                                      );
                                    }).toList(),
                                    onChanged: (newVal1) {
                                      setState(() {
                                        DefaultDept = newVal1.toString();
                                      });
                                    },
                                    value: DefaultDept,
                                  ),
                                ],
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('Emp Name',style: TextStyle(fontWeight: FontWeight.bold),),
                                  DropdownButton(
                                    items: Users.map((item){
                                      return DropdownMenuItem(
                                        child: Text(item['name']),
                                        value: item['ecode'].toString(),
                                      );
                                    }).toList(),
                                    onChanged: (newVal) {
                                      setState(() {
                                        Defaultuser = newVal;
                                      });
                                    },
                                    value: Defaultuser,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('Month/Year',style: TextStyle(fontWeight: FontWeight.bold),),
                                  Row(
                                    children: <Widget>[
                                      DropdownButton(
                                        items: Month.map((item){
                                          return DropdownMenuItem(
                                            child: Text(item['name']),
                                            value: item['id'].toString(),
                                          );
                                        }).toList(),
                                        onChanged: (newVal) {
                                          setState(() {
                                            Defaultmonth = newVal;
                                          });
                                        },
                                        value: Defaultmonth,
                                      ),
                                      DropdownButton(
                                        items: Year.map((item){
                                          return DropdownMenuItem(
                                            child: Text(item['name']),
                                            value: item['id'].toString(),
                                          );
                                        }).toList(),
                                        onChanged: (newVal) {
                                          setState(() {
                                            Defaultyear = newVal;
                                          });
                                        },
                                        value: Defaultyear,
                                      ),
                                    ],
                                  ),

                                ],
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  MaterialButton(
                                    onPressed: fetchAttendance,
                                    color: Colors.green[600],
                                    splashColor: Colors.red,
                                    child: Text('View',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                      ),),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: tableloader? Container(
                            padding: EdgeInsets.all(70.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                CircularProgressIndicator(),
                                Text('Loading...',style: TextStyle(color: Colors.redAccent,fontWeight: FontWeight.bold,),),
                              ],
                            ),
//                            child: Col(
//                              //child: CircularProgressIndicator(),
//                            ),
                          ) : Container(
                            width: MediaQuery. of(context). size. width,
                            child: Center(
                              child: jsonTable == "" ? Container(
                                padding: EdgeInsets.all(70.0),
                                child: Center(
                                  child: Text('No record found.',style: TextStyle(color: Colors.redAccent,fontWeight: FontWeight.bold,),),
                                ),
                              ) :JsonTable(jsonTable,tableHeaderBuilder: (String header) {
                                return Container(padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                  decoration: BoxDecoration(border: Border.all(width: 0.5),color: Colors.blue[300]),
                                  child: Text(header,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.display1.copyWith(fontWeight: FontWeight.w700, fontSize: 14.0,color: Colors.black87),
                                  ),
                                );
                              },
                                tableCellBuilder: (value) {
                                  return Container(
                                    padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                                    decoration: BoxDecoration(border: Border.all(width: 0.5, color: Colors.grey.withOpacity(0.5))),
                                    child: Text(
                                      value,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context).textTheme.display1.copyWith(fontSize: 16.0, color: Colors.black),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),

                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ),
    );
  }
}

