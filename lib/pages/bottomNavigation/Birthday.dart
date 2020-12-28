import 'package:flutter/material.dart';

class Birthday extends StatefulWidget {
  @override
  _BirthdayState createState() => _BirthdayState();
}

class _BirthdayState extends State<Birthday> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Birthday'),
      ),
    );
  }
}
