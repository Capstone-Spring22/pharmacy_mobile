import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/controllers/app_controller.dart';
import 'package:pharmacy_mobile/controllers/vn_pay.dart';
import 'package:pharmacy_mobile/helpers/loading.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VNPayScreen extends StatefulWidget {
  const VNPayScreen({super.key});

  @override
  State<VNPayScreen> createState() => _VNPayScreenState();
}

class _VNPayScreenState extends State<VNPayScreen> {
  late WebViewController controller;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.clearCache();
    controller.clearLocalStorage();
    super.dispose();
  }

  final String url = 'https://www.betterhealthapi.azurewebsites.net/';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("VN Pay")),
      body: Center(
        // child: WebViewWidget(controller: controller),
        child: FutureBuilder(
          future: appController.getIpAddress(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingWidget();
            } else {
              String ip = snapshot.data!;
              String tmnCode = dotenv.env['VNPAY_tmnCode']!;
              String hash = dotenv.env['VNPAY_Hash']!;

              final genPayment = VNPAYFlutter.instance.generatePaymentUrl(
                version: '2.0.1',
                tmnCode: tmnCode,
                txnRef: AppController().generateRefBill(),
                amount: cartController.calculateTotal() + 10000,
                returnUrl: url,
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
                      if (request.url.startsWith(url)) {
                        Get.back(result: request.url);
                        return NavigationDecision.navigate;
                      }
                      return NavigationDecision.navigate;
                    },
                  ),
                )
                ..loadRequest(Uri.parse(genPayment));

              return WebViewWidget(controller: controller);
            }
          },
        ),
      ),
    );
  }
}
