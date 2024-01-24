import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pleyona_app/theme.dart';
import 'package:pleyona_app/ui/widgets/custom_appbar.dart';
import 'package:pleyona_app/ui/widgets/theme_background.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';


class QRScanner extends StatefulWidget {
  const QRScanner({
    required this.setStateCallback,
    required this.allowedFormat,
    required this.description,
    super.key
  });

  final Function(Barcode) setStateCallback;
  final List<BarcodeFormat> allowedFormat;
  final String description;

  @override
  State<QRScanner> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {

  final GlobalKey qrKey = GlobalKey(debugLabel: "QRScanner");
  Barcode? result;
  QRViewController? controller;


  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      controller.pauseCamera();
      if (scanData.code != null) {
        print("SCANNED DATA:  ${scanData.code}");
        widget.setStateCallback(scanData);
        Navigator.of(context).pop();
      } else {
        controller.resumeCamera();
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    print('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 220.0;

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: const CustomAppBar(child: Text("Сканер",
            style: AppStyles.mainTitleTextStyle), scrollController: null, hideHomeButton: true),
        body: ThemeBackgroundWidget(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              children: [
                const SizedBox(height: 90),
                Expanded(
                  child: QRView(
                    key: qrKey,
                    overlay: QrScannerOverlayShape(
                        borderColor: Colors.red,
                        borderRadius: 10,
                        borderLength: 30,
                        borderWidth: 10,
                        cutOutSize: scanArea),
                    formatsAllowed: widget.allowedFormat,
                    onQRViewCreated: _onQRViewCreated,
                    onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
                  ),
                ),
                const SizedBox(height: 20,),
                Container(
                  width: MediaQuery.of(context).size.width - 20,
                  height: 200,
                  child: Text(widget.description,
                    style: TextStyle(fontSize: 20, height: 1),
                    textAlign: TextAlign.justify,
                  )
                ),
                const SizedBox(height: 10,),
                Material(
                  color: AppColors.transparent,
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    child: Ink(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0x4DFFFFFF),
                        ),
                        child: FutureBuilder(
                          future: controller?.getFlashStatus(),
                          builder: (context, snapshot) {
                            return InkWell(
                              onTap: () async {
                                await controller?.toggleFlash();
                                setState(() {});
                              },
                              customBorder: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(64)
                              ),
                              splashColor: AppColors.cardColor3,
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0x80FFFFFF)
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(13),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(width: 3, color: AppColors.backgroundMain2),
                                      color: Color(0x8CFFFFFF)
                                  ),
                                  child: snapshot.data == null
                                      ? Image.asset("assets/icons/no-flash.png")
                                      : Image.asset(
                                      snapshot.data! ? "assets/icons/flash.png" : "assets/icons/no-flash.png"
                                  ),
                                ),
                              ),
                            );
                          },
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ScannerScreenArguments {
  final Function(Barcode) setStateCallback;
  final List<BarcodeFormat> allowedFormat;
  final String description;

  const ScannerScreenArguments({
    required this.setStateCallback,
    required this.allowedFormat,
    required this.description
  });
}