import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/controllers/user_controller.dart';
import 'package:pharmacy_mobile/views/address/address.dart';
import 'package:pharmacy_mobile/views/user/widget/address_info.dart';

class AddressCardCollase extends GetView<UserController> {
  const AddressCardCollase({super.key});

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
              title: const Text("Địa chỉ chính"),
              subtitle: userController
                      .detailUser.value.customerAddressList!.isEmpty
                  ? const Text("Không có địa chỉ, hãy thêm địa chỉ")
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
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
        child: Container(
          child: isCollase
              ? const AddressCardCollase()
              : const AddressCardExtend(),
        ),
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
                        const Text("Địa chỉ chính"),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            Get.put(AddressController());
                            showModalBottomSheet(
                              useSafeArea: true,
                              enableDrag: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(42.0),
                                  topRight: Radius.circular(42.0),
                                ),
                              ),
                              context: Get.context!,
                              builder: (context) =>
                                  const AddressSelectionScreen(),
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