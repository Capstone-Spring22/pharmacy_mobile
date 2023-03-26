import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrCameraController extends GetxController {
  static QrCameraController instance = Get.find();

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Rx<Barcode?> result = null.obs;
  QRViewController? qrController;
  late FlipCardController flipController;
  RxBool isScanning = true.obs;
  bool codeScanned = true;

  @override
  void onInit() {
    flipController = FlipCardController();
    super.onInit();
  }

  @override
  void onReady() {
    isScanning.trigger(true);
    super.onReady();
  }

  void onQRViewCreated(QRViewController controller) {
    qrController = controller;

    controller.scannedDataStream.listen((scanData) {
      result = scanData.obs;
      flipController.toggleCard();
      qrController!.pauseCamera();
      isScanning.value = false;
    });
  }
}
