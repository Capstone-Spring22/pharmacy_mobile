import 'package:flutter/material.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/helpers/loading.dart';
import 'package:pharmacy_mobile/services/order_service.dart';
import 'package:pharmacy_mobile/views/order_detail/models/order_history_detail.dart';

class CancelReason extends StatefulWidget {
  const CancelReason({super.key, required this.type, required this.item});

  final int type;
  final OrderHistoryDetail item;

  @override
  State<CancelReason> createState() => _CancelReasonState();
}

class _CancelReasonState extends State<CancelReason> {
  String selected = "";
  List<String> reasonsDelivery = [
    'Tìm được ưu đãi tốt hơn ở nơi khác',
    'Giao hàng chậm',
    'Đặt sai sản phẩm',
    'Không cần sản phẩm nữa',
    'Sai địa chỉ giao hàng',
    'Thay đổi ý định',
  ];
  List<String> reasonsPickup = [
    'Tìm được ưu đãi tốt hơn ở nơi khác',
    'Không cần sản phẩm nữa',
    'Không thể đến nơi lấy hàng',
    'Điểm lấy hàng đóng cửa đột ngột',
  ];
  @override
  Widget build(BuildContext context) {
    int length =
        widget.type == 0 ? reasonsDelivery.length : reasonsPickup.length;
    return Material(
      child: Column(
        children: [
          ListView.builder(
            itemCount: length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final reason = widget.type == 0
                  ? reasonsDelivery[index]
                  : reasonsPickup[index];

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selected = reason;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 0),
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: selected == reason
                        ? Colors.blue.shade100
                        : Colors.transparent,
                  ),
                  child: Row(
                    children: [
                      Radio(
                        value: reason,
                        groupValue: selected,
                        onChanged: (v) => setState(() => selected = v!),
                      ),
                      Expanded(
                        child: Text(reason),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SwipeButton.expand(
              onSwipe: () async {
                Get.back();
                Get.dialog(
                  const Center(
                    child: LoadingWidget(),
                  ),
                );
                await OrderService().cancelOrder(widget.item.id!, selected);
                Get.back();
                Get.back();

                // Get.log(selected);
              },
              enabled: widget.item.pharmacistId == null && selected.isNotEmpty,
              thumb: const Icon(Icons.delete, color: Colors.white),
              activeTrackColor: Colors.grey.shade300,
              activeThumbColor: Colors.red,
              child: const Text("Hủy đơn hàng"),
            ),
          ),
        ],
      ),
    );
  }
}
