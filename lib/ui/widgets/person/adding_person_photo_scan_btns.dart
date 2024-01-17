import 'package:flutter/cupertino.dart';
import 'package:pleyona_app/ui/widgets/save_button.dart';
import 'package:pleyona_app/ui/widgets/scan_button.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../camera_view_widget.dart';

class PersonAddingPhotoScanOptionsWidget extends StatelessWidget {
  const PersonAddingPhotoScanOptionsWidget({
    required this.onQRScanResultCallback,
    required this.allowedFormat,
    required this.setPhotoResult,
    required this.setPersonWithDraft,
    required this.personBase64Image,
    required this.personDraft,
    super.key
  });

  final Function(Barcode) onQRScanResultCallback;
  final Function(String) setPhotoResult;
  final Function() setPersonWithDraft;
  final List<BarcodeFormat>  allowedFormat;
  final String?  personBase64Image;
  final String?  personDraft;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width - 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CameraViewWidget(setPhotoResult: setPhotoResult,
            personBase64Image: personBase64Image,
            width: MediaQuery.of(context).size.width / 5 * 2 - 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: (){
                  if (personDraft != null) {
                    setPersonWithDraft();
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / 5 * 3 - 20,
                  height: 55,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    color: personDraft == null ? Color(0xCFFFFFFF) : Color(0xFFFFFFFF),
                    border: Border.all(width: 1, color: Color(0xFF000000))
                  ),
                  child: Text("Восстановть черновик", style: TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(height: 20),
              ScanButton(onQRScanResultCallback: onQRScanResultCallback, allowedFormat: allowedFormat,
                width: MediaQuery.of(context).size.width / 5 * 3 - 20, height: 110,
              )
            ],
          )
        ],
      ),
    );
  }
}
