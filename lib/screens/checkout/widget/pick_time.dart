import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/controllers/checkout_controller.dart';
import 'package:pharmacy_mobile/helpers/loading.dart';
import 'package:pharmacy_mobile/services/product_service.dart';

class PickTime extends StatefulWidget {
  const PickTime({super.key});

  @override
  State<PickTime> createState() => _PickTimeState();
}

class _PickTimeState extends State<PickTime> {
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

    data = await ProductService().pickTime();

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        try {
          int selectTimeIndex = data.indexWhere((element) =>
              element == Get.find<CheckoutController>().selectTime.value);
          if (selectTimeIndex != -1) {
            scrollController.animateTo(
              selectTimeIndex * Get.height * .04,
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
            ? LoadingWidget()
            : (data as List<dynamic>).isNotEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Pick a Time",
                          style: context.textTheme.titleMedium,
                        ),
                      ),
                      Container(
                        height: Get.height * 0.3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: context.theme.primaryColor),
                        ),
                        child: ListView.builder(
                          controller: scrollController,
                          // shrinkWrap: true,
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            CheckoutController checkoutController = Get.find();
                            return ListTile(
                              onTap: () => checkoutController.selectTime.value =
                                  data[index],
                              title: Text(data[index]),
                              trailing: Obx(
                                () => Radio(
                                  value: data[index],
                                  groupValue:
                                      checkoutController.selectTime.value,
                                  onChanged: (value) {
                                    checkoutController.selectTime.value = value;
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
                    child: Text("Pick A Date First"),
                  ),
      ),
    );
  }
}
