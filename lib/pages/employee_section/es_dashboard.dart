import 'package:flutter/material.dart';
import 'package:ibcportal/common/global.dart' as global;
//import 'package:empportal/common/drawerPage.dart';
//import 'package:multilevel_drawer/multilevel_drawer.dart';

class Es_dashboard extends StatefulWidget {
  @override
  _Es_dashboardState createState() => _Es_dashboardState();
}

class _Es_dashboardState extends State<Es_dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: new Center(child: new Text('Employee Section', textAlign: TextAlign.center)),
          backgroundColor: Colors.red[500],
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/livetv');
                },
                child: Icon(
                  Icons.live_tv,
                  size: 26.0,
                ),
              ),
            ),
          ],
        ),
        //drawer: DrawerPage(),
        body: Container(
          padding: EdgeInsets.all(9.0),
          child: GridView.count(
            crossAxisCount: 2,
            children: <Widget>[
              Items(title: 'Leave\nrequests',
                  icon: Icons.access_time,
                  warna: Colors.green,
                  route: '/leaverequest'),
              Items(title: 'HF day\nleave request',
                  icon: Icons.desktop_windows,
                  warna: Colors.yellow,
                  route: '/itpolicies'),
              Items(title: 'OFF day\nduty form',
                  icon: Icons.directions_car,
                  warna: Colors.blue,
                  route: 'attendance'),
              Items(title: 'NH/FH day\nduty form',
                  icon: Icons.desktop_windows,
                  warna: Colors.red,
                  route: '/hrpolicies'),
              Items(title: 'PL summary\nreport',
                  icon: Icons.desktop_windows,
                  warna: Colors.orange,
                  route: 'attendance'),
            ],
          ),
        )
    );
  }
}
  class Items extends StatelessWidget {
    Items({this.title, this.icon, this.warna, this.route});

    final String title;
    final IconData icon;
    final MaterialColor warna;
    final String route;

    @override
    Widget build(BuildContext context) {
      return Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)),
        elevation: 5.0,
        margin: EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () => Navigator.pushNamed(context, route),
          splashColor: Colors.redAccent,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(icon, size: 60.0, color: warna,),
                Text(title, style: TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      );
    }
  }

