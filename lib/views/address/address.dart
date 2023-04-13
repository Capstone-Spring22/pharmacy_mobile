import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/helpers/snack.dart';
import 'package:pharmacy_mobile/models/detail_user.dart';
import 'package:pharmacy_mobile/widgets/input.dart';

class AddressSelectionScreen extends StatefulWidget {
  const AddressSelectionScreen({super.key, this.isForCreateUser = false});

  final bool isForCreateUser;

  @override
  State<AddressSelectionScreen> createState() => _AddressSelectionScreenState();
}

class _AddressSelectionScreenState extends State<AddressSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: SizedBox(
          height: Get.height * .5,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Obx(
                () => addressController.isCityLoaded.value
                    ? IgnorePointer(
                        child: dropdownBox(
                          disableHint: const Text(
                              'Hiện chỉ hỗ trợ Thành Phố Hồ Chí Minh'),
                          hint: null,
                          items: addressController.listCityItems,
                          value:
                              addressController.selectedCityId.value.isNotEmpty
                                  ? addressController.selectedCityId.value
                                  : null,
                          searchController: addressController.searchCityCtrl,
                          searchInnerWidget: Input(
                            inputController: addressController.searchCityCtrl,
                          ),
                          onChanged: addressController.changeCity,
                          searchMatchFn: addressController.searchCity,
                        ),
                      )
                    : const CircularProgressIndicator.adaptive(),
              ),
              Obx(() {
                if (addressController.selectedCityId.isEmpty) {
                  return Container();
                } else if (addressController.isDistrictLoaded.value) {
                  return dropdownBox(
                    hint: const Text("Chọn Quận"),
                    items: addressController.listDistrictItem,
                    value: addressController.selectedDistrictId.value.isNotEmpty
                        ? addressController.selectedDistrictId.value
                        : null,
                    searchController: addressController.searchDistrictCtrl,
                    searchInnerWidget: Input(
                      inputController: addressController.searchDistrictCtrl,
                    ),
                    onChanged: addressController.changeDistrict,
                    searchMatchFn: addressController.searchDistrict,
                  );
                } else {
                  return const CircularProgressIndicator.adaptive();
                }
              }),
              Obx(() {
                if (addressController.selectedCityId.isEmpty ||
                    addressController.selectedDistrictId.isEmpty) {
                  return Container();
                } else if (addressController.isWardLoaded.value) {
                  return dropdownBox(
                    hint: const Text("Chọn Phường/Huyện"),
                    items: addressController.listWardItem,
                    value: addressController.selectedWardId.value.isNotEmpty
                        ? addressController.selectedWardId.value
                        : null,
                    searchController: addressController.searchWardCtrl,
                    searchInnerWidget: Input(
                      inputController: addressController.searchWardCtrl,
                    ),
                    onChanged: addressController.changeWard,
                    searchMatchFn: addressController.searchWard,
                  );
                } else {
                  return const CircularProgressIndicator.adaptive();
                }
              }),
              Obx(
                () {
                  if (addressController.selectedCityId.isEmpty ||
                      addressController.selectedDistrictId.isEmpty ||
                      addressController.selectedWardId.isEmpty) {
                    return Container();
                  }
                  return SizedBox(
                    width: Get.width * .9,
                    child: Input(
                      inputController: addressController.addressTextCtl,
                      inputType: TextInputType.streetAddress,
                      title: "Địa chỉ",
                      onChanged: (v) {
                        addressController.addressTile.value = v;
                      },
                    ),
                  );
                },
              ),
              Obx(
                () => SizedBox(
                  width: Get.width * .8,
                  child: FilledButton(
                    onPressed: addressController.selectedCityId.isEmpty ||
                            addressController.selectedDistrictId.isEmpty ||
                            addressController.selectedWardId.isEmpty ||
                            addressController.addressTile.value.isEmpty
                        ? null
                        : () {
                            addressController
                                .addAddress(widget.isForCreateUser);
                          },
                    child: const Text("Thêm Địa chỉ"),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  DropdownButton2<dynamic> dropdownBox({
    List<DropdownMenuItem<dynamic>>? items,
    dynamic value,
    TextEditingController? searchController,
    Widget? searchInnerWidget,
    bool Function(DropdownMenuItem<dynamic>, String)? searchMatchFn,
    void Function(dynamic)? onChanged,
    Widget? hint,
    Widget? disableHint,
  }) {
    return DropdownButton2(
      isExpanded: true,
      disabledHint: disableHint,
      items: items,
      value: value,
      hint: hint,
      searchController: searchController,
      searchInnerWidget: searchInnerWidget,
      searchInnerWidgetHeight: 100,
      searchMatchFn: searchMatchFn,
      onChanged: onChanged,
      iconSize: 14,
      buttonHeight: 50,
      buttonWidth: Get.width * .8,
      buttonPadding: const EdgeInsets.only(left: 14, right: 14),
      buttonDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.black26,
        ),
      ),
      itemHeight: 40,
      itemPadding: const EdgeInsets.only(left: 14, right: 14),
      dropdownMaxHeight: Get.height * .5,
      dropdownWidth: Get.width * .8,
      dropdownPadding: null,
      dropdownDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
      ),
      scrollbarRadius: const Radius.circular(40),
      scrollbarThickness: 6,
      scrollbarAlwaysShow: true,
      offset: const Offset(-10, 0),
    );
  }
}

