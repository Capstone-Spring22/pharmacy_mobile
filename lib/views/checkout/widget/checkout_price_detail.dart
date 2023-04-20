import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/controllers/checkout_controller.dart';
import 'package:pharmacy_mobile/main.dart';
import 'package:pharmacy_mobile/widgets/input.dart';

class PriceDetail extends GetView<CheckoutController> {
  const PriceDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ExpansionTile(
        initiallyExpanded: true,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            color: Colors.red,
          ),
          child: const Icon(
            Icons.shopify_rounded,
            color: Colors.white,
          ),
        ),
        textColor: Colors.black,
        childrenPadding: EdgeInsets.zero,
        title: SizedBox(
          width: Get.width * .85,
          child: const AutoSizeText('Chi tiết thanh toán'),
        ),
        children: [
          _buildRow(
            'Tổng tiền sản phẩm',
            cartController.calculateTotalNonDiscount().convertCurrentcy(),
          ).animate().slideX(begin: 1, delay: 50.ms),
          Obx(() => Column(
                children: [
                  controller.checkoutType.value == 0
                      ? _buildRow(
                          'Phí vận chuyển',
                          controller.shipping.convertCurrentcy(),
                        ).animate().slideX(begin: 1, delay: 100.ms)
                      : Container(),
                  controller.usePoint.value
                      ? _buildRow(
                          'Tổng giảm giá',
                          controller.reducePrice.value == 0
                              ? 0.convertCurrentcy()
                              : '- ${controller.reducePrice.value.convertCurrentcy()}',
                        ).animate().slideX(begin: 1, delay: 150.ms)
                      : Container(),
                  _buildRow(
                    'Tổng tiền thanh toán',
                    controller.calcTotal(),
                    textStyle: TextStyle(
                      color: context.theme.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  )
                ],
              )),
          Form(
            key: controller.formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Obx(() => ListTile(
                    title: Row(
                      children: [
                        Expanded(
                          child: AutoSizeText(
                            'Dùng điểm (hiện có ${userController.point} điểm)',
                          ),
                        ),
                        CupertinoSwitch(
                          activeColor: context.theme.primaryColor,
                          value: controller.usePoint.value,
                          onChanged: (v) => controller.usePoint.value =
                              !controller.usePoint.value,
                        )
                      ],
                    ),
                    subtitle: controller.usePoint.value
                        ? Input(
                            inputController: controller.pointCtl,
                            horiPadding: 0,
                            inputType: TextInputType.number,
                            title: 'Nhập điểm sử dụng (1 điểm - 1000 đ)',
                            isFormField: true,
                            onChanged: (p0) {
                              controller.debouncer.cancel();
                              controller.debouncer.call(() {
                                if (controller.formKey.currentState!
                                    .validate()) {
                                  controller.calculateUsedPoint();
                                }
                              });
                            },
                            validator: (p0) => p0!.isEmpty
                                ? 'Không được để trống'
                                : p0.isNumericOnly
                                    ? controller.validatePoint()
                                    : 'Điểm nhập không hợp lệ',
                          ).animate().slideX(begin: 1, delay: 50.ms)
                        : Container(),
                  )),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRow(String title, String content, {TextStyle? textStyle}) {
    final style = textStyle ?? TextStyle(color: Colors.grey[800]);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: style,
          ),
          const Spacer(),
          Text(
            content,
            style: style,
          ),
        ],
      ),
    );
  }
}
