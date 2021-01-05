import 'package:flutter/material.dart';
import 'package:ibcportal/common/appbarPage.dart';
import 'package:ibcportal/common/drawerPage.dart';

class Es_dashboard extends StatefulWidget {
  @override
  _Es_dashboardState createState() => _Es_dashboardState();
}

class _Es_dashboardState extends State<Es_dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppbarPage('Employee Section'),
        drawer: DrawerPage(),
        body: Container(
          padding: EdgeInsets.all(9.0),
          child: GridView.count(
            crossAxisCount: 3,
            children: <Widget>[
              Items(title: 'Attendance\nMgmt',icon: Icons.how_to_reg,warna: Colors.green,route: '/attendance'),
              Items(title:'PL\nSummary',icon:Icons.grid_off,warna:Colors.orange,route:'/plsummary'),
              Items(title: 'Leave\nRequest',icon: Icons.text_snippet,warna: Colors.blue,route: '/leaverequest'),
              Items(title: 'Half day\nLeave',icon: Icons.desktop_windows,warna: Colors.yellow,route: '/halfdayrequest'),
              Items(title: 'OFF day\nDuty',icon: Icons.directions_car,warna: Colors.blue,route: '/offdayduty_request'),
              Items(title: 'Tour\nRequest',icon: Icons.directions_car,warna: Colors.blue,route: 'attendance'),
              Items(title: 'Cancel\nRequest',icon: Icons.report,warna: Colors.red,route: 'attendance'),
              Items(title: 'NH/FH\nDuty',icon: Icons.desktop_windows,warna: Colors.red,route: '/hrpolicies'),
              Items(title: 'NH/FH\nAvail',icon: Icons.desktop_windows,warna: Colors.red,route: '/hrpolicies'),
              Items(title: 'All\nReport',icon: Icons.timeline,warna: Colors.orange,route: '/hrpolicies'),
            ],
          ),
        )
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

