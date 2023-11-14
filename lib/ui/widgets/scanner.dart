import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';


class Scanner extends StatefulWidget {
  const Scanner({
    required this.setStateCallback,
    required this.allowedFormat,
    super.key
  });

  final Function(Barcode) setStateCallback;
  final List<BarcodeFormat> allowedFormat;

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
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
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              const SizedBox(height: 70,),
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
              const SizedBox(height: 10,),
              Container(
                width: MediaQuery.of(context).size.width - 20,
                height: 300,
                child: Column(
                  children: [

                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

class ScannerScreenArguments {
  final Function(Barcode) setStateCallback;
  final List<BarcodeFormat> allowedFormat;

  const ScannerScreenArguments({
    required this.setStateCallback,
    required this.allowedFormat
  });
}