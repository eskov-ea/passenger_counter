import 'package:flutter/material.dart';
import 'package:pleyona_app/navigation/navigation.dart';
import 'package:pleyona_app/theme.dart';
import 'package:pleyona_app/ui/screens/qr_scanner.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';


class ScanButton extends StatelessWidget {
  const ScanButton({
    required this.onQRScanResultCallback,
    required this.allowedFormat,
    this.height = 60,
    this.width = 300,
    super.key
  });

  final Function(Barcode) onQRScanResultCallback;
  final List<BarcodeFormat> allowedFormat;
  final double height;
  final double width;

  final String description = "Чтобы считать данные с bar-кода, наведите камеру на bar-код. Код должен быть читаем и освещение должно быть достаточным для распознования, в противном случае вы можете использовать фонарик камеры.";

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Ink(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          border: Border.all(width: 2, color: Color(0xFF487ABB)),
          color: AppColors.backgroundMain5,
        ),
        child: InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(
                MainNavigationRouteNames.scannerScreen,
                arguments: ScannerScreenArguments(setStateCallback: onQRScanResultCallback,
                    allowedFormat: allowedFormat, description: description
                )
              );
            },
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
                      style: TextStyle(fontSize: 20),
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
