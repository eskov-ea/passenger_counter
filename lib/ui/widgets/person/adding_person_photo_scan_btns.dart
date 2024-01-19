import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  final Map? personDraft;

  Widget _getPersonDraftName() {
    if (personDraft != null && personDraft!["lastname"] != "") {
      return Text("[ ${personDraft!["lastname"]} ${personDraft!["firstname"]} ]",
        style: TextStyle(fontSize: 12, color: Color(0xFF000000)),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    print("DRAFT:::  $personDraft");
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
              Material(
                color: Colors.transparent,
                child: Ink(
                  width: MediaQuery.of(context).size.width / 5 * 3 - 20,
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    color: personDraft == null ? Color(0x80ffffff) : Color(0xFFFFFFFF),
                    border: Border.all(width: 1, color: personDraft == null ? Color(0xffa9a9a9) : Color(0xFF000000))
                  ),
                  child: InkWell(
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    onTap: (){
                      if (personDraft != null) {
                        setPersonWithDraft();
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Восстановть черновик",
                            style: TextStyle(
                              color: personDraft == null ? Color(0xffa9a9a9) : Color(0xFF000000),
                              fontSize: 18
                            )
                        ),
                        _getPersonDraftName()
                      ],
                    )
                  ),
                ),
              ),
              const SizedBox(height: 12),
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
