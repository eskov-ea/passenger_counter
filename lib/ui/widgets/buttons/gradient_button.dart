// import 'package:flutter/material.dart';
//
// class GradientButton extends StatefulWidget {
//   const GradientButton({
//     this.colors = const [Color(0xFFFFFFFF), Color(0xFF00FFFFFF), Color(0xFFFF00FF)],
//     this.alignments = const [Alignment.topCenter, Alignment.bottomCenter],
//     required this.width,
//     required this.height,
//     Key? key
//   }) : super(key: key);
//
//   final List<Color> colors;
//   final List<Alignment> alignments;
//   final double width;
//   final double height;
//
//   @override
//   State<GradientButton> createState() => _GradientButtonState();
// }
//
// class _GradientButtonState extends State<GradientButton> with SingleTickerProviderStateMixin{
//
//   late final AnimationController _animationController;
//   late final Animation<double> animation;
//   late Animatable<Color> background;
//
//   initTweenSequence() {
//     List<TweenSequenceItem<Color>> items = [];
//     for(int i=0; i<widget.colors.length-1; ++i) {
//       final tweenColor = TweenSequenceItem(
//         weight: 1.0,
//         tween: ColorTween(
//           begin: widget.colors[i],
//           end: widget.colors[i+1],
//         ),
//       );
//       items.add(tweenColor);
//     }
//     return TweenSequence(items);
//   }
//
//
//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 5000),
//     )..repeat();
//     // animation = AlwaysStoppedAnimation(_animationController.value);
//     background = initTweenSequence();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _animationController,
//       builder: (BuildContext context, Widget? child) {
//         return Container(
//           color: background.evaluate(AlwaysStoppedAnimation(_animationController.value)),
//           child: child,
//         );
//       },
//     );
//   }
// }
