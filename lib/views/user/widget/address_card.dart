import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/controllers/user_controller.dart';
import 'package:pharmacy_mobile/views/address/address.dart';
import 'package:pharmacy_mobile/views/user/widget/address_info.dart';

class AddressCardCollase extends GetView<UserController> {
  const AddressCardCollase({this.textColor = Colors.black, super.key});

  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                // border: Border.all(color: context.theme.primaryColor),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xfff6f5f8),
                    spreadRadius: 10,
                    blurRadius: 10,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ]),
            child: ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text("Địa chỉ chính"),
              subtitle: userController
                      .detailUser.value!.customerAddressList!.isEmpty
                  ? const Text("Không có địa chỉ, hãy thêm địa chỉ")
                  : Text(controller.detailUser.value!.customerAddressList!
                      .singleWhere((element) => element.isMainAddress == true)
                      .fullyAddress!),
              trailing: const Icon(Icons.more_horiz),
            ),
          ),
        ));
  }
}

class AddressCard extends StatefulWidget {
  const AddressCard({super.key, this.textColor = Colors.black});

  final Color textColor;

  @override
  State<AddressCard> createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  bool isCollase = true;

  void onTap() {
    for (var element in userController.detailUser.value!.customerAddressList!) {
      Get.log(element.toString());
    }
    setState(() {
      isCollase = !isCollase;
    });
  }

  @override
  void initState() {
    try {
      addressController.selectedAddressid.value = userController
          .detailUser.value!.customerAddressList!
          .singleWhere((element) => element.isMainAddress == true)
          .id!;

      Get.log(addressController.selectedAddressid.value.toString());
    } catch (e) {
      Get.log('Không có địa chỉ chính');
    }
    super.initState();
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
                // border: Border.all(color: context.theme.primaryColor),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xfff6f5f8),
                    spreadRadius: 10,
                    blurRadius: 10,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ]),
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
                        IconButton(
                          onPressed: () =>
                              addressController.isEditAddress.toggle(),
                          icon: Icon(addressController.isEditAddress.value
                              ? Icons.check
                              : Icons.edit),
                        ),
                      ],
                    ),
                    ...controller.detailUser.value!.customerAddressList!
                        .map((e) => AddressInfo(address: e, key: UniqueKey()))
                        .toList()
                        .reversed
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
