import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/helpers/loading.dart';
import 'package:pharmacy_mobile/screens/order_detail/models/order_history_detail.dart';
import 'package:pharmacy_mobile/services/order_service.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';

class OrderDetail extends StatelessWidget {
  const OrderDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final id = Get.arguments;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Detail"),
      ),
      body: FutureBuilder(
        future: OrderService().getOrderHistoryDetail(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingWidget(
                size: 60,
              ),
            );
          } else {
            final item = OrderHistoryDetail.fromJson(snapshot.data);
            DateTime apiDate = DateTime.parse(item.createdDate!);
            String formattedDate = DateFormat.yMMMMd().format(apiDate);
            String formattedTime = DateFormat.jm().format(apiDate);
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: Get.height * .1,
                      width: double.infinity,
                      child: SfBarcodeGenerator(
                        value: id,
                        showValue: true,
                      ),
                    ),
                    AutoSizeText(
                      "Ngày đặt: $formattedDate - $formattedTime",
                      style: context.textTheme.bodyMedium,
                      maxLines: 1,
                    ),
                    AutoSizeText(
                      "Loại đơn hàng: ${item.orderTypeName!}",
                      style: context.textTheme.bodyMedium,
                      maxLines: 1,
                    ),
                    AutoSizeText(
                      "Trạng thái: ${item.orderStatusName!}",
                      style: context.textTheme.bodyMedium,
                      maxLines: 1,
                    ),
                    AutoSizeText(
                      "Phương thức thanh toán: ${item.paymentMethod!}",
                      style: context.textTheme.bodyMedium,
                      maxLines: 1,
                    ),
                    AutoSizeText(
                      "Trạng thái thanh toán: ${item.isPaid! ? "Đã thanh toán" : "Chưa thanh toán"}",
                      style: context.textTheme.bodyMedium,
                      maxLines: 1,
                    ),
                    AutoSizeText(
                      "Tổng tiền: ${convertCurrency(item.totalPrice!)}",
                      style: context.textTheme.bodyMedium,
                      maxLines: 1,
                    ),
                    if (item.orderDelivery != null)
                      AutoSizeText(
                        "Địa chỉ nhận hàng: ${item.orderDelivery!.homeNumber}",
                        style: context.textTheme.bodyMedium,
                        maxLines: 2,
                      ),
                    if (item.orderPickUp != null)
                      AutoSizeText(
                        "Địa chỉ cửa hàng: ${item.orderPickUp!.datePickUp}",
                        style: context.textTheme.bodyMedium,
                        maxLines: 2,
                      ),
                    if (item.note!.isNotEmpty)
                      AutoSizeText(
                        "Ghi chú: ${item.note!}",
                        style: context.textTheme.bodyMedium,
                        maxLines: 1,
                      ),
                    const Text(
                      "Chi tiết đơn hàng",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ...item.orderProducts!.map(
                      (e) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: context.theme.primaryColor,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Center(
                              child: ListTile(
                                onTap: () => Get.toNamed(
                                  "/product_detail",
                                  arguments: e.productId,
                                ),
                                leading: CachedNetworkImage(
                                  imageUrl: e.imageUrl!,
                                  height: 150,
                                  width: 80,
                                  fit: BoxFit.cover,
                                ),
                                title: AutoSizeText(
                                  e.productName!,
                                  overflow: TextOverflow.ellipsis,
                                  style: context.textTheme.bodyMedium,
                                  maxLines: 2,
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AutoSizeText(
                                      "Số lượng: ${e.quantity!} ${e.unitName}",
                                      style: context.textTheme.bodyMedium,
                                      maxLines: 1,
                                    ),
                                    AutoSizeText(
                                      "Tổng tiền: ${convertCurrency(e.priceTotal!)}",
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
