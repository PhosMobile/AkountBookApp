import 'package:akount_books/utilities/svg_files.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ImageAvatars extends StatelessWidget {
  final Widget attachsvg = new SvgPicture.asset(
    SVGFiles.attach_picture,
    semanticsLabel: 'Akount-book',
    allowDrawingOutsideViewBox: true,
  );

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Widget largeLogoAvatar() {
    return CircleAvatar(
      radius: 70,
      backgroundImage: AssetImage("images/akount_book_logo.png"),
    );
  }

  Widget miniLogoAvatar() {
    return CircleAvatar(
      radius: 40,
      backgroundImage: AssetImage("images/akount_book_logo.png"),
    );
  }

  Widget attachImage() {
    return attachsvg;
  }
}
