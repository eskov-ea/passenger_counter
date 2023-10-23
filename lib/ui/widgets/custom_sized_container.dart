import 'package:flutter/cupertino.dart';

Widget CustomSizeContainer(Widget child, BuildContext context) {

  double _computeTopPadding(double height) {
    if (height <= 900) {
      return 60;
    } else {
      return 60 + ( height -900 ) * 0.35;
    }
  }

  double _computeWidth(double width) {
    if (width < 500) {
      return width;
    } else {
      return 500 + ( width -500 ) * 0.5;
    }
  }

  return Center(
    child: Container(
      padding: EdgeInsets.only(top: _computeTopPadding(MediaQuery.of(context).size.height)),
      width: _computeWidth(MediaQuery.of(context).size.width),
      child: child,
    ),
  );
}