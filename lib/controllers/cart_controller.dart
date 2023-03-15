import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/controllers/user_controller.dart';
import 'package:pharmacy_mobile/models/cart.dart';

class CartController extends GetxController {
  static CartController instance = Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collection = 'carts';

  RxList<CartItem> listCart = <CartItem>[].obs;
  UserController userCtl = Get.find();

  Rx<Map<String, dynamic>> rawItemfromFB =
      Rx<Map<String, dynamic>>(<String, dynamic>{});

  RxString ff = "".obs;

  num getTotal() {
    num total = 0;
    for (var element in listCart) {
      total += element.price;
    }
    return total;
  }

  void addToCart(CartItem item) {
    var f = checkExist(item);
    f ? increaseQuan(item) : listCart.add(item);
    recalcPrice(item.pid);
  }

  void removeCart(CartItem item) => listCart.remove(item);

  void increaseQuan(CartItem item) =>
      updateQuantity(item.pid, itemQuantity(item.pid) + 1);

  void decreaseQuan(CartItem item) {
    if (itemQuantity(item.pid) == 1) {
      Get.defaultDialog(
        middleText: "Remove this item from cart ?",
        onConfirm: () {
          removeCart(item);
          syncCartToFirebase();
          Get.back();
        },
        onCancel: () {},
      );
    } else {
      updateQuantity(item.pid, itemQuantity(item.pid) - 1);
    }
  }

  num itemQuantity(String id) =>
      listCart.firstWhere((element) => element.pid == id).quantity;

  int itemIndex(String id) =>
      listCart.indexWhere((element) => element.pid == id);

  CartItem cartItem({String? id, int? index}) {
    if (id != null) {
      return listCart.firstWhere((element) => element.pid == id);
    } else {
      return listCart[index!];
    }
  }

  bool checkExist(CartItem item) {
    var res = listCart.firstWhereOrNull((element) => element.pid == item.pid);
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

    num price = num.parse(productController
        .getProductById(listCart[index].pid)
        .priceAfterDiscount
        .toString());
    num quan = listCart[index].quantity;
    listCart[index] = item.copyWith(price: price * quan);
    syncCartToFirebase();
  }

  void recalcPriceTotal() {
    for (int i = 0; i < listCart.length; i++) {
      var tempCart = listCart[i];
      var price = tempCart.quantity *
          num.parse(productController
              .getProductById(tempCart.pid)
              .priceAfterDiscount
              .toString());
      listCart[i] = tempCart.copyWith(price: price);
    }
  }

  Map<String, dynamic> listCartToMap() {
    List<Map<String, dynamic>> cartMap = [];
    for (int i = 0; i < listCart.length; i++) {
      cartMap.add({
        "pid": listCart[i].pid,
        "quantity": listCart[i].quantity,
        "image": productController
            .getProductById(listCart[i].pid)
            .imageModel!
            .imageURL,
        "name": productController.getProductById(listCart[i].pid).name,
        "price": productController.getProductById(listCart[i].pid).price,
      });
    }

    Map<String, dynamic> map = {
      'last-update': FieldValue.serverTimestamp(),
      'items': cartMap
    };

    return map;
  }

  //DEMO

  Future<void> syncCartToFirebase() async {
    if (userCtl.isLoggedIn.value) {
      await _db
          .collection(_collection)
          .doc("0${userCtl.user.value.phone}")
          .set(listCartToMap());
    } else {}
  }
}
