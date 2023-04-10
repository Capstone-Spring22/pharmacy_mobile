import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/helpers/loading.dart';
import 'package:pharmacy_mobile/main.dart';
import 'package:pharmacy_mobile/views/drawer/cart_drawer.dart';
import 'package:pharmacy_mobile/views/drawer/menu_drawer.dart';
import 'package:pharmacy_mobile/views/home/widgets/cart_btn.dart';
import 'package:pharmacy_mobile/views/order_detail/models/order_history_detail.dart';
import 'package:pharmacy_mobile/views/order_history/models/order_history.dart';
import 'package:pharmacy_mobile/services/order_service.dart';
import 'package:pharmacy_mobile/widgets/appbar.dart';
import 'package:pharmacy_mobile/widgets/back_button.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final _scrollController = ScrollController();
  bool isLoading = false;
  List<OrderHistory> list = [];
  int index = 1;

  @override
  void initState() {
    _loadItems();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMoreItems();
      }
    });
    super.initState();
  }

  Future _loadItems() async {
    setState(() {
      isLoading = true;
    });

    final firstPage = await OrderService().getOrderHistory(1);
    setState(() {
      list.addAll(firstPage);
      isLoading = false;
    });
  }

  void _loadMoreItems() async {
    setState(() {
      isLoading = true;
    });
    index++;
    final nextPage = await OrderService().getOrderHistory(index);
    setState(() {
      list.addAll(nextPage);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MenuDrawer(),
      endDrawer: const CartDrawer(),
      appBar: PharmacyAppBar(
        leftWidget: const PharmacyBackButton(),
        midText: "Đơn hàng",
        rightWidget: const CartButton(),
      ),
      body: Center(
          child: Column(
        children: [
          list.isEmpty && !isLoading
              ? const Text("Bạn chưa có đơn hàng nào")
              : Expanded(
                  child: RenderList(
                      scrollController: _scrollController, list: list)),
          if (isLoading) LoadingWidget(),
        ],
      )),
    );
  }
}

class RenderList extends StatelessWidget {
  const RenderList({
    super.key,
    required ScrollController scrollController,
    required this.list,
  }) : _scrollController = scrollController;

  final ScrollController _scrollController;
  final List<OrderHistory> list;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemBuilder: (context, index) {
        final item = list[index];
        DateTime apiDate = DateTime.parse(item.createdDate!);
        String formattedDate = item.createdDate!.convertToDate;
        String formattedTime = DateFormat.jm().format(apiDate);
        var onGoingGradient = Gradients.coldLinear;
        var finishGradient = Gradients.coralCandyGradient;
        return GestureDetector(
          onTap: () => Get.toNamed('/order_detail', arguments: item.id),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
            child: Container(
              decoration: BoxDecoration(
                gradient:
                    item.orderStatus == "4" ? finishGradient : onGoingGradient,
                boxShadow: [
                  BoxShadow(
                    color: item.orderStatus == "4"
                        ? finishGradient.colors.first.withOpacity(0.25)
                        : onGoingGradient.colors.first.withOpacity(0.25),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(3, 0),
                  ),
                  BoxShadow(
                    color: item.orderStatus == "4"
                        ? finishGradient.colors.first.withOpacity(0.25)
                        : onGoingGradient.colors.first.withOpacity(0.25),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
                borderRadius: BorderRadius.circular(25),
              ),
              height: Get.height * .23,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  height: Get.height * .23,
                  width: double.infinity,
                  child: FutureBuilder(
                    future: OrderService().getOrderHistoryDetail(item.id!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return LoadingWidget();
                      } else {
                        final detail =
                            OrderHistoryDetail.fromJson(snapshot.data);
                        if (detail.orderPickUp != null) {
                          for (var element in productController.listSite) {
                            Get.log(element.id.toString());
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              AutoSizeText(
                                "Loại đơn: ${item.orderTypeName}",
                                style: context.textTheme.bodyMedium,
                                maxLines: 1,
                              ),
                              AutoSizeText(
                                "Ngày đặt: $formattedDate - $formattedTime",
                                style: context.textTheme.bodyMedium,
                                maxLines: 1,
                              ),
                              AutoSizeText(
                                'Tổng tiền ${item.totalPrice!.convertCurrentcy()}',
                              ),
                              AutoSizeText(item.paymentMethod!),
                              Text(
                                  "Địa chỉ cửa hàng: ${productController.listSite.singleWhere((element) => element.id == detail.siteId).fullyAddress}"),
                              Text(
                                "Giờ hẹn lấy hàng: ${detail.orderPickUp!.datePickUp} - ${detail.orderPickUp!.timePickUp}",
                              ),
                            ],
                          );
                        } else {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              AutoSizeText(
                                "Loại đơn: ${item.orderTypeName}",
                                style: context.textTheme.bodyMedium,
                                maxLines: 1,
                              ),
                              AutoSizeText(
                                "Ngày đặt: $formattedDate - $formattedTime",
                                style: context.textTheme.bodyMedium,
                                maxLines: 1,
                              ),
                              AutoSizeText(
                                'Tổng tiền ${item.totalPrice!.convertCurrentcy()}',
                              ),
                              AutoSizeText(item.paymentMethod!),
                              const Text("Địa chỉ đặt hàng:"),
                              AutoSizeText(
                                "${detail.orderDelivery!.fullyAddress}",
                                maxLines: 2,
                              ),
                            ],
                          );
                        }
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
      itemCount: list.length,
    );
  }
}
