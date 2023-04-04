import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_mobile/helpers/loading.dart';
import 'package:pharmacy_mobile/screens/order_history/models/order_history.dart';
import 'package:pharmacy_mobile/services/order_service.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order History"),
        actions: const [],
      ),
      body: Center(
        child: FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingWidget();
            } else if (snapshot.data!.isEmpty) {
              return const Text("You don't have any order history");
            } else {
              final list = snapshot.data as List<OrderHistory>;
              return ListView.builder(
                itemBuilder: (context, index) {
                  final item = list[index];
                  DateTime apiDate = DateTime.parse(item.createdDate!);
                  String formattedDate = DateFormat.yMMMMd().format(apiDate);
                  String formattedTime = DateFormat.jm().format(apiDate);
                  Get.log(item.id!);
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: context.theme.primaryColor,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.id!),
                            Text(
                                "Created Date: $formattedDate - $formattedTime"),
                            Text("Order Type: ${item.orderTypeName!}"),
                            Text(
                              "Payment Status: ${item.isPaid! ? "Paid" : "Unpaid"}",
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                itemCount: list.length,
              );
            }
          },
          future: OrderService().getOrderHistory(),
        ),
      ),
    );
  }
}
