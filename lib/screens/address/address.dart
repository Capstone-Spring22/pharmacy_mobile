import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/screens/checkout/checkout.dart';
import 'package:pharmacy_mobile/widgets/input.dart';

class AddressSelectionScreen extends StatefulWidget {
  const AddressSelectionScreen({super.key});

  @override
  State<AddressSelectionScreen> createState() => _AddressSelectionScreenState();
}

class _AddressSelectionScreenState extends State<AddressSelectionScreen> {
  @override
  void dispose() {
    Get.delete<AddressController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AddressController addressController = Get.find();
    CheckoutController checkoutController = Get.find();
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: Get.height * .45,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Obx(
                () => addressController.isCityLoaded.value
                    ? dropdownBox(
                        hint: "Select a City",
                        items: addressController.listCityItems,
                        value: addressController.selectedCityId.value.isNotEmpty
                            ? addressController.selectedCityId.value
                            : null,
                        searchController: addressController.searchCityCtrl,
                        searchInnerWidget: Input(
                          inputController: addressController.searchCityCtrl,
                        ),
                        onChanged: addressController.changeCity,
                        searchMatchFn: addressController.searchCity,
                      )
                    : const CircularProgressIndicator.adaptive(),
              ),
              Obx(() {
                if (addressController.selectedCityId.isEmpty) {
                  return Container();
                } else if (addressController.isDistrictLoaded.value) {
                  return dropdownBox(
                    hint: "Select a District",
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
                    hint: "Select a Ward",
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
                  return Input(
                    inputController: addressController.addressTextCtl,
                    inputType: TextInputType.streetAddress,
                    title: "Address",
                    onChanged: (v) {
                      checkoutController.address.text =
                          "$v ${addressController.addressTile}";
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  DropdownButton2<dynamic> dropdownBox(
      {List<DropdownMenuItem<dynamic>>? items,
      dynamic value,
      TextEditingController? searchController,
      Widget? searchInnerWidget,
      bool Function(DropdownMenuItem<dynamic>, String)? searchMatchFn,
      void Function(dynamic)? onChanged,
      required String hint}) {
    return DropdownButton2(
      isExpanded: true,
      items: items,
      value: value,
      hint: Text(hint),
      searchController: searchController,
      searchInnerWidget: searchInnerWidget,
      searchInnerWidgetHeight: 100,
      searchMatchFn: searchMatchFn,
      onChanged: onChanged,
      iconSize: 14,
      buttonHeight: 50,
      buttonWidth: Get.width * .75,
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

class AddressService extends GetConnect {
  String apiUrl = dotenv.env['API_URL']!;

  Future<Response> getCity() => get('${apiUrl}Address/City');
  Future<Response> getDistrict(String cityId) =>
      get('${apiUrl}Address/$cityId/District');
  Future<Response> getWard(String wardId) =>
      get('${apiUrl}Address/$wardId/Ward');
}

class AddressController extends GetxController {
  CheckoutController checkoutController = Get.find();

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
  String addressTile = "";

  @override
  void onInit() {
    super.onInit();
    getListCity();
    ever(selectedCityId, getListDistrict);
    ever(selectedDistrictId, getListWard);
    everAll(
        [selectedCityId, selectedDistrictId, selectedWardId],
        (callback) => setAddressCtrl(
              selectedCityId.value,
              selectedDistrictId.value,
              selectedWardId.value,
            ));
  }

  void setAddressCtrl(String? cityId, String? districtId, String? wardId) {
    String ward = '';
    String district = '';
    String city = '';

    try {
      city = listCityMap
          .firstWhere((element) => element['id'] == cityId)['cityName'];
      district = listDistrictMap.firstWhere(
              (element) => element['id'] == districtId)['districtName'] +
          ',';
      ward = listWardMap
              .firstWhere((element) => element['id'] == wardId)['wardName'] +
          ',';
    } catch (e) {
      Get.log(e.toString());
    }

    addressTile = "$ward $district $city";

    checkoutController.address.text = addressTile;
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
      for (var e in res.body as List<dynamic>) {
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
  }

  Future getListDistrict(String cityId) async {
    isDistrictLoaded.value = false;
    selectedDistrictId.value = '';
    searchDistrictCtrl.text = '';
    final res = await AddressService().getDistrict(cityId);
    listDistrictItem.clear();
    listDistrictMap.clear();
    try {
      for (var e in res.body as List<dynamic>) {
        log("${e['districtName']} added");
        listDistrictMap.add(e);
        listDistrictItem.add(DropdownMenuItem(
          value: e['id'],
          child: Text(e['districtName']),
        ));
      }
    } on Exception catch (e) {
      Get.log("District Error: $e");
    }
    // selectedCityId.value = ((res.body) as List<dynamic>)[0]['id'];
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
      for (var e in res.body as List<dynamic>) {
        log("${e['wardName']} added");
        listWardMap.add(e);
        listWardItem.add(DropdownMenuItem(
          value: e['id'],
          child: Text(e['wardName']),
        ));
      }
    } on Exception catch (e) {
      Get.log("Ward Error: $e");
    }
    // selectedCityId.value = ((res.body) as List<dynamic>)[0]['id'];
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
