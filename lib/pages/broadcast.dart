//import 'dart:html';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ibcportal/common/appbarPage.dart';
import 'package:ibcportal/common/drawerPage.dart';
import 'package:ibcportal/dbhelper.dart';
import 'dart:convert';
import 'dart:async';
import 'package:ibcportal/common/global.dart' as global;
import 'package:intl/intl.dart';

class BroadcastPage extends StatefulWidget {
  @override
  _BroadcastPageState createState() => _BroadcastPageState();
}

class _BroadcastPageState extends State<BroadcastPage> {
  final dbhelper = Databasehelper.instance;
  TextEditingController _controller;
  String Defaulttime = '13';
  List timeSlot = [{'id':1,'slot':'00:00'},{'id':2,'slot':'00:30'},{'id':3,'slot':'01:00'},{'id':4,'slot':'01:30'},{'id':5,'slot':'02:00'},
                    {'id':6,'slot':'02:30'},{'id':7,'slot':'03:00'},{'id':8,'slot':'03:30'},{'id':9,'slot':'04:00'},{'id':10,'slot':'04:30'},
                    {'id':11,'slot':'05:00'},{'id':12,'slot':'05:30'},{'id':13,'slot':'06:30'},{'id':14,'slot':'07:00'},{'id':15,'slot':'07:30'},
                    {'id':16,'slot':'08:00'},{'id':17,'slot':'08:30'},{'id':18,'slot':'09:00'},{'id':19,'slot':'09:30'},{'id':20,'slot':'10:00'},
                    {'id':21,'slot':'10:30'},{'id':22,'slot':'11:00'},{'id':23,'slot':'11:30'},{'id':24,'slot':'12:00'},{'id':25,'slot':'12:30'},
                    {'id':26,'slot':'13:00'},{'id':27,'slot':'13:30'},{'id':28,'slot':'14:00'},{'id':29,'slot':'14:30'},{'id':30,'slot':'15:00'},
                    {'id':31,'slot':'15:30'},{'id':32,'slot':'16:00'},{'id':33,'slot':'16:30'},{'id':34,'slot':'17:00'},{'id':35,'slot':'17:30'},
                    {'id':36,'slot':'18:00'},{'id':37,'slot':'18:30'},{'id':38,'slot':'19:00'},{'id':39,'slot':'19:30'},{'id':40,'slot':'20:00'},
                    {'id':41,'slot':'20:30'},{'id':42,'slot':'21:00'},{'id':43,'slot':'21:30'},{'id':44,'slot':'22:00'},{'id':45,'slot':'22:30'},
                    {'id':46,'slot':'23:00'},{'id':47,'slot':'23:30'},{'id':48,'slot':'00:00'}];


  @override
  void initState() {
    super.initState();
    _controller= TextEditingController();
  }

  void _fetchvideo() async{
    List selectedDate = _controller.text.split('/');
    String _selectedDate = selectedDate[2]+'-'+selectedDate[1]+'-'+selectedDate[0];
    String slot = timeSlot[int.parse(Defaulttime)-1]['slot'];

    List <dynamic> Userdetail = await dbhelper.get(1);
    String url = global.baseUrl+"/Broadcast";
    Map<String, String> headers = {"Content-type": "application/json","ibckey":Userdetail[0]['key']};
    String json = '{"date": "'+_selectedDate+'", "time": "'+ slot +'"}';
    http.Response response = await http.post(url,headers: headers,body: json);
    int statusCode = response.statusCode;
    setState(() {
      if(statusCode == 200) {
        print(jsonDecode(response.body));
      } else {
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarPage('Broadcast'),
      drawer: DrawerPage(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Date'),

                RaisedButton(
                  onPressed: (){
                    showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2019, 1),
                        lastDate: DateTime(2021,12),
//                        builder: (BuildContext context, Widget picker){
//                          return Theme(
//                            //TODO: change colors
//                            data: ThemeData.dark().copyWith(
//                              colorScheme: ColorScheme.dark(
//                                primary: Colors.deepPurple,
//                                onPrimary: Colors.white,
//                                surface: Colors.pink,
//                                onSurface: Colors.yellow,
//                              ),
//                              dialogBackgroundColor:Colors.green[900],
//                            ),
//                            child: picker,
//                          );
//                        }

                    ).then((selectedDate) {
                      if(selectedDate!=null){
                        final DateTime now = selectedDate;
                        final DateFormat formatter = DateFormat('dd/MM/yyyy');
                        final String formatted = formatter.format(now);
                        _controller.text = formatted;
                      }
                    });
                  },
                  child: Text("Select Date"),
                ),
              ],
            ),

            TextField(
              controller: _controller,
            ),

            DropdownButton(
              items: timeSlot.map((item){
                return DropdownMenuItem(
                  child: Text(item['slot']),
                  value: item['id'].toString(),
                );
              }).toList(),
              onChanged: (newVal) {
                setState(() {
                  Defaulttime = newVal;
                });
              },
              value: Defaulttime,
            ),

            MaterialButton(
              onPressed: _fetchvideo,
              color: Colors.green[600],
              splashColor: Colors.red,
              child: Text('View',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),),
            ),
          ],
        ),
      ),
    );
  }
}

