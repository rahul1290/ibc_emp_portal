//import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ibcportal/common/appbarPage.dart';
import 'package:ibcportal/common/drawerPage.dart';
import 'package:ibcportal/dbhelper.dart';
import 'dart:convert';
import 'dart:async';

import 'package:json_table/json_table.dart';
import 'package:ibcportal/common/global.dart' as global;

class Plsummary extends StatefulWidget {
  @override
  _PlsummaryState createState() => _PlsummaryState();
}

class _AttendanceData {
  int _department = 0;
}

class _PlsummaryState extends State<Plsummary> {
  final dbhelper = Databasehelper.instance;
  var jsonTable;
  String DefaultDept;
  String Defaultuser;
  List Users = List();
  List Departments = List();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  _AttendanceData _data = new _AttendanceData();


  void userDepartment() async{
    List <dynamic> userdetail = await dbhelper.get(1);
    DefaultDept = userdetail[0]['department'];
    String url = global.baseUrl+"/Authctrl/user_department";
    Map<String, String> headers = {"Content-type": "application/json","ibckey":userdetail[0]['key']};
    http.Response response = await http.get(url, headers: headers);
    int statusCode = response.statusCode;
    String body = response.body;
    setState(() {
      Departments = jsonDecode(response.body);
    });
  }

  void userLists() async{
    List <dynamic> userdetail = await dbhelper.get(1);
    Defaultuser = userdetail[0]['ecode'];
    String url = global.baseUrl+"/Authctrl/user_list";
    Map<String, String> headers = {"Content-type": "application/json","ibckey":userdetail[0]['key']};
    http.Response response = await http.get(url, headers: headers);
    int statusCode = response.statusCode;
    String body = response.body;
    setState(() {
      Users = jsonDecode(response.body);
    });
  }

  void userPlsummary() async {
    setState(() {
      tableloader = true;
    });
    List <dynamic> Userdetail = await dbhelper.get(1);
    String url = global.baseUrl+"/Authctrl/plsummary";
    Map<String, String> headers = {"Content-type": "application/json","ibckey":Userdetail[0]['key']};
    String json = '{"department": "'+ DefaultDept +'", "ecode": "'+ Defaultuser +'"}';
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

  void fetchPlsummary() async {
    List <dynamic> Userdetail = await dbhelper.get(1);
    String url = global.baseUrl+"/Authctrl/plsummary";
    Map<String, String> headers = {"Content-type": "application/json","ibckey":Userdetail[0]['key']};
    String json = '{ }';
    http.Response response = await http.post(url,headers: headers,body: json);
    int statusCode = response.statusCode;
    if( statusCode == 200) {
      setState(() {
        jsonTable = jsonDecode(response.body);
        loader = false;
        tableloader = false;
      });
    } else {
      setState(() {
        tableloader = false;
        loader = false;
        jsonTable = "";
      });
    }
  }

  bool loader = true;
  bool tableloader = true;

  @override
  void initState(){
    super.initState();
    fetchPlsummary();
    userDepartment();
    userLists();


  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarPage('PL summary'),
      drawer: DrawerPage(),
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
                                items: Departments.map((item){
                                  return DropdownMenuItem(
                                    child: Text(item['dept_name'],maxLines: 2,),
                                    value: item['id'].toString(),
                                  );
                                }).toList(),
                                onChanged: (newVal) {
                                  setState(() {
                                    DefaultDept = newVal;
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              MaterialButton(
                                onPressed: userPlsummary,
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
                        //child: Center(
                          child: jsonTable == "" ? Container(
                            padding: EdgeInsets.all(10.0),
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
                        //),
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