class AddressService {
  final dio = appController.dio;
  String apiUrl = dotenv.env['API_URL']!;

  Future getCity() async {
    try {
      var response = await dio.get('${apiUrl}Address/City');
      return response;
    } catch (e) {
      Get.log("getCity: $e");
    }
  }

  Future getDistrict(String cityId) async {
    try {
      var response = await dio.get('${apiUrl}Address/$cityId/District');
      return response;
    } catch (e) {
      Get.log("getDistrict: $e");
    }
  }

  Future getWard(String districtId) async {
    try {
      var response = await dio.get('${apiUrl}Address/$districtId/Ward');
      return response;
    } catch (e) {
      // Get.log("getWard: $apiUrl - $districtId - $e");
    }
  }

  Future addAddress(Map<String, dynamic> map) async {
    try {
      var response = await dio.post(
        '${apiUrl}CustomerAddress',
        data: map,
        options: userController.options,
      );
      Get.log(response.toString());
      await userController.refeshUser();
      return response;
    } catch (e) {
      Get.log("addAddress: $e");
    }
  }

  Future removeAddress(String id) async {
    try {
      var response = await dio.delete(
        '${apiUrl}CustomerAddress/$id',
        options: userController.options,
      );
      Get.log(response.toString());
      return response;
    } catch (e) {
      Get.log("removeAddress: $e");
    }
  }
}

class AddressController extends GetxController {
  static AddressController instance = Get.find();

  RxString selectedAddressid = "".obs;

  //City
  RxBool isCityLoaded = false.obs;
  RxList<DropdownMenuItem> listCityItems = <DropdownMenuItem>[].obs;
  RxList listCityMap = [].obs;
  RxString selectedCityId = ''.obs;
  final searchCityCtrl = TextEditingController();

  //District
  RxBool isDistrictLoaded = false.obs;
  RxList<DropdownMenuItem> listDistrictItem = <DropdownMenuItem>[].obs;
  RxList listDistrictMap = [].obs;
  RxString selectedDistrictId = ''.obs;
  final searchDistrictCtrl = TextEditingController();

  //Ward
  RxBool isWardLoaded = false.obs;
  RxList<DropdownMenuItem> listWardItem = <DropdownMenuItem>[].obs;
  RxList listWardMap = [].obs;
  RxString selectedWardId = ''.obs;
  final searchWardCtrl = TextEditingController();

  //Address
  final addressTextCtl = TextEditingController();
  RxString addressTile = "".obs;

  RxList<String> listUserAddress = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    getListCity();
    ever(selectedCityId, getListDistrict);
    ever(selectedDistrictId, getListWard);

