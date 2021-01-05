import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ibcportal/common/appbarPage.dart';
import 'package:ibcportal/dbhelper.dart';
import 'package:ibcportal/common/global.dart' as global;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:flutter_multiselect/flutter_multiselect.dart';

class LeveRequest extends StatefulWidget {
  @override
  _LeveRequestState createState() => _LeveRequestState();
}



class _LeveRequestState extends State<LeveRequest> {
  final dbhelper = Databasehelper.instance;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool loader = false;
  String pls;
  List coffs;
  List nhfhs;
  String jod;
  String reportingTo;
  String leaveFrom;
  String leaveTo;
  String ReasonLeave;
  TextEditingController _leaveFrom;
  TextEditingController _leaveTo;
  String radioButtonItem;
  int wod = 1;

  List selectedCoff;
  List selectedNhfh;


  @override
  void initState() {
    super.initState();
    userLeaveDetail();
    _leaveFrom = TextEditingController();
    _leaveTo = TextEditingController();
  }

  void userLeaveDetail() async {
    List <dynamic> userdetail = await dbhelper.get(1);
    String url = global.baseUrl+"/user/leave-requests";
    Map<String, String> headers = {"Content-type": "application/json","ibckey":userdetail[0]['key']};
    http.Response response = await http.get(url, headers: headers);
    int statusCode = response.statusCode;
    setState(() {
      List body = jsonDecode(response.body);
      coffs = body[0]['coffs'];
      nhfhs = body[0]['nhfhs'];
      pls = body[0]['pls'];
    });
  }

  void _formSubmit() async {
    final FormState form = _formkey.currentState;
    form.save();

    List <dynamic> userdetail = await dbhelper.get(1);
    String url = global.baseUrl+"/user/leave-requests";
    Map<String, String> headers = {"Content-type": "application/json","ibckey":userdetail[0]['key']};

    String json = '{"leave_from":"'+ leaveFrom +'","leave_to":"'+ leaveTo +'","leave_reason":"'+ ReasonLeave +'","week_off_day":'+ wod.toString() +',"no_of_pl":"'+ pls +'","coff[]":'+ selectedCoff.toString() +',"nhfh[]":'+ selectedNhfh.toString() +'}';
    http.Response response = await http.post(url, headers: headers, body: jsonEncode(json));
    int statusCode = response.statusCode;
    print(statusCode);
    print(response.body);
  }

  Widget _buildLeaveFrom(){
    return TextFormField(
      controller: _leaveFrom,
      readOnly: true,
      decoration: InputDecoration(
          labelText: 'Leave From',
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
          return 'Select leave from date';
        }
      },
    );
  }
  Widget _buildLeaveTo(){
    return TextFormField(
      controller: _leaveTo,
      readOnly: true,
      decoration: InputDecoration(
          labelText: 'Leave To',
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
                  _leaveTo.text = formatted;
                }
              })
            },
            child: Icon(Icons.calendar_today),
          )),
      onSaved: (String value){
        leaveTo = value;
      },
      validator: (String value){
        if(value.isEmpty){
          return 'Select leave to date';
        }
      },
    );
  }

  Widget _buildReason(){
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Reason for Leave',
      ),
      keyboardType: TextInputType.multiline,
      onSaved: (String value){
        ReasonLeave = value;
      },
      validator: (String value){
        if(value.isEmpty){
          return 'Give reason for leave';
        }
      },
    );
  }

  Widget _buildCoff(){
    return MultiSelect(
      autovalidate: true,
      initialValue: [],
      titleText: 'Coffs',
      //maxLength: 5, // optional
      validator: (dynamic value) {
        if (value == null) {
          return 'Please select one or more option(s)';
        }
        return null;
      },
      errorText: 'Please select one or more option(s)',
      dataSource: coffs,
      textField: 'date',
      valueField: 'reference_id',
      //filterable: true,
      //required: true,
      onSaved: (value) {
//        setState(() {
          selectedCoff = value;
//        });
      },
      selectIcon: Icons.keyboard_arrow_down,
      saveButtonColor: Colors.lightGreen,
      checkBoxColor:Colors.green,
      cancelButtonColor: Colors.deepOrangeAccent,
    );
  }

  Widget _buildNhfh(){
    return MultiSelect(
      autovalidate: true,
      initialValue: [],
      titleText: 'Nhfhs',
      //maxLength: 5, // optional
      validator: (dynamic value) {
        if (value == null) {
          return 'Please select one or more option(s)';
        }
        return null;
      },
      errorText: 'Please select one or more option(s)',
      dataSource: nhfhs,
      textField: 'date',
      valueField: 'reference_id',
      //filterable: true,
      //required: true,
      onSaved: (value) {
//        setState(() {
          selectedNhfh = value;
//        });
      },
      selectIcon: Icons.keyboard_arrow_down,
      saveButtonColor: Colors.lightGreen,
      checkBoxColor:Colors.green,
      cancelButtonColor: Colors.deepOrangeAccent,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppbarPage('Leave Request'),
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
                              Text('Leave Request',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue[900]),),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 10),
                              _buildLeaveFrom(),
                              _buildLeaveTo(),
                              _buildReason(),
                              SizedBox(height: 10),
                              _buildCoff(),
                              SizedBox(height: 10),
                              _buildNhfh(),
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
                                  child: Text('Submit',style: TextStyle(color: Colors.blue, fontSize: 16),),
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
