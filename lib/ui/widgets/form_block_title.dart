import 'package:flutter/cupertino.dart';

class BlockTitle extends StatelessWidget {
  const BlockTitle({
    required this.message,
    this.alignment = Alignment.centerLeft,
    this.bottomPadding = 15,
    super.key
  });
  final String message;
  final Alignment alignment;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width ,
      padding: EdgeInsets.only(bottom: bottomPadding),
      alignment: alignment,
      child: Text(message,
        textAlign: TextAlign.start,
        style: const TextStyle(fontSize: 24, color: Color(0xFF000000), fontWeight: FontWeight.w500),
      ),
    );
  }
}
