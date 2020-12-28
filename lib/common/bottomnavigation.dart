import 'package:flutter/material.dart';

class Bottomnavigation extends StatefulWidget {
  @override
  _BottomnavigationState createState() => _BottomnavigationState();
}

class _BottomnavigationState extends State<Bottomnavigation> {
  int _currentIndex = 0;
  onTapped(int index) {
    setState(() {
      index = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text('Home'),

        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.cake),
          title: Text('Birthday\'s'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.public),
          title: Text('Lates News'),
        ),
      ],
      onTap: (index){
        setState(() {
          _currentIndex = index;
        });
      },
    );
  }
}
