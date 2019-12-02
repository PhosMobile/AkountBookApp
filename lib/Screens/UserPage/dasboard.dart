import 'package:akount_books/Models/menu_item.dart';
import 'package:akount_books/Screens/BusinessPage/Expenses.dart';
import 'package:akount_books/Screens/BusinessPage/Invoices.dart';
import 'package:akount_books/Screens/BusinessPage/Reports.dart';
import 'package:akount_books/Screens/BusinessPage/customers.dart';
import 'package:akount_books/Widgets/logo_avatar.dart';
import 'package:akount_books/utilities/svg_files.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  final List<Widget> _children = [
    Invoices(),
    Customers(),
    Expenses(),
    Reports()
  ];

  final Widget svg = new SvgPicture.asset(
    SVGFiles.success_icon,
    semanticsLabel: 'Akount-book',
    allowDrawingOutsideViewBox: true,
  );

  final List<String> _title = ["Invoices", "Customers", "Expenses", "Reports"];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    MenuList menu = new MenuList();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(_title[_selectedIndex], style: TextStyle(color: Colors.black,fontSize: 14),),
          elevation: 0.0,
          iconTheme: IconThemeData(
              color: Theme
                  .of(context)
                  .primaryColor
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(width: 2, color: Theme.of(context).accentColor))
          ),
          child: _children[_selectedIndex],
        ),
        drawer: SizedBox(
          width: size.width,
          child: Drawer(
            child: Container(
                color: Theme.of(context).primaryColor,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SafeArea(
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            ImageAvatars().miniLogoAvatar(),
                            InkWell(
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 30,
                              ),
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        ),
                        Expanded(
                          child: menuView(menu.menuList),
                        )
                      ],
                    ),
                  ),
                )),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(
                backgroundColor: Color.fromRGBO(233, 237, 240, 1),
                icon: Icon(
                  MdiIcons.fileDocumentOutline,
                ),
                title: Text(
                    "Invoices"
                )),
            BottomNavigationBarItem(
                icon:
                Icon(MdiIcons.accountCircleOutline),
                title: Text(
                    "Customers"
                )),
            BottomNavigationBarItem(
                icon: Icon(MdiIcons.calculator),
                title: Text(
                    "Expenses"
                )),
            BottomNavigationBarItem(
                icon:
                Icon(MdiIcons.fileMultipleOutline,),
                title: Text(
                    "Report"
                )),
          ],
          currentIndex: _selectedIndex,
          selectedIconTheme:
          IconThemeData(
              color: Theme
                  .of(context)
                  .primaryColor
          ),
          unselectedIconTheme:
          IconThemeData(
              color: Color.fromRGBO(114, 139, 161, 1)
          ),
          selectedItemColor: Theme
              .of(context)
              .primaryColor,
          unselectedItemColor: Color.fromRGBO(114, 139, 161, 1),
          onTap: _onItemTapped,
        ));
  }

  Widget menuView(List<MenuItem> menuList) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: ListView.builder(
            itemCount: menuList.length,
            itemBuilder: (BuildContext context, int position) {
              return Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: Column(
                  children: <Widget>[
                    InkWell(
                      child: ListTile(
                        contentPadding: EdgeInsets.only(right: 40),
                        leading: CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white,
                            child: menuList[position].icon),
                        title: Text(
                          menuList[position].title,
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, menuList[position].link);
                      },
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
