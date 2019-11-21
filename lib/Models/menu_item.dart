import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MenuList {
  List<MenuItem> menuList = [
    new MenuItem(
        title: "Edit Business Page",
        icon: Icon(Icons.event),
        link: "/user_dashboard"),
    new MenuItem(
        title: "Add New Business",
        icon: Icon(Icons.create_new_folder),
        link: "/add_business"),
    new MenuItem(
        title: "Switch Accounts",
        icon: Icon(Icons.swap_horiz),
        link: "/switch_account"),
    new MenuItem(
        title: "Settings & Help",
        icon: Icon(Icons.settings),
        link: "/settings"),
    new MenuItem(
        title: "Log Out", icon: Icon(Icons.arrow_right), link: "/logout"),
  ];
}

class MenuItem {
  String title;
  Icon icon;
  String link;

  MenuItem({@required this.title, @required this.icon, @required this.link});
}
