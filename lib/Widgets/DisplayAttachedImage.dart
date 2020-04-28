import 'package:flutter/material.dart';

class DisplayImage {
  Widget displayAttachedProfileImage(image) {
    return Container(
        width: 130.0,
        height: 130.0,
        decoration: BoxDecoration(
        image: DecorationImage(
        fit: BoxFit.cover,
        image: FileImage(image)
    ),
    borderRadius: BorderRadius.all(Radius.circular(500.0)),
    color: Colors.redAccent,
    )
    );
  }

  Widget displayProfileImage(image) {
    return Container(
        width: 40.0,
        height:40.0,
        decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(image)
          ),
          borderRadius: BorderRadius.all(Radius.circular(500.0)),
          color: Colors.redAccent,
        )
    );
  }

  Widget editProfileImage(image) {
    return Container(
        width: 130.0,
        height: 130.0,
        decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(image)
          ),
          borderRadius: BorderRadius.all(Radius.circular(500.0)),
          color: Colors.redAccent,
        )
    );
  }



}
