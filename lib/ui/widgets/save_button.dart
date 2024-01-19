import 'package:flutter/material.dart';
import 'package:pleyona_app/theme.dart';


class SaveButton extends StatelessWidget {

  const SaveButton({
    required this.onTap,
    required this.label,
    this.color = const Color(0xFF35D2AB),
    super.key
  });

  final onTap;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFFFFF),
      child: Ink(
        width: MediaQuery.of(context).size.width,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          // border: Border.all(width: 2, color: AppColors.accent2),
          color: color,
        ),
        child: InkWell(
            onTap: onTap,
            splashColor: AppColors.accent5,
            child: Center(
              child: Text(
                label,
                style: const TextStyle(fontSize: 24, ),
              ),
            )
        ),
      ),
    );
  }
}
