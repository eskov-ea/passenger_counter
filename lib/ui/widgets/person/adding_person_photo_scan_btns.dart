import 'package:flutter/cupertino.dart';
import 'package:pleyona_app/ui/widgets/scan_button.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../camera_view_widget.dart';

class PersonAddingPhotoScanOptionsWidget extends StatelessWidget {
  const PersonAddingPhotoScanOptionsWidget({
    required this.onQRScanResultCallback,
    required this.allowedFormat,
    super.key
  });

  final Function(Barcode) onQRScanResultCallback;
  final List<BarcodeFormat>  allowedFormat;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width - 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CameraViewWidget(width: MediaQuery.of(context).size.width / 5 * 2 - 20),
          ScanButton(onQRScanResultCallback: onQRScanResultCallback, allowedFormat: allowedFormat,
            width: MediaQuery.of(context).size.width / 5 * 3 - 20, height: 150,
          )
        ],
      ),
    );
  }
}
