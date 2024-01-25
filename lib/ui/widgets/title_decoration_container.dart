import 'package:flutter/cupertino.dart';

class TitleDecorationWidget extends StatelessWidget {
  final Widget child;
  final Alignment alignment;
  const TitleDecorationWidget({
    required this.child,
    this.alignment = Alignment.centerLeft,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: alignment,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(6)),
            color: Color(0xFFFFFFFF)
        ),
        child: child
    );
  }
}
