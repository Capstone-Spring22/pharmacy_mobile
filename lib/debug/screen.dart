import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/controllers/app_controller.dart';
import 'package:pharmacy_mobile/controllers/vn_pay.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DebugScreen extends StatefulWidget {
  const DebugScreen({super.key});

  @override
  State<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {
  late WebViewController controller;
  bool isLoaded = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.clearCache();
    controller.clearLocalStorage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Debug")),
      body: Center(
        // child: WebViewWidget(controller: controller),
        child: FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("data");
            } else {
              String ip = snapshot.data!;
              String tmnCode = dotenv.env['VNPAY_tmnCode']!;
              String hash = dotenv.env['VNPAY_Hash']!;
              final url = VNPAYFlutter.instance.generatePaymentUrl(
                version: '2.0.1',
                tmnCode: tmnCode,
                txnRef: AppController().generateRefBill(),
                amount: 500000,
                returnUrl: 'https://www.ff.com/',
                ipAdress: ip,
                vnpayHashKey: hash,
              );

              controller = WebViewController()
                ..setJavaScriptMode(JavaScriptMode.unrestricted)
                ..setBackgroundColor(const Color(0x00000000))
                ..setNavigationDelegate(
                  NavigationDelegate(
                    onNavigationRequest: (NavigationRequest request) {
                      Get.log(request.url);
                      if (request.url.startsWith('https://www.google.com/')) {
                        Get.toNamed('/navhub');
                        return NavigationDecision.navigate;
                      }
                      return NavigationDecision.navigate;
                    },
                  ),
                )
                ..loadRequest(Uri.parse(url));

              return WebViewWidget(controller: controller);
            }
          },
          future: appController.getIpAddress(),
        ),
      ),
    );
  }
}
