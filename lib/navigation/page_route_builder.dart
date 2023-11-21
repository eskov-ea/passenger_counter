// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class CustomPageRouteBuilder extends PageRouteBuilder {
//
//   final RoutePageBuilder pageBuilder;
//   final PageTransitionsBuilder matchingBuilder = const CupertinoPageTransitionsBuilder(); // Default iOS/macOS (to get the swipe right to go back gesture)
//   // final PageTransitionsBuilder matchingBuilder = const FadeUpwardsPageTransitionsBuilder(); // Default Android/Linux/Windows
//
//   CustomPageRouteBuilder({required this.pageBuilder});
//
//   @override
//   Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
//     return pageBuilder(context, animation, secondaryAnimation);
//   }
//
//   @override
//   bool get maintainState => true;
//
//   @override
//   Duration get transitionDuration => Duration(milliseconds: 900); // Can give custom Duration, unlike in MaterialPageRoute
//
//   @override
//   Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
//     return matchingBuilder.buildTransitions(this, context, animation, secondaryAnimation, child);
//   }
//
// }