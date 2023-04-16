import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/helpers/loading.dart';
import 'package:pharmacy_mobile/services/product_service.dart';

import '../../../controllers/checkout_controller.dart';

class PickStore extends StatelessWidget {
  const PickStore({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25),
        child: FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingWidget();
            } else {
              final data = snapshot.data;
              if (data['totalSite'] > 0) {
                final sites = data['siteListToPickUps'];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Chọn cửa hàng",
                          style: context.textTheme.titleMedium,
                        ),
                      ),
                    ),
                    Container(
                      height: Get.height * .3,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          // border: Border.all(color: context.theme.primaryColor),
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xfff6f5f8),
                              spreadRadius: 10,
                              blurRadius: 10,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ]),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: sites.length,
                        itemBuilder: (context, index) {
                          CheckoutController checkoutController = Get.find();
                          return ListTile(
                            onTap: () => checkoutController.selectSite.value =
                                sites[index]['siteId'],
                            title: Text(sites[index]['siteName']),
                            subtitle: GestureDetector(
                              onTap: () {
                                checkoutController
                                    .launchMaps(sites[index]['fullyAddress']);
                              },
                              child: Text(
                                sites[index]['fullyAddress'],
                                style: TextStyle(
                                  color: context.theme.primaryColor,
                                ),
                              ),
                            ),
                            trailing: Obx(
                              () => Radio(
                                value: sites[index]['siteId'],
                                groupValue: checkoutController.selectSite.value,
                                onChanged: (value) {
                                  checkoutController.selectSite.value = value;
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: Text("Không cửa hàng nào còn hàng"),
                );
              }
            }
          },
          future: ProductService().checkAvailSite(),
        ),
      ),
    );
  }
}
