import 'package:flutter/material.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final AppBar appbar;
  final Color backgroundColor = Colors.grey.shade200;
  final double elevation = 0;
  DefaultAppBar(this.title, this.appbar, {super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title,
          style: const TextStyle(
              color: Colors.black,
              fontFamily: "Montserrat",
              fontSize: 25,
              fontWeight: FontWeight.w600)),
      backgroundColor: backgroundColor,
      elevation: elevation,
      toolbarHeight: 50,
      iconTheme: const IconThemeData(color: Colors.black),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
