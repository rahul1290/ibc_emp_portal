import 'package:flutter/material.dart';
import 'package:ibcportal/dbhelper.dart';
//import 'package:multilevel_drawer/multilevel_drawer.dart';
import 'package:ibcportal/common/global.dart' as global;

class DrawerPage extends StatefulWidget {
  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  final dbhelper = Databasehelper.instance;

//  void logout() {
//    dbhelper.deletedata();
//    Navigator.pushReplacementNamed(context, '/login');
//  }


  Future<void> logout() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('You want to logout?'),
          content: SingleChildScrollView(
//            child: ListBody(
//              children: <Widget>[
//                Text('Are you sure to logout'),
//              ],
//            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Yes',style: TextStyle(color: Colors.red),),
              onPressed: () {
                    dbhelper.deletedata();
                    Navigator.pushReplacementNamed(context, '/login');
              },
            ),
            FlatButton(
              child: Text('No'),
              color: Colors.green,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(global.uname),
            accountEmail: Text(global.emailId),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(global.userImage),
            ),
//              otherAccountsPictures: <Widget>[
//                CircleAvatar(
//                  backgroundColor: Colors.red,
//                  child: Text('X'),
//                )
//              ],
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            //trailing: Icon(Icons.arrow_forward_ios),
            onTap: (){
              Navigator.pushReplacementNamed(context, "/dashboard");
            },
          ),
          ListTile(
            leading: Icon(Icons.access_time,color: Colors.green,),
            title: Text('Attendance Mgmt'),
            onTap: (){
              Navigator.pushNamed(context, '/attendance');
            },
          ),
          ListTile(
            leading: Icon(Icons.grid_off, color: Colors.orange,),
            title: Text('PL Summary'),
            onTap: () => Navigator.pushNamed(context, '/plsummary'),
          ),
          ListTile(
            leading: Icon(Icons.desktop_windows,color: Colors.yellow,),
            title: Text('IT Policies'),
            onTap: () => Navigator.pushNamed(context, '/itpolicies'),
          ),
          ListTile(
            leading: Icon(Icons.desktop_windows,color: Colors.red,),
            title: Text('HR Policies'),
            onTap: () => Navigator.pushNamed(context, '/hrpolicies'),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Logout'),
            onTap: logout,
          ),
        ],
      ),
    );



//      return SingleChildScrollView(
//        scrollDirection: Axis.vertical,
//
//        child: Column(
//          children: <Widget>[
//            MultiLevelDrawer(
//              backgroundColor: Colors.white,
//              rippleColor: Colors.red,
//              subMenuBackgroundColor: Colors.grey.shade100,
//              header: Expanded(
//                // Header for Drawer
//                //height: MediaQuery.of(context).size.height * 0.25,
//                child: UserAccountsDrawerHeader(
//                  accountName: Text('Rahul sinha'),
//                  accountEmail: Text('rahul1.sinha@ibc24.in'),
//                  currentAccountPicture: CircleAvatar(
//                    backgroundColor: Colors.white,
//                    backgroundImage: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRT-BwYJuj3yyVST5zpsvuLOLJWk26C9uWSk0vE2HbmTKX38j_Wdw&s'),
//                  ),
//                ),
//              ),
//              children: [
//                // Child Elements for Each Drawer Item
//                MLMenuItem(
//                  leading: Icon(Icons.home),
//                  content: Text("HOME"),
//                  onClick:() =>
//                      Navigator.pushReplacementNamed(context, "/dashboard"),
//                ),
//                MLMenuItem(
//                    leading: Icon(Icons.person),
//                    trailing: Icon(Icons.arrow_right),
//                    content: Text("Employee Section"),
//                    onClick: () { },
//                    subMenuItems: [
//                      MLSubmenu(onClick: () {}, submenuContent: Text("Attendance Management")),
//                      MLSubmenu(onClick: () {}, submenuContent: Text("Leave Request")),
//                      MLSubmenu(onClick: () {}, submenuContent: Text("HALF DAY LEAVE FORM")),
//                      MLSubmenu(onClick: () {}, submenuContent: Text("OFF DAY DUTY FORM")),
//                      MLSubmenu(onClick: () {}, submenuContent: Text("NH/FH DAY DUTY FORM")),
//                      MLSubmenu(onClick: () {}, submenuContent: Text("NH/FH AVAIL FORM")),
//                      MLSubmenu(onClick: () {}, submenuContent: Text("PL SUMMARY FORM")),
//                    ]),
//                MLMenuItem(
//                  leading: Icon(Icons.notifications),
//                  content: Text("Notifications"),
//                  onClick: () {},
//                ),
//                MLMenuItem(
//                  leading: Icon(Icons.notifications),
//                  content: Text("Notifications"),
//                  onClick: () {},
//                ),
//                MLMenuItem(
//                  leading: Icon(Icons.notifications),
//                  content: Text("Notifications"),
//                  onClick: () {},
//                ),
//                MLMenuItem(
//                  leading: Icon(Icons.notifications),
//                  content: Text("Notifications"),
//                  onClick: () {},
//                ),
//
//                MLMenuItem(
//                    leading: Icon(Icons.payment),
//                    trailing: Icon(Icons.arrow_right),
//                    content: Text(
//                      "Payments",
//                    ),
//                    subMenuItems: [
//                      MLSubmenu(onClick: () {}, submenuContent: Text("Option 1")),
//                      MLSubmenu(onClick: () {}, submenuContent: Text("Option 2")),
//                      MLSubmenu(onClick: () {}, submenuContent: Text("Option 3")),
//                      MLSubmenu(onClick: () {}, submenuContent: Text("Option 4")),
//                    ],
//                    onClick: () {}),
//                MLMenuItem(
//                  leading: Icon(Icons.settings),
//                  content: Text("Logout1"),
//                  onClick: logout,
//                ),
//                MLMenuItem(
//                  leading: Icon(Icons.settings),
//                  content: Text("Logout"),
//                  onClick: logout,
//                ),
//                MLMenuItem(
//                  leading: Icon(Icons.settings),
//                  content: Text("Logout"),
//                  onClick: logout,
//                ),
//                MLMenuItem(
//                  leading: Icon(Icons.settings),
//                  content: Text("Logout"),
//                  onClick: logout,
//                ),
//              ],
//            ),
//          ],
//        ),
//
//      );


  }
}
