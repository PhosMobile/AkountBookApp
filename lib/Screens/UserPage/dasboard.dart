import 'package:akaunt/AppState/app_state.dart';
import 'package:akaunt/Models/menu_item.dart';
import 'package:akaunt/Screens/BusinessPage/expenses.dart';
import 'package:akaunt/Screens/BusinessPage/Invoices.dart';
import 'package:akaunt/Screens/BusinessPage/Reports.dart';
import 'package:akaunt/Screens/BusinessPage/customers.dart';
import 'package:akaunt/Widgets/DisplayAttachedImage.dart';
import 'package:akaunt/Widgets/logo_avatar.dart';
import 'package:akaunt/utilities/svg_files.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Dashboard extends StatefulWidget {
  final int currentTab;
  const Dashboard({@required this.currentTab});
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedIndex = widget.currentTab;
  }

  final Widget svg = new SvgPicture.asset(
    SVGFiles.success_icon,
    semanticsLabel: 'Akaunt-book',
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
        body: StoreConnector<AppState, AppState>(
          converter: (store)=>store.state,
          onInitialBuild: (state) async {
          },
          builder: (context, state){
            return Container(
              decoration: BoxDecoration(
                  border: Border(top: BorderSide(width: 2, color: Theme.of(context).accentColor))
              ),
              child: _children[_selectedIndex],
            );
          }
        ),
        drawer: SizedBox(
          width: size.width,
          child: Drawer(
            child: Container(
                color: Theme.of(context).primaryColor,
                child: SafeArea(
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left:15.0),
                            child: ImageAvatars().miniLogoAvatar(),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: InkWell(
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 30,
                              ),
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          )
                        ],
                      ),
                      Expanded(
                        child: menuView(menu.menuList),
                      )
                    ],
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
    return StoreConnector<AppState, AppState>(
      converter: (store)=>store.state,
      builder: (context, state){
        return Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 30.0, left: 15),
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
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom:10.0),
                      child: Text("Active Business", style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold),),
                    ),
                    Row(children: <Widget>[
                      DisplayImage().displayProfileImage(state.currentBusiness.imageUrl),
                      SizedBox(width: 10,),
                      Text("${state.currentBusiness.name}")
                    ],)
                  ],
                ),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}
