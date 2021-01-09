import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ibcportal/common/appbarPage.dart';
import 'package:ibcportal/dbhelper.dart';
import 'package:ibcportal/common/global.dart' as global;
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:ibcportal/common/drawerPage.dart';
import 'dart:async';

class AllReport extends StatefulWidget {
  @override
  _AllReportState createState() => _AllReportState();
}

class _AllReportState extends State<AllReport> {
  final dbhelper = Databasehelper.instance;
  bool loader = false;
  List Hrpolicies;

  void Hr_policy() async{
    setState(() {
      loader = true;
    });
    List <dynamic> userdetail = await dbhelper.get(1);
    String url = global.baseUrl + "/hr-policies";
    Map<String, String> headers = {"Content-type": "application/json","ibckey":userdetail[0]['key']};
    http.Response response = await http.get(url, headers: headers);
    int statusCode = response.statusCode;
    if(statusCode == 200) {
      Hrpolicies = jsonDecode(response.body);
      setState(() {
        loader = false;
      });
    } else {
      setState(() {
        loader = false;
      });
    }
  }

  _launchURL(file,url) async {
    // print(file);
    // final url = global.appPath +'/policies/'+file;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Hr_policy();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarPage('All Reports'),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.access_alarm),
              label: 'Full Day'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.access_alarm),
              label: 'Half Day'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.access_alarm),
              label: 'Off Day Duty'
          ),
          // BottomNavigationBarItem(
          //     icon: Icon(Icons.access_alarm),
          //     label: 'NH/FH Day Duty'
          // ),
          // BottomNavigationBarItem(
          //     icon: Icon(Icons.access_alarm),
          //     label: 'NH/FH Avail'
          // ),
          // BottomNavigationBarItem(
          //     icon: Icon(Icons.access_alarm),
          //     label: 'Tour'
          // ),
        ],
      ),
      body: loader?Container(
        padding: EdgeInsets.all(70.0),
        child : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(height: 15.0,),
              Text('  Loading...',style: TextStyle(color: Colors.redAccent,fontWeight: FontWeight.bold,),),
            ],
          ),
        ),
      ): Column(
        children: [
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
                      Text('All Report',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue[900]),),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
