import 'package:flutter/material.dart';
import 'package:pleyona_app/theme.dart';


class ScanButton extends StatelessWidget {
  const ScanButton({
    super.key
  });

  // final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Ink(
        width: MediaQuery.of(context).size.width,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          border: Border.all(width: 2, color: AppColors.accent2),
          color: AppColors.backgroundMain5,
        ),
        child: InkWell(
            onTap: () {   },
            splashColor: AppColors.backgroundMain4,
            child: Center(
              child: RichText(
                text: TextSpan(
                  children: [
                    WidgetSpan(
                      child: Icon(Icons.qr_code_scanner, color: AppColors.textMain,),
                    ),
                    const WidgetSpan(
                      child: SizedBox(width: 10,),
                    ),
                    const TextSpan(
                      text: "Сканировать",
                      style: TextStyle(fontSize: 24),
                    )
                  ],

                ),
              ),
            )
        ),
      ),
    );
  }
}
