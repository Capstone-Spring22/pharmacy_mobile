import 'dart:developer';

import 'package:get/get.dart';
import 'package:pharmacy_mobile/models/cart.dart';

class CartController extends GetxController {
  static CartController instance = Get.find();

  RxList<CartItem> listCart = <CartItem>[].obs;

  void addToCart(CartItem item) {
    var f = checkExist(item);
    f ? increaseQuan(item) : listCart.add(item);
    log(f.toString());
    recalcPrice(item.product.id);
  }

  void removeCart(CartItem item) => listCart.remove(item);

  void increaseQuan(CartItem item) =>
      updateQuantity(item.product.id, itemQuantity(item.product.id) + 1);

  void decreaseQuan(CartItem item) {
    if (itemQuantity(item.product.id) == 1) {
      removeCart(item);
    } else {
      updateQuantity(item.product.id, itemQuantity(item.product.id) - 1);
    }
  }

  num itemQuantity(String id) =>
      listCart.firstWhere((element) => element.product.id == id).quantity;

  int itemIndex(String id) =>
      listCart.indexWhere((element) => element.product.id == id);

  CartItem cartItem({String? id, int? index}) {
    if (id != null) {
      return listCart.firstWhere((element) => element.product.id == id);
    } else {
      return listCart[index!];
    }
  }

  bool checkExist(CartItem item) {
    var res = listCart
        .firstWhereOrNull((element) => element.product.id == item.product.id);
    return res != null;
  }

  void updateQuantity(String id, num newQuantity) {
    int index = itemIndex(id);
    CartItem item = cartItem(index: index);
    listCart[index] = item.copyWith(quantity: newQuantity);
    recalcPrice(id);
  }

  void recalcPrice(String id) {
    int index = itemIndex(id);
    CartItem item = cartItem(index: index);
    num price = listCart[index].product.price;
    num quan = listCart[index].quantity;
    listCart[index] = item.copyWith(price: price * quan);
  }
}