    ever(userController.detailUser, addListUserAddress);
  }

  void addListUserAddress(DetailUser? user) {
    if (user is DetailUser) {
      int index = 0;
      listUserAddress.clear();
      if (user.customerAddressList != null) {
        for (var element in user.customerAddressList!) {
          listUserAddress.add(element.id!);
          if (element.isMainAddress == true) {
            selectedAddressid.value = element.id!;
            index = listUserAddress.indexOf(element.id);
          }
        }
        userController.detailUser.value!.customerAddressList!.insert(
            0, userController.detailUser.value!.customerAddressList![index]);
        userController.detailUser.value!.customerAddressList!
            .removeAt(index + 1);
      }
    }
  }

  Future switchMainAddress(String id) async {
    addressController.selectedAddressid.value = id;
    final address = userController.detailUser.value!.customerAddressList!
        .singleWhere((element) => element.id == id);
    var map = {
      "customerAddressId": address.id,
      "cityId": address.cityId,
      "districtId": address.districtId,
      "wardId": address.wardId,
      "homeAddress": address.homeAddress,
      "isMainAddress": true
    };
    try {
      final dio = appController.dio;
      final api = dotenv.env['API_URL']!;
      var response = await dio.put(
        '${api}CustomerAddress',
        data: map,
        options: userController.options,
      );
      if (response.statusCode == 200) {
        userController.refeshUser();
      }
    } catch (e) {
      Get.log(e.toString());
    }
  }

  Future addAddress(bool isForCreateUser) async {
    var address = {
      "customerId": isForCreateUser ? '' : userController.user.value!.id,
      "cityId": selectedCityId.value,
      "districtId": selectedDistrictId.value,
      "wardId": selectedWardId.value,
      "homeAddress": addressTextCtl.text,
      "isMainAddress": false
    };

    var addAddress = {
      'cityId': selectedCityId.value,
      'cityName': listCityMap.firstWhere(
          (element) => element['id'] == selectedCityId.value)['cityName'],
      'districtId': selectedDistrictId.value,
      'districtName': listDistrictMap.firstWhere((element) =>
          element['id'] == selectedDistrictId.value)['districtName'],
      'wardId': selectedWardId.value,
      'wardName': listWardMap.firstWhere(
          (element) => element['id'] == selectedWardId.value)['wardName'],
      'homeAddress': addressTextCtl.text,
    };

    if (isForCreateUser) {
      selectedCityId.value = '79';
      selectedDistrictId.value = '';
      selectedWardId.value = '';
      addressTextCtl.clear();
      searchCityCtrl.clear();
      searchDistrictCtrl.clear();
      searchWardCtrl.clear();
      Get.back(result: addAddress);
    } else {
      AddressService().addAddress(address).then((value) {
        Get.back();
        selectedCityId.value = '79';
        selectedDistrictId.value = '';
        selectedWardId.value = '';
        addressTextCtl.clear();
        searchCityCtrl.clear();
        searchDistrictCtrl.clear();
        searchWardCtrl.clear();
        showSnack(
          'Thành công',
          "Thêm địa chỉ thành công",
          SnackType.success,
        );
      });
    }
  }

  String removeSpecialCharacters(String text) {
    // define the regular expression pattern to match special characters
    RegExp exp = RegExp(r'[^\w\s]');

    // remove all special characters and return the result
    return text.replaceAll(exp, '');
  }

  bool searchCity(DropdownMenuItem itm, String txt) {
    final item =
        listCityMap.firstWhere((element) => element['id'] == itm.value);
    String normalizedQuery = removeSpecialCharacters(txt.toLowerCase());
    return removeSpecialCharacters(item['cityName'].toString().toLowerCase())
        .contains(normalizedQuery);
  }

  bool searchWard(DropdownMenuItem itm, String txt) {
    final item =
        listWardMap.firstWhere((element) => element['id'] == itm.value);
    String normalizedQuery = removeSpecialCharacters(txt.toLowerCase());
    return removeSpecialCharacters(item['wardName'].toString().toLowerCase())
        .contains(normalizedQuery);
  }

  bool searchDistrict(DropdownMenuItem itm, String txt) {
    final item =
        listDistrictMap.firstWhere((element) => element['id'] == itm.value);

    String normalizedQuery = removeSpecialCharacters(txt.toLowerCase());
    return removeSpecialCharacters(
            item['districtName'].toString().toLowerCase())
        .contains(normalizedQuery);
  }

  Future getListCity() async {
    final res = await AddressService().getCity();
    listCityItems.clear();
    listCityMap.clear();
    searchCityCtrl.text = '';
    try {
      for (var e in res.data as List<dynamic>) {
        listCityMap.add(e);
        listCityItems.add(DropdownMenuItem(
          value: e['id'],
          child: Text(e['cityName']),
        ));
      }
    } on Exception catch (e) {
      Get.log("City Error: $e");
    }
    isCityLoaded.value = true;
    selectedCityId.value = "79";
  }

  Future getListDistrict(String cityId) async {
    isDistrictLoaded.value = false;
    selectedDistrictId.value = '';
    searchDistrictCtrl.text = '';
    final res = await AddressService().getDistrict(cityId);
    listDistrictItem.clear();
    listDistrictMap.clear();
    try {
      for (var e in res.data as List<dynamic>) {
        listDistrictMap.add(e);
        listDistrictItem.add(DropdownMenuItem(
          value: e['id'],
          child: Text(e['districtName']),
        ));
      }
    } on Exception catch (e) {
      Get.log("District Error: $e");
    }
    // selectedCityId.value = ((res.data) as List<dynamic>)[0]['id'];
    isDistrictLoaded.value = true;
  }

  Future getListWard(String wardId) async {
    isWardLoaded.value = false;
    selectedWardId.value = '';
    searchWardCtrl.text = '';
    final res = await AddressService().getWard(wardId);
    listWardItem.clear();
    listWardMap.clear();
    try {
      for (var e in res.data as List<dynamic>) {
        listWardMap.add(e);
        listWardItem.add(DropdownMenuItem(
          value: e['id'],
          child: Text(e['wardName']),
        ));
      }
    } catch (e) {
      Get.log("Ward Error: $e");
    }
    isWardLoaded.value = true;
  }

  void changeCity(dynamic id) {
    selectedCityId.value = id;
  }

  void changeDistrict(dynamic id) {
    selectedDistrictId.value = id;
  }

  void changeWard(dynamic id) {
    selectedWardId.value = id;
  }
}
