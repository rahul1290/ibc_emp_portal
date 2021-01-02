import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ibcportal/common/appbarPage.dart';

class LeveRequest extends StatefulWidget {
  @override
  _LeveRequestState createState() => _LeveRequestState();
}

class _LeveRequestState extends State<LeveRequest> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool loader = false;
  int pls;
  List cOff;
  List nhFh;
  String jod;
  String reportingTo;
  String leaveFrom;
  String leaveTo;
  String ReasonLeave;

  TextEditingController _leaveFrom;
  TextEditingController _leaveTo;



  @override
  void initState() {
    super.initState();
    _leaveFrom = TextEditingController();
    _leaveTo = TextEditingController();
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
    );
  }
  String radioButtonItem = 'ONE';
  int id = 1;

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
        ):Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
                        children: <Widget>[
                          _buildLeaveFrom(),
                          _buildLeaveTo(),
                          _buildReason(),

                          Row(
                            //mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Radio(
                                value: 1,
                                groupValue: id,
                                onChanged: (val) {
                                  setState(() {
                                    radioButtonItem = 'MON';
                                    id = 1;
                                  });
                                },
                              ),
                              Text('MON',style: TextStyle(fontSize: 10.0),),
                              Radio(
                                value: 2,
                                groupValue: id,
                                onChanged: (val) {
                                  setState(() {
                                    radioButtonItem = 'TUE';
                                    id = 2;
                                  });
                                },
                              ),
                              Text('TUE',style: TextStyle(fontSize: 10.0),),
                              Radio(
                                value: 3,
                                groupValue: id,
                                onChanged: (val) {
                                  setState(() {
                                    radioButtonItem = 'WED';
                                    id = 3;
                                  });
                                },
                              ),
                              Text('WED',style: TextStyle(fontSize: 10.0),),
                              Radio(
                                value: 4,
                                groupValue: id,
                                onChanged: (val) {
                                  setState(() {
                                    radioButtonItem = 'THU';
                                    id = 4;
                                  });
                                },
                              ),
                              Text('THU',style: TextStyle(fontSize: 10.0),),
                              Radio(
                                value: 5,
                                groupValue: id,
                                onChanged: (val) {
                                  setState(() {
                                    radioButtonItem = 'FRI';
                                    id = 5;
                                  });
                                },
                              ),
                              Text('FRI',style: TextStyle(fontSize: 10.0),),

                              Radio(
                                value: 5,
                                groupValue: id,
                                onChanged: (val) {
                                  setState(() {
                                    radioButtonItem = 'SAT';
                                    id = 5;
                                  });
                                },
                              ),
                              Text('SAT',style: TextStyle(fontSize: 10.0),),

                              Radio(
                                value: 5,
                                groupValue: id,
                                onChanged: (val) {
                                  setState(() {
                                    radioButtonItem = 'SUN';
                                    id = 5;
                                  });
                                },
                              ),
                              Text('SUN',style: TextStyle(fontSize: 10.0),),
                            ],
                          ),

                          SizedBox(height: 50),
                          RaisedButton(
                              child: Text('Submit',style: TextStyle(color: Colors.blue, fontSize: 16),),
                              onPressed: (){
                                if(!_formkey.currentState.validate()){
                                  return;
                                }
                                _formkey.currentState.save();
                              }),
                        ],
                      ),
                    ),
                  ),
                )


                ,
              ),
            ],
          ),
    );
  }
}
