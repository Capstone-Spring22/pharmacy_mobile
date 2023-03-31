import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/controllers/user_controller.dart';
import 'package:pharmacy_mobile/screens/address/address.dart';
import 'package:pharmacy_mobile/screens/user/widget/address_info.dart';

class AddressCard extends GetView<UserController> {
  const AddressCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: context.theme.primaryColor),
            ),
            child: ListTile(
              leading: const Icon(Icons.location_on),
              title: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text("Address"),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            Get.put(AddressController());
                            showModalBottomSheet(
                              useSafeArea: true,
                              enableDrag: true,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(25.0))),
                              context: Get.context!,
                              builder: (context) {
                                return const AddressSelectionScreen();
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    ...controller.detailUser.value.customerAddressList!
                        .map((e) => AddressInfo(address: e))
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
