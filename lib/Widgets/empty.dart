import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
class Empty extends StatelessWidget {
  final String text;

  Empty({@required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(MdiIcons.fileMultipleOutline,color: Colors.grey[300],size: 30,),
          SizedBox(height: 10,),
          Text("$text", style: TextStyle(color: Colors.grey[300], fontSize: 16, ),)
        ],
      ),
    );
  }
}
