import 'package:flutter/material.dart';

Future goTo(BuildContext context, Widget page, {goBack = true}) {
  var nav;

  if (goBack) {
    nav = Navigator.push;
  } else {
    nav = Navigator.pushReplacement;
  }
  return nav(context, MaterialPageRoute(builder: (BuildContext context) {
    return page;
  }));
}
