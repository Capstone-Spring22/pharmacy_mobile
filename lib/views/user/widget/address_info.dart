import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/models/detail_user.dart';
import 'package:pharmacy_mobile/views/address/address.dart';

class AddressInfo extends StatelessWidget {
  const AddressInfo({super.key, required this.address});

  final CustomerAddressList address;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => addressController.switchMainAddress(address.id!),
      onLongPress: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Text(address.fullyAddress!),
            ),
            Obx(() {
              if (addressController.isEditAddress.isTrue) {
                return IconButton(
                  onPressed: () {
                    addressController.openEditAddress(
                      address.cityId!,
                      address.districtId!,
                      address.wardId!,
                      address.homeAddress!,
                      address.id!,
                    );
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
                          AddressSelectionScreen(id: address.id!),
                    ).then((value) {
                      addressController.closeEditAddress();
                    });
                  },
                  icon: const Icon(Icons.edit),
                );
              } else {
                return Radio(
                  value: address.id,
                  groupValue: addressController.selectedAddressid.value,
                  onChanged: (value) {
                    addressController.switchMainAddress(value!);
                  },
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}
