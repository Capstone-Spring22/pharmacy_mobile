import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/widgets/input.dart';

class AddressSelectionScreen extends StatefulWidget {
  const AddressSelectionScreen({super.key});

  @override
  State<AddressSelectionScreen> createState() => _AddressSelectionScreenState();
}

class _AddressSelectionScreenState extends State<AddressSelectionScreen> {
  String cityValue = '01';

  @override
  Widget build(BuildContext context) {
    AddressController addressController = Get.find();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Address"),
      ),
      body: Center(
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
            })
          ],
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
      iconEnabledColor: Colors.yellow,
      iconDisabledColor: Colors.grey,
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
}

class AddressController extends GetxController {
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

  @override
  void onInit() {
    super.onInit();
    getListCity();
    ever(selectedCityId, getListDistrict);
  }

  bool searchCity(DropdownMenuItem itm, String txt) {
    final item =
        listCityMap.firstWhere((element) => element['id'] == itm.value);
    return item['cityName'].toString().toLowerCase().contains(txt);
  }

  bool searchDistrict(DropdownMenuItem itm, String txt) {
    final item =
        listDistrictMap.firstWhere((element) => element['id'] == itm.value);
    return item['districtName'].toString().toLowerCase().contains(txt);
  }

  Future getListCity() async {
    final res = await AddressService().getCity();
    listCityItems.clear();
    listCityMap.clear();
    searchCityCtrl.text = '';
    for (var e in res.body as List<dynamic>) {
      listCityMap.add(e);
      listCityItems.add(DropdownMenuItem(
        value: e['id'],
        child: Text(e['cityName']),
      ));
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
    for (var e in res.body as List<dynamic>) {
      log("${e['districtName']} added");
      listDistrictMap.add(e);
      listDistrictItem.add(DropdownMenuItem(
        value: e['id'],
        child: Text(e['districtName']),
      ));
    }
    // selectedCityId.value = ((res.body) as List<dynamic>)[0]['id'];
    isDistrictLoaded.value = true;
  }

  void changeCity(dynamic id) {
    selectedCityId.value = id;
  }

  void changeDistrict(dynamic id) {
    selectedDistrictId.value = id;
  }
}
