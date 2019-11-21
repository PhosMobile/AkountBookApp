import 'package:akount_books/Api/UserAcount/logged_in_user.dart';
import 'package:akount_books/Graphql/graphql_config.dart';
import 'package:akount_books/Models/menu_item.dart';
import 'package:akount_books/Screens/BusinessPage/Expenses.dart';
import 'package:akount_books/Screens/BusinessPage/Invoices.dart';
import 'package:akount_books/Screens/BusinessPage/Reports.dart';
import 'package:akount_books/Screens/BusinessPage/customers.dart';
import 'package:akount_books/Widgets/logo_avatar.dart';
import 'package:flutter/material.dart';

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
          title: Text(_title[_selectedIndex]),
        ),
        body: _children[_selectedIndex],
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
                          child: MenuView(menu.menuList),
                        )
                      ],
                    ),
                  ),
                )),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.description,
              ),
              title: Text('Invoices'),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.account_circle,
              ),
              title: Text(
                'Customers',
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.exposure,
              ),
              title: Text(
                'Expenses',
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.add_photo_alternate,
              ),
              title: Text('Reports'),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedIconTheme:
              IconThemeData(color: Theme.of(context).primaryColor, size: 30),
          fixedColor: Theme.of(context).primaryColor,
          onTap: _onItemTapped,
          unselectedItemColor: Colors.blueGrey,
        ));
  }

  Widget MenuView(List<MenuItem> menuList) {
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
