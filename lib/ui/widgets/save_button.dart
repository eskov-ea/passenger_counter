import 'package:flutter/material.dart';
import 'package:pleyona_app/theme.dart';


class SaveButton extends StatelessWidget {
  const SaveButton({
    required this.onTap,
    super.key
  });

  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Ink(
        width: MediaQuery.of(context).size.width,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          border: Border.all(width: 2, color: AppColors.accent2),
          color: AppColors.accent4,
        ),
        child: InkWell(
            onTap: onTap,
            splashColor: AppColors.accent5,
            child: const Center(
              child: Text(
                "Сохранить",
                style: TextStyle(fontSize: 24, ),
              ),
            )
        ),
      ),
    );
  }
}
