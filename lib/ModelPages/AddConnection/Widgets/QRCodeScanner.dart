import 'dart:async';

import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:axpertflutter/ModelPages/AddConnection/Controllers/AddConnectionController.dart';
import 'package:axpertflutter/Utils/LogServices/LogService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../Controllers/ProjectController.dart';

class QRCodeScanner extends StatefulWidget {
  const QRCodeScanner({super.key});

  @override
  State<QRCodeScanner> createState() => _QRCodeScannerState();
}

class _QRCodeScannerState extends State<QRCodeScanner> {
  // AddConnectionController addConnectionController = Get.find();
  ProjectController projectController = Get.find();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void initState() {
    // addConnectionController.scannerController = MobileScannerController();
    projectController.scannerController = MobileScannerController();
    super.initState();
  }

  @override
  void dispose() {
    projectController.scannerController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        margin: EdgeInsets.only(left: 20, right: 20, top: 30),
        elevation: 40,
        color: MyColors.white1,
        shadowColor: MyColors.buzzilyblack,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Text(
                "Scan Project QR Code",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Container(
                height: MediaQuery.of(context).size.height * 0.3 > 300 ? 300 : MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width * 0.7 > 300 ? 300 : MediaQuery.of(context).size.width * 0.7,
                child: _buildQrView(context),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Visibility(
                    visible: !projectController.doesDeviceHasFlash(),
                    child: IconButton(onPressed: null, icon: Icon(Icons.no_flash, color: MyColors.PayAzzureColor2)),
                  ),
                  Visibility(
                    visible: projectController.doesDeviceHasFlash(),
                    child: IconButton(
                        onPressed: () {
                          projectController.scannerController!.toggleTorch();
                          projectController.isFlashOn.toggle();
                        },
                        icon: Obx(() => projectController.isFlashOn.value
                            ? Icon(Icons.flash_on, color: MyColors.PayAzzureColor2)
                            : Icon(Icons.flash_off, color: MyColors.PayAzzureColor2))),
                  ),
                  IconButton(
                      onPressed: () async {
                        if (!projectController.isPlayPauseOn.value) {
                          await projectController.scannerController!.pause();
                          projectController.isPlayPauseOn.toggle();
                        } else {
                          await projectController.scannerController!.start();
                          projectController.isPlayPauseOn.toggle();
                        }
                      },
                      icon: Obx(() => !projectController.isPlayPauseOn.value
                          ? Icon(Icons.pause, color: MyColors.PayAzzureColor2)
                          : Icon(Icons.play_arrow_sharp, color: MyColors.PayAzzureColor2))),
                  IconButton(
                      onPressed: () {
                        projectController.scannerController!.switchCamera();
                      },
                      icon: Icon(Icons.flip_camera_ios, color: MyColors.PayAzzureColor2)),
                  IconButton(
                      onPressed: () {
                        projectController.pickImageFromGalleryCalled();
                      },
                      icon: Icon(Icons.filter, color: MyColors.PayAzzureColor2)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildQrView(BuildContext context) {
    var scanArea = MediaQuery.of(context).size.width - 200;
    return MobileScanner(
      controller: projectController.scannerController,
      overlayBuilder: (ctx, cts) => Container(
        decoration: BoxDecoration(border: Border.all(color: MyColors.PayAzzureColor2)),
      ),
      onDetect: (capture) {
        final List<Barcode> barcodes = capture.barcodes;
        print("barcodes length => ${barcodes.length}");
        if (barcodes.isNotEmpty) {
          var barcode = barcodes.first;
          _onQRViewCreated(barcode.rawValue);
        }
        // for (final barcode in barcodes) {
        //   debugPrint('Scanned QR Code length: ${barcodes.length}');
        //   debugPrint('Scanned QR Code: ${barcode.rawValue}');
        // }
      },
    );
  }

  void _onQRViewCreated(String? barcodeRawValue) {
    if (barcodeRawValue != null || barcodeRawValue.toString() != "") {
      print(barcodeRawValue.toString());
      projectController.scannerController!.pause();
      var data = barcodeRawValue.toString();
      if (data == "" || !projectController.validateQRData(data)) {
        LogService.writeLog(message: "[ERROR] QRCodeScanner\nScope: _onQRViewCreated\ndata is null");
        Get.snackbar("Invalid!", "Please choose a valid QR Code",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: Duration(seconds: 1));
        Timer(Duration(seconds: 2), () {
          projectController.scannerController!.start();
        });
      } else
        projectController.decodeQRResult(data);
    }
  }

// _buildQrView(BuildContext context) {
//   // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
//
//   var scanArea =
//       //MediaQuery.of(context).size.height;
//       MediaQuery.of(context).size.width - 200;
//
//   // To ensure the Scanner view is properly sizes after rotation
//   // we need to listen for Flutter SizeChanged notification and update controller
//   return QRView(
//     key: qrKey,
//     onQRViewCreated: _onQRViewCreated,
//     overlay: QrScannerOverlayShape(
//         borderColor: MyColors.blue2, borderRadius: 10, borderLength: 30, borderWidth: 10, cutOutSize: scanArea),
//     onPermissionSet: (ctrl, p) => addConnectionController.requestPermissionForCamera(ctrl, p),
//   );
// }

// void _onQRViewCreated(QRViewController controller) {
//   setState(() {
//     addConnectionController.qrViewController = controller;
//   });
//
//   controller.scannedDataStream.listen((scanData) {
//     addConnectionController.barcodeResult = scanData;
//     // print(scanData);
//     if (addConnectionController.barcodeResult.toString() != "") {
//       print(addConnectionController.barcodeResult.toString());
//       controller.pauseCamera();
//       var data = addConnectionController.barcodeResult!.code.toString();
//       if (data == "" || !addConnectionController.validateQRData(data)) {
//         LogService.writeLog(message: "[ERROR] QRCodeScanner\nScope: _onQRViewCreated\ndata is null");
//         Get.snackbar("Invalid!", "Please choose a valid QR Code",
//             snackPosition: SnackPosition.BOTTOM,
//             backgroundColor: Colors.red,
//             colorText: Colors.white,
//             duration: Duration(seconds: 1));
//         Timer(Duration(seconds: 2), () {
//           controller.resumeCamera();
//         });
//       } else
//         addConnectionController.decodeQRResult(data);
//     }
//   });
// }
}
