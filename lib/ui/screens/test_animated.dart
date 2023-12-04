import 'package:flutter/material.dart';
import 'package:pleyona_app/ui/widgets/custom_appbar.dart';
import 'package:pleyona_app/ui/widgets/theme_background.dart';

class TestAnimated extends StatefulWidget {
  const TestAnimated({Key? key}) : super(key: key);

  @override
  State<TestAnimated> createState() => _TestAnimatedState();
}

class _TestAnimatedState extends State<TestAnimated> {

  bool isTypeMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(child: null, scrollController: null,),
      extendBodyBehindAppBar: true,
      body: ThemeBackgroundWidget(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.blueGrey,
          child: Column(
            children: [
              Container(
                width: 100,
                height: 100,
                color: Colors.white70,
                child: CustomPaint(
                  painter: AnimatedPainter(),
                ),
              )
            ],
          )

          // Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     CustomPaint(
          //       painter: AnimatedPainter(),
          //     ),
          //     SizedBox(height: 100,),
          //     Align(
          //       alignment: Alignment.bottomRight,
          //       child: FloatingActionButton(
          //         onPressed: () {
          //           setState(() {
          //             isTypeMode = !isTypeMode;
          //           });
          //         },
          //       ),
          //     )
          //   ],
          // ),
        ),
      ),
    );
  }
}

class AnimatedPainter extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.blueAccent;
    final paint2 = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.orange;
    final offset = Offset(100, 100);
    final rect = Rect.fromLTWH(size.width/4, size.height/4, 200, 200);

    canvas.drawLine(Offset(size.width/2, size.height/4), offset, paint);
    canvas.drawRect(rect, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

}
