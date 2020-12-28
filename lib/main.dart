import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:ibcportal/dbhelper.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';

import 'loginpage.dart';
import 'dashboard.dart';
import 'package:ibcportal/pages/attendance.dart';
import 'package:ibcportal/pages/policies/itpolicies.dart';
import 'package:ibcportal/pages/policies/hrpolicies.dart';
import 'package:ibcportal/pages/employee_section/es_dashboard.dart';
import 'package:ibcportal/pages/employee_section/leaverequest.dart';
import 'package:ibcportal/pages/plsummary.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'IBC24';
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      title: appTitle,
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context)=>SplashScreen(),
        '/login' : (context)=>LoginPage(),
        '/dashboard': (context)=>Dashbaord(),
        '/attendance' : (context)=>Attendance(),
        //'/livetv': (context)=>Livetv(),
        '/itpolicies' : (context) =>Itpolicies(),
        '/hrpolicies' : (context) => Hrpolicies(),
        '/esdashboard' : (context) => Es_dashboard(),
        '/leaverequest' : (context) => LeveRequest(),
        '/plsummary' : (context) => Plsummary(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final dbhelper = Databasehelper.instance;
  @override
  void initState() {
    super.initState();
    //Timer(Duration(seconds: 3),()=>Navigator.pushNamed(context, '/login'));
    Timer(Duration(seconds: 3),get);
  }

  void get() async {
    List list = await dbhelper.getall();
    if(list.length == 0){
      //Navigator.pushNamed(context, '/login');
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      Navigator.pushReplacementNamed(context, "/dashboard");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.redAccent),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.white30,
                        radius: 65.0,
                        child: Image.asset('assets/images/logo.png'),
                      ),
                      Padding(padding: EdgeInsets.only(top: 20.0),),
                      Text('Employee Portal',style: TextStyle(color: Colors.white,fontSize: 22.0,fontWeight: FontWeight.bold),)
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    CircularProgressIndicator(backgroundColor: Colors.white,),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                    ),
                    Text("Powered by IT",style: TextStyle(color: Colors.black),)
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
