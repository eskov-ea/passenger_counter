import 'dart:convert';
import 'package:flutter/material.dart';


class AvatarWidget extends StatelessWidget {
  const AvatarWidget({
    required this.photo,
    this.width = 100,
    this.height = 100,
    super.key
  });

  final String photo;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.hardEdge,
      shape: const BeveledRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          bottomLeft: Radius.circular(8)
        )
      ),
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(3),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8))
        ),
        child: photo != ""
          ? Image.memory(base64Decode(photo),
            fit: BoxFit.cover,
            width: width,
            height: height,
          )
          : Image.asset("assets/images/no_avatar.png",
            fit: BoxFit.cover,
            width: width,
            height: height,
          ),
      ),
    );
  }
}
