import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/constrains/theme.dart';
import 'package:pharmacy_mobile/controllers/camera_controller.dart';
import 'package:pharmacy_mobile/helpers/loading.dart';
import 'package:pharmacy_mobile/main.dart';
import 'package:pharmacy_mobile/views/home/widgets/product_tile.dart';
import 'package:pharmacy_mobile/services/product_service.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  @override
  void initState() {
    Get.put(QrCameraController());
    cameraController.isScanning.trigger(true);
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<QrCameraController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = Get.height * .7;
    double width = Get.width * .8;
    int flipDuration = 600;
    return Scaffold(
      appBar: AppBar(
          // title: Text(cartController.listCart[0].quantity.toString()),
          ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        // child: QrScannerWidget(),
        child: Center(
          child: Column(
            children: [
              FlipCard(
                speed: flipDuration,
                flipOnTouch: false,
                controller: cameraController.flipController,
                direction: FlipDirection.HORIZONTAL,
                side: CardSide.FRONT,
                front: SizedBox(
                  height: height,
                  width: width,
                  child: const QrCamera(),
                ),
                back: SizedBox(
                  height: height,
                  width: width,
                  child: Obx(() => cameraController.result.value == null
                      ? Container()
                      : ProductScannerLoaded(
                          cameraController.result.value!.code!)),
                ),
              ),
              // Obx(() => Text(cameraController.isScanning.value == true
              //     ? "Nope"
              //     : "Code ${cameraController.result.value!.code}"))
              Obx(() {
                return AnimatedSwitcher(
                  duration: Duration(milliseconds: flipDuration),
                  child: cameraController.isScanning.value == true
                      ? const Text("Scan a product")
                      : Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                cameraController.flipController.toggleCard();
                                cameraController.isScanning.toggle();
                                cameraController.qrController!.resumeCamera();
                              },
                              icon: const Icon(Icons.camera_alt_sharp),
                            ),
                            const Text("Scan again")
                          ],
                        ),
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}

class ProductScannerLoaded extends StatelessWidget {
  const ProductScannerLoaded(this.code, {super.key});

  final String code;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: context.theme.primaryColor),
      ),
      child: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingWidget();
          } else if (snapshot.data == null) {
            return const Center(
              child: Text("No Item Found, Please Scan again"),
            );
          } else {
            final product = snapshot.data;
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: CachedNetworkImage(
                    imageUrl: product!.imageModel!.imageURL!,
                    placeholder: (context, url) => LoadingWidget(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                AutoSizeText(
                  product.name!,
                  maxLines: 3,
                ),
                Text(
                  '${product.priceAfterDiscount!.convertCurrentcy()} / ${product.productUnitReferences![0].unitName}',
                  textAlign: TextAlign.center,
                  style: tilePrice.copyWith(color: Colors.blue),
                ),
                BuyButton(
                  id: product.id!,
                  price: product.price!,
                  priceAfterDiscount: product.priceAfterDiscount!,
                ),
              ],
            );
          }
        },
        future: ProductService().getProductByBarcode(code),
      ),
    );
  }
}

class QrCamera extends StatefulWidget {
  const QrCamera({super.key});

  @override
  State<QrCamera> createState() => _QrCameraState();
}

class _QrCameraState extends State<QrCamera> {
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      cameraController.qrController!.pauseCamera();
    } else if (Platform.isIOS) {
      cameraController.qrController!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: QRView(
        key: cameraController.qrKey,
        onQRViewCreated: cameraController.onQRViewCreated,
      ),
    );
  }
}
