// ignore_for_file: prefer_typing_uninitialized_variables, empty_catches

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/controllers/checkout_controller.dart';
import 'package:pharmacy_mobile/helpers/loading.dart';
import 'package:pharmacy_mobile/services/product_service.dart';

class PickDate extends StatefulWidget {
  const PickDate({super.key});

  @override
  State<PickDate> createState() => _PickDateState();
}

class _PickDateState extends State<PickDate> {
  bool _isLoading = false;
  final ScrollController scrollController = ScrollController();
  var data;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    setState(() {
      _isLoading = true;
    });

    data = await ProductService().pickDate();

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        try {
          int selectedDateIndex = data.indexWhere((element) =>
              element['dateTime'] ==
              Get.find<CheckoutController>().selectDate.value);
          if (selectedDateIndex != -1) {
            scrollController.animateTo(
              selectedDateIndex * Get.height * .04,
              curve: Curves.easeOut,
              duration: const Duration(milliseconds: 300),
            );
          }
        } catch (e) {}
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25),
        child: _isLoading
            ? const LoadingWidget()
            : (data as List<dynamic>).isNotEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Chọn ngày nhận",
                            style: context.textTheme.titleMedium,
                          ),
                        ),
                      ),
                      Container(
                        height: Get.height * 0.3,
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
                          controller: scrollController,
                          // shrinkWrap: true,
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            CheckoutController checkoutController = Get.find();
                            return ListTile(
                              onTap: () => checkoutController.selectDate.value =
                                  data[index]['dateTime'],
                              title: Text(data[index]['dayofWeekAndDate']),
                              trailing: Obx(
                                () => Radio(
                                  value: data[index]['dateTime'],
                                  groupValue:
                                      checkoutController.selectDate.value,
                                  onChanged: (value) {
                                    checkoutController.selectDate.value = value;
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  )
                : const Center(
                    child: Text("Không có ngày phù hợp"),
                  ),
      ),
    );
  }
}
