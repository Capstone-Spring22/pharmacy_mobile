import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/controllers/cart_controller.dart';
import 'package:pharmacy_mobile/helpers/loading.dart';
import 'package:pharmacy_mobile/main.dart';
import 'package:pharmacy_mobile/views/drawer/cart_drawer.dart';
import 'package:pharmacy_mobile/views/drawer/menu_drawer.dart';
import 'package:pharmacy_mobile/views/order_detail/models/order_history_detail.dart';
import 'package:pharmacy_mobile/services/order_service.dart';
import 'package:pharmacy_mobile/widgets/appbar.dart';
import 'package:pharmacy_mobile/widgets/back_button.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';

class OrderDetail extends StatelessWidget {
  const OrderDetail({super.key});

  _contentInfo({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Container(
        width: Get.width,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoSizeText(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: AutoSizeText(
                  content,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final id = Get.arguments;
    return Scaffold(
      drawer: const MenuDrawer(),
      endDrawer: const CartDrawer(),
      appBar: PharmacyAppBar(
        leftWidget: const PharmacyBackButton(),
        midText: "Chi tiết đơn hàng",
        rightWidget: NeumorphicButton(
          style: NeumorphicStyle(
            boxShape: const NeumorphicBoxShape.circle(),
            color: context.theme.canvasColor,
            shape: NeumorphicShape.flat,
          ),
          onPressed: () {},
          child: const Icon(
            Icons.shopping_bag_outlined,
          ),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: OrderService().getOrderHistoryDetail(id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: LoadingWidget(
                  size: 60,
                ),
              );
            } else {
              final item = OrderHistoryDetail.fromJson(snapshot.data);
              DateTime apiDate = DateTime.parse(item.createdDate!);
              String formattedTime = DateFormat.jm().format(apiDate);
              final listGrouped = item.orderProducts!.groupProductsByName();
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: SizedBox(
                        height: Get.height * .1,
                        width: double.infinity,
                        child: SfBarcodeGenerator(
                          value: id,
                          showValue: true,
                        ),
                      ),
                    ),
                    _contentInfo(
                      title: 'Ngày đặt',
                      content:
                          "${item.createdDate!.convertToDate} - $formattedTime",
                    ),
                    _contentInfo(
                      title: 'Loại đơn hàng',
                      content: item.orderTypeName!,
                    ),
                    _contentInfo(
                      title: 'Trạng thái',
                      content: item.orderStatusName!,
                    ),
                    _contentInfo(
                      title: 'Phương thức thanh toán:',
                      content: item.paymentMethod!,
                    ),
                    _contentInfo(
                      title: 'Trạng thái thanh toán',
                      content:
                          item.isPaid! ? "Đã thanh toán" : "Chưa thanh toán",
                    ),
                    if (item.orderDelivery != null)
                      _contentInfo(
                        title: 'Địa chỉ nhận hàng',
                        content: item.orderDelivery!.fullyAddress!,
                      ),
                    if (item.orderPickUp != null)
                      _contentInfo(
                        title: 'Địa chỉ nhận hàng',
                        content:
                            "${productController.listSite.singleWhere((element) => element.id == item.siteId).fullyAddress}",
                      ),
                    if (item.note!.isNotEmpty)
                      _contentInfo(
                        title: 'Ghi chú',
                        content: item.note!,
                      ),

                    _contentInfo(
                      title: 'Tổng tiền',
                      content: item.totalPrice!.convertCurrentcy(),
                    ),

                    // AutoSizeText(
                    //   "Loại đơn hàng: ${item.orderTypeName!}",
                    //   style: context.textTheme.bodyLarge,
                    //   maxLines: 2,
                    // ),
                    // AutoSizeText(
                    //   "Trạng thái: ${item.orderStatusName!}",
                    //   style: context.textTheme.bodyLarge,
                    //   maxLines: 2,
                    // ),
                    // AutoSizeText(
                    //   "Phương thức thanh toán: ${item.paymentMethod!}",
                    //   style: context.textTheme.bodyLarge,
                    //   maxLines: 2,
                    // ),
                    // AutoSizeText(
                    //   "Trạng thái thanh toán: ${item.isPaid! ? "Đã thanh toán" : "Chưa thanh toán"}",
                    //   style: context.textTheme.bodyLarge,
                    //   maxLines: 2,
                    // ),
                    // if (item.orderDelivery != null)
                    //   AutoSizeText(
                    //     "Địa chỉ nhận hàng: ${item.orderDelivery!.fullyAddress}",
                    //     style: context.textTheme.bodyLarge,
                    //     maxLines: 2,
                    //   ),
                    // if (item.orderPickUp != null)
                    //   AutoSizeText(
                    //     "Địa chỉ nhận hàng: ${productController.listSite.singleWhere((element) => element.id == item.siteId).fullyAddress}",
                    //     style: context.textTheme.bodyLarge,
                    //     maxLines: 2,
                    //   ),
                    // if (item.note!.isNotEmpty)
                    //   AutoSizeText(
                    //     "Ghi chú: ${item.note!}",
                    //     style: context.textTheme.bodyLarge,
                    //     maxLines: 2,
                    //   ),
                    // AutoSizeText(
                    //   "Tổng tiền: ${item.totalPrice!.convertCurrentcy()}",
                    //   style: context.textTheme.bodyLarge,
                    //   maxLines: 2,
                    // ),
                    const SizedBox(height: 16),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Chi tiết đơn hàng",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // ...item.orderProducts!.map(
                    //   (e) => Padding(
                    //     padding: const EdgeInsets.symmetric(vertical: 10),
                    //     child: Container(
                    //       decoration: BoxDecoration(
                    //         border: Border.all(
                    //           color: context.theme.primaryColor,
                    //         ),
                    //         borderRadius: BorderRadius.circular(15),
                    //       ),
                    //       child: Padding(
                    //         padding: const EdgeInsets.symmetric(vertical: 10),
                    //         child: Center(
                    //           child: ListTile(
                    //             onTap: () => Get.toNamed(
                    //               "/product_detail",
                    //               arguments: e.productId,
                    //             ),
                    //             leading: CachedNetworkImage(
                    //               imageUrl: e.imageUrl!,
                    //               height: 150,
                    //               width: 80,
                    //               fit: BoxFit.cover,
                    //             ),
                    //             title: AutoSizeText(
                    //               e.productName!,
                    //               overflow: TextOverflow.ellipsis,
                    //               style: context.textTheme.bodyLarge,
                    //               maxLines: 3,
                    //             ),
                    //             subtitle: Column(
                    //               crossAxisAlignment:
                    //                   CrossAxisAlignment.start,
                    //               children: [
                    //                 AutoSizeText(
                    //                   "Số lượng: ${e.quantity!} ${e.unitName}",
                    //                   style: context.textTheme.bodyMedium,
                    //                   maxLines: 2,
                    //                 ),
                    //                 AutoSizeText(
                    //                   "Tổng tiền: ${e.priceTotal!.convertCurrentcy()}",
                    //                 )
                    //               ],
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: listGrouped.length,
                      itemBuilder: (context, index) {
                        final detailItem = listGrouped[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
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
                                child: Column(
                                  children: [
                                    ListTile(
                                      onTap: () => Get.toNamed(
                                        "/product_detail",
                                        arguments: detailItem
                                            .map((e) => e.productId)
                                            .toList(),
                                      ),
                                      // onTap: () {
                                      //   Get.log(detailItem
                                      //       .map((e) => e.productId)
                                      //       .toList()
                                      //       .toString());
                                      // },
                                      leading: CachedNetworkImage(
                                        imageUrl: detailItem[0].imageUrl!,
                                        height: 150,
                                        width: 80,
                                        fit: BoxFit.cover,
                                      ),
                                      title: AutoSizeText(
                                        detailItem[0].productName!,
                                        overflow: TextOverflow.ellipsis,
                                        style: context.textTheme.bodyLarge,
                                        maxLines: 3,
                                      ),
                                    ),
                                    ...detailItem.map(
                                      (e) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Column(
                                          children: [
                                            const Divider(),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              // crossAxisAlignment:
                                              //     CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: Get.width * .4,
                                                  child: AutoSizeText(
                                                    "Số lượng: ${e.quantity!} ${e.unitName}",
                                                    style: context
                                                        .textTheme.bodyMedium,
                                                    maxLines: 2,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: Get.width * .4,
                                                  child: AutoSizeText(
                                                    "Tổng tiền: ${e.priceTotal!.convertCurrentcy()}",
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    item.pharmacistId != null
                        ? const Text(
                            "Bạn không thể huỷ đơn hàng này vì đã được nhân viên xác nhận",
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          )
                        : Container(),
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: Get.width * .8,
                        child: FilledButton(
                          onPressed: item.pharmacistId != null
                              ? null
                              : () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => Center(
                                      child: Container(
                                        height: Get.height * .2,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        width: Get.width * .8,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                "Huỷ đơn hàng",
                                                style: context
                                                    .textTheme.headlineLarge,
                                              ),
                                              Text(
                                                "Bạn có chắc chắn muốn huỷ đơn hàng này không?",
                                                style:
                                                    context.textTheme.bodyLarge,
                                              ),
                                              SwipeButton.expand(
                                                enabled:
                                                    item.pharmacistId == null,
                                                thumb: const Icon(Icons.delete,
                                                    color: Colors.white),
                                                activeTrackColor:
                                                    Colors.grey.shade300,
                                                activeThumbColor: Colors.red,
                                                child:
                                                    const Text("Hủy đơn hàng"),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                          style: ButtonStyle(
                            backgroundColor: item.pharmacistId != null
                                ? MaterialStateProperty.all(
                                    Colors.grey,
                                  )
                                : MaterialStateProperty.all(
                                    Colors.red,
                                  ),
                          ),
                          child: const Text('Huỷ đơn hàng'),
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
