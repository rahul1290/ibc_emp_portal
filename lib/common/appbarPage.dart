import 'package:flutter/material.dart';

class AppbarPage extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  AppbarPage(this.title);

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(this.title),
      centerTitle: true,
      backgroundColor: Colors.red[500],
    );
  }
}
