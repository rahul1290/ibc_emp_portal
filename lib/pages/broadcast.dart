import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ibcportal/common/appbarPage.dart';
import 'package:ibcportal/common/drawerPage.dart';
import 'package:ibcportal/dbhelper.dart';
import 'dart:convert';
import 'dart:async';
import 'package:ibcportal/common/global.dart' as global;
import 'package:gplayer/gplayer.dart';

class BroadcastPage extends StatefulWidget {
  @override
  _BroadcastPageState createState() => _BroadcastPageState();
}

class _AttendanceData {
  int _department = 0;
  int _month = 0;
  int _year = 0;
}

class _BroadcastPageState extends State<BroadcastPage> {

  final dbhelper = Databasehelper.instance;
  var jsonTable;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  _AttendanceData _data = new _AttendanceData();
  GPlayer player;

  bool loader = true;
  bool tableloader = true;

  @override
  void initState() {
    super.initState();
    //1.create & init player
    player = GPlayer(uri: 'http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4')
      ..init()
      ..addListener((_) {
        //update control button out of player
        setState(() {});
      });
  }

   @override
  void dispose() {
    player?.dispose(); //2.release player
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarPage('Broadcast'),
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
        ): Container(
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
                                  Text('Date', style: TextStyle(fontWeight: FontWeight.bold),),
                                  DropdownButton(),
                                ],
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('Time',style: TextStyle(fontWeight: FontWeight.bold),),
                                  DropdownButton(),
                                ],
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  MaterialButton(
                                    onPressed: (){},
                                    color: Colors.green[600],
                                    splashColor: Colors.red,
                                    child: Text('Preview',
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
                          ) : Container(
                            width: MediaQuery. of(context). size. width,
                            child: MaterialButton(
                                    onPressed: (){},
                                    color: Colors.green[600],
                                    splashColor: Colors.red,
                                    child: Text('Preview',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                      ),),
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

