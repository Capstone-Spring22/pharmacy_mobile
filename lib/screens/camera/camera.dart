import 'package:flutter/material.dart';
import 'package:pharmacy_mobile/helpers/qr_scanner.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: QrScannerWidget(),
    );
  }
}
