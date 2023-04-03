import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/models/detail_user.dart';
import 'package:pharmacy_mobile/screens/address/address.dart';

class AddressInfo extends StatelessWidget {
  const AddressInfo({super.key, required this.address});

  final CustomerAddressList address;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => addressController.switchMainAddress(address.id!),
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Delete Address"),
              content: const Text("Are you sure to delete this address?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    AddressService().removeAddress(address.id!).then((value) {
                      userController.refeshUser();
                      Get.back();
                    });
                  },
                  child: const Text("Delete"),
                ),
              ],
            );
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Text(address.fullyAddress!),
            ),
            Obx(() => Radio(
                  value: address.id,
                  groupValue: addressController.selectedAddressid.value,
                  onChanged: (value) {
                    addressController.switchMainAddress(value!);
                  },
                )),
          ],
        ),
      ),
    );
  }
}
