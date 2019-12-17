import 'package:akaunt/utilities/svg_files.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ImageAvatars extends StatelessWidget {
  final Widget attachsvg = new SvgPicture.asset(
    SVGFiles.attach_picture,
    semanticsLabel: 'Akaunt-book',
    allowDrawingOutsideViewBox: true,
  );

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Widget largeLogoAvatar() {
    return Container(
      width: 2000,
      height: 2000,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        image: DecorationImage(
          image: AssetImage("images/akaunt_logo.png"),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget miniLogoAvatar() {
    return Container(
      height: 100,
      width: 150,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        image: DecorationImage(
          image: AssetImage("images/akaunt_logo.png"),
          fit: BoxFit.fitWidth,
        ),
      ),
    );

  }
  Widget attachImage() {
    return attachsvg;
  }
}
