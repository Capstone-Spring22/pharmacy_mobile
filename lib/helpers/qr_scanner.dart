// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScannerWidget extends StatefulWidget {
  const QrScannerWidget({super.key});

  @override
  State<QrScannerWidget> createState() => _QrScannerWidgetState();
}

class _QrScannerWidgetState extends State<QrScannerWidget> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  Barcode? preResult;
  bool first = true;

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
      if (first) {
        first = false;
        setState(() {
          result = scanData;
        });
      } else {
        if (scanData.code != result!.code) {
          setState(() {
            result = scanData;
          });
        } else {}
      }
    });
  }

  List<ObbModel> list = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),
        ),
        Expanded(
          flex: 1,
          child: Center(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  (result != null)
                      ? FutureBuilder(
                          builder: (context, snapshot) {
                            print(result!.code!);
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator.adaptive();
                            } else {
                              if (snapshot.data == 1) {
                                return const Text("Product not found!!!");
                              } else if (snapshot.data == null) {
                                return const Text("Error Null!!!");
                              } else {
                                var name =
                                    snapshot.data["product"]["product_name"];
                                try {
                                  name = name as String;
                                  if (name.isEmpty) {
                                    name = "Product name not available";
                                  }
                                } catch (e) {
                                  print(e);
                                  name = "Product name not available";
                                }
                                return ListTile(
                                  leading: Image.network(snapshot
                                      .data["product"]["image_front_url"]),
                                  title: Text(name),
                                  trailing: IconButton(
                                    onPressed: () {
                                      var obj = ObbModel(
                                        name,
                                        snapshot.data["product"]
                                            ["image_front_url"],
                                        1,
                                      );
                                      bool contain = false;
                                      for (var element in list) {
                                        if (element.img == obj.img) {
                                          contain = true;
                                          setState(() {
                                            element.quan = element.quan + 1;
                                          });
                                        }
                                      }
                                      if (contain == false) {
                                        setState(() {
                                          list.add(obj);
                                        });
                                      }
                                    },
                                    icon: const Icon(
                                        Icons.add_shopping_cart_rounded),
                                  ),
                                );
                              }
                            }
                          },
                          future: barcodeLookup(result!.code!),
                        )
                      : const Text('Scan a code'),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Image.network(list[index].img),
                          title: AutoSizeText(
                            list[index].t,
                            maxLines: 1,
                          ),
                          subtitle: Text('Quantity: ${list[index].quan}'),
                        );
                      },
                      itemCount: list.length,
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Future barcodeLookup(String id) async {
    final String api =
        "https://world.openfoodfacts.org/api/v0/product/$id.json";

    print(api);
    var response = await Dio().get(api);
    if (response.statusCode == 200) {
      if (response.data["status_verbose"] == "product found") {
        return response.data;
      } else {
        return 1;
      }
    }
    return null;
  }
}

class ObbModel {
  final String t;
  final String img;
  int quan;

  ObbModel(this.t, this.img, this.quan);

  @override
  bool operator ==(covariant ObbModel other) {
    if (identical(this, other)) return true;

    return other.t == t && other.img == img && other.quan == quan;
  }

  @override
  int get hashCode => t.hashCode ^ img.hashCode ^ quan.hashCode;

  @override
  String toString() => 'ObbModel(t: $t, img: $img, quan: $quan)';
}
