import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:ibcportal/dbhelper.dart';
import 'dart:convert';

import 'package:ibcportal/common/global.dart' as global;
import 'package:ibcportal/common/drawerPage.dart';
import 'package:ibcportal/common/appbarPage.dart';
//import 'package:ibcportal/common/bottomnavigation.dart';
import 'package:ibcportal/pages/bottomNavigation/Birthday.dart';
class Dashbaord extends StatefulWidget {
  @override
  _DashbaordState createState() => _DashbaordState();
}

class _DashbaordState extends State<Dashbaord> {
  final dbhelper = Databasehelper.instance;
  @override
  void initState(){
    super.initState();
    _userDetail();
  }

  
  Future<bool> _onWillPop(){
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: Text('Want to exit?',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
        //content: new Text('',style:TextStyle(fontSize: 16),),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => exit(0),
            child: Text('Yes',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 16),),
          ),
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
            color: Colors.green,
          ),
        ],
      ),
    ) ?? false;
  }

   _userDetail() async {
      List <dynamic> userdetail = await dbhelper.get(1);
      String url = global.baseUrl+'/Authctrl/userDetail';
      Map<String, String> headers = {"Content-type": "application/json","ibckey":userdetail[0]['key']};
      String json = '{"identity": "'+userdetail[0]['ecode']+'"}';
      http.Response response = await http.post(url, headers: headers, body: json);
      int statusCode = response.statusCode;

      if(statusCode == 200){
        List body = jsonDecode(response.body);
        global.uname = body[0]['name'];
        global.emailId = body[0]['company_mailid'];
        global.userImage = 'https://employee.ibc24.in/OLAppraisal/EmpImage/' + body[0]['image'];
    } else {
        _showMyDialog();
      }
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Authentication Alert!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Your account is suspended, please login again.'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                dbhelper.deletedata();
                Navigator.pushNamed(context, '/login');
              },
            ),
          ],
        );
      },
    );
  }

  final tabs = [
      Center(child: dashbordItem()),
      Center(child: Birthday()),
      Center(child: Text('News'))
  ];

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar: AppbarPage('IBC24 EMP-Portal'),
          drawer: DrawerPage(),
          //bottomNavigationBar: Bottomnavigation(),
          body: tabs[0],
      ),
    );
  }
}

class dashbordItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
          padding:EdgeInsets.all(9.0),
          child: GridView.count(
            crossAxisCount: 3,
            children: <Widget>[
              Items(title:'Attendance\nMgmt',icon:Icons.access_time,warna:Colors.green,route:'/attendance'),
              Items(title:'PL\nSummary',icon:Icons.grid_off,warna:Colors.orange,route:'/plsummary'),
              Items(title:'IT\nPolicies',icon:Icons.desktop_windows,warna:Colors.yellow,route:'/itpolicies'),
              //Items(title:'CAB\nMgmt',icon:Icons.directions_car,warna:Colors.blue,route:'attendance'),
              Items(title:'HR\nPolicies',icon:Icons.desktop_windows,warna:Colors.red,route:'/hrpolicies'),
              //Items(title:'Broadcast\nOutput\ncomming soon',icon:Icons.desktop_windows,warna:Colors.orange,route:''),
            ],
          ),
        );
  }
}


class Items extends StatelessWidget {
  Items({this.title,this.icon,this.warna,this.route});
  final String title;
  final IconData icon;
  final MaterialColor warna;
  final String route;
  @override
  Widget build(BuildContext context) {
    return Card(
      //color: Colors.black54,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      elevation: 5.0,
      margin: EdgeInsets.all(4.0),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        splashColor: Colors.redAccent,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(icon,size: 60.0,color: warna,),
              Text(title,style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
