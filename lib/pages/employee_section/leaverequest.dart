import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LeveRequest extends StatefulWidget {
  @override
  _LeveRequestState createState() => _LeveRequestState();
}

class _LeveRequestState extends State<LeveRequest> {
  @override
  bool loader = false;

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: new Center(child: new Text('Leave Request', textAlign: TextAlign.center)),
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
                height: 35.0,
                width: MediaQuery.of(context).size.width,
                color: Colors.black12,
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
                            Text('Home',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black87),),
                            Text(' >> ',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red),)
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Text('Employee Section',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black87),),
                          Text(' >> ',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red),)
                        ],
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
            ],
          ),
    );
  }
}
