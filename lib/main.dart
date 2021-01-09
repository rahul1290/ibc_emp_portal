import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';
import 'package:ibcportal/dbhelper.dart';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import 'package:ibcportal/pages/employee_section/AllReport.dart';
import 'package:ibcportal/pages/employee_section/offdayduty_request.dart';
import 'package:launch_review/launch_review.dart';

import 'dart:io';
import 'loginpage.dart';
import 'dashboard.dart';
import 'package:ibcportal/common/global.dart' as global;
import 'package:ibcportal/pages/employee_section/attendance.dart';
import 'package:ibcportal/pages/policies/itpolicies.dart';
import 'package:ibcportal/pages/policies/hrpolicies.dart';
import 'package:ibcportal/pages/employee_section/es_dashboard.dart';
import 'package:ibcportal/pages/employee_section/leaverequest.dart';
import 'package:ibcportal/pages/employee_section/plsummary.dart';
import 'package:ibcportal/pages/employee_section/halfday_request.dart';
import 'package:ibcportal/pages/employee_section/NhfhDuty.dart';
import 'package:ibcportal/pages/employee_section/nhfhAvail.dart';
import 'package:ibcportal/pages/broadcast.dart';
import 'package:ibcportal/pages/employee_section/Tour_request.dart';

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
        '/halfdayrequest' : (context) => HalfDayRequest(),
        '/offdayduty_request' : (context) => OffdayDutyRequest(),
        '/tour_request' : (context) => TourRequest(),
        '/nhfh_duty' : (context) => NhfhDuty(),
        '/nhfh_avail' : (context) => NhfhAvail(),
        '/all_report' : (context) => AllReport(),
        '/broadcast' : (context) => BroadcastPage(),
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
  var wifiBSSID;
  var wifiIP;
  var wifiName;
  bool iswificonnected = false;
  bool isInternetOn = true;

  @override
  void initState() {
    super.initState();
    //Timer(Duration(seconds: 3),()=>Navigator.pushNamed(context, '/login'));
    GetConnect();
    Timer(Duration(seconds: 3),get);
  }



  void GetConnect() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        isInternetOn = false;
      });
    } else if (connectivityResult == ConnectivityResult.mobile) {
      iswificonnected = false;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      iswificonnected = true;
      setState(() async {
        wifiBSSID = await (Connectivity().getWifiBSSID());
        wifiIP = await (Connectivity().getWifiIP());
        wifiName = await (Connectivity().getWifiName());
      });
    }
  }

  void checkVersion() async {
    if(isInternetOn) {
      String url = 'https://newsflow.ibc24.in/api/Apictrl/currentAppVersion';
      Map<String, String> headers = {"Content-type": "application/json"};
      String json = '{"version": "0.3"}';
      http.Response response = await http.post(
          url, headers: headers, body: json);
      int statusCode = response.statusCode;

      if (statusCode == 200) {
        Navigator.pushReplacementNamed(context, "/dashboard");
      } else {
        List body = jsonDecode(response.body);
        _showMyDialog(body);
      }
    } else {
      _internetDialog();
    }
  }

  Future<void> _showMyDialog(body) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('New Version Available.',),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Please, update app to new version to continue repositing.'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('UPDATE'),
              onPressed: () => LaunchReview.launch(
                androidAppId: body[0]['androidAppId'],
                iOSAppId: body[0]['iOSAppId'],
              ),
//            onPressed: () {
//              Navigator.of(context).pop();
//            },
            ),
          ],
        );
      },
    );
  }

  Future<void> _internetDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('You are offline.',style: TextStyle(color: Colors.black87),),
//          content: SingleChildScrollView(
//            child: ListBody(
//              children: <Widget>[
//                Text('You are offline.',style: TextStyle(color: Colors.red),),
//              ],
//            ),
//          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Exit',style: TextStyle(color: Colors.white),),
              color: Colors.red,
              onPressed: () {
                exit(0);
              },
//            onPressed: () {
//              Navigator.of(context).pop();
//            },
            ),
          ],
        );
      },
    );
  }




  void get() async {
    if(isInternetOn) {
      String url = global.baseUrl + '/Authctrl/currentAppVersion';
      Map<String, String> headers = {"Content-type": "application/json"};
      String json = '{"version": "0.1"}';
      http.Response response = await http.post(
          url, headers: headers, body: json);
      int statusCode = response.statusCode;

      if (statusCode == 200) {
        List list = await dbhelper.getall();
        if(list.length == 0){
          Navigator.pushReplacementNamed(context, '/login');
        } else {
          Navigator.pushReplacementNamed(context, "/dashboard");
        }
      } else {
        List body = jsonDecode(response.body);
        _showMyDialog(body);
      }
    } else {
      _internetDialog();
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
