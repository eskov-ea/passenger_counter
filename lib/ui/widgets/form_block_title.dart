import 'package:flutter/cupertino.dart';

class BlockTitle extends StatelessWidget {
  const BlockTitle({
    required this.message,
    this.alignment = Alignment.centerLeft,
    super.key
  });
  final String message;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width ,
      padding: const EdgeInsets.only(bottom: 15),
      alignment: alignment,
      child: Text(message,
        textAlign: TextAlign.start,
        style: const TextStyle(fontSize: 24, color: Color(0xFF000000), fontWeight: FontWeight.w500),
      ),
    );();
  }
}
