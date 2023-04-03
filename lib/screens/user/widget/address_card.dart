import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/controllers/user_controller.dart';
import 'package:pharmacy_mobile/screens/address/address.dart';
import 'package:pharmacy_mobile/screens/user/widget/address_info.dart';

class AddressCardCollase extends GetView<UserController> {
  const AddressCardCollase({super.key});

  @override
  Widget build(BuildContext context) {
    bool isEmpty = userController.detailUser.value.customerAddressList!.isEmpty;
    return Obx(() => Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: context.theme.primaryColor),
            ),
            child: ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text("Primary Address"),
              subtitle: isEmpty
                  ? const Text("Please add an Address")
                  : Text(controller.detailUser.value.customerAddressList!
                      .singleWhere((element) => element.isMainAddress == true)
                      .fullyAddress!),
              trailing: const Icon(Icons.more_horiz),
            ),
          ),
        ));
  }
}

class AddressCard extends StatefulWidget {
  const AddressCard({super.key});

  @override
  State<AddressCard> createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  bool isCollase = true;

  void onTap() {
    setState(() {
      isCollase = !isCollase;
    });

    // CheckoutController checkoutController = Get.find();

    // checkoutController.scrollController.value?.animateTo(
    //   checkoutController.scrollController.value!.position.maxScrollExtent,
    //   duration: const Duration(milliseconds: 200),
    //   curve: Curves.easeOut,
    // );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child:
            isCollase ? const AddressCardCollase() : const AddressCardExtend(),
      ),
    );
  }
}

class AddressCardExtend extends GetView<UserController> {
  const AddressCardExtend({super.key});

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
                        const Text("Primary Address"),
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
                        .map((e) => AddressInfo(address: e, key: UniqueKey()))
                        .toList()
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
