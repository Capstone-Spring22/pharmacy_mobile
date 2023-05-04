// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/controllers/user_controller.dart';
import 'package:pharmacy_mobile/helpers/snack.dart';
import 'package:pharmacy_mobile/models/cart.dart';
import 'package:pharmacy_mobile/services/cart_service.dart';
import 'package:pharmacy_mobile/views/order_detail/models/order_history_detail.dart';

extension groupCartItems on List<CartItem> {
  List<List<CartItem>> groupProductsByName() {
    List<List<CartItem>> groupedProducts = [];
    String currentName = '';

    var tempList = cartController.listCart.value;

    try {
      tempList.sort((a, b) => a.productName!.compareTo(b.productName!));
    } catch (e) {}

    try {
      for (var cartItem in tempList) {
        if (cartItem.productName != currentName) {
          currentName = cartItem.productName!;
          groupedProducts.add([cartItem]);
        } else {
          groupedProducts.last.add(cartItem);
        }
      }
    } catch (e) {}

    return groupedProducts;
  }
}

extension groupDetailList on List<OrderProducts> {
  List<List<OrderProducts>> groupProductsByName() {
    List<List<OrderProducts>> groupedProducts = [];
    String currentName = '';

    var tempList = this;

    try {
      tempList.sort((a, b) => a.productName!.compareTo(b.productName!));
    } catch (e) {}

    try {
      for (var item in tempList) {
        if (item.productName != currentName) {
          currentName = item.productName!;
          groupedProducts.add([item]);
        } else {
          groupedProducts.last.add(item);
        }
      }
    } catch (e) {}

    return groupedProducts;
  }
}

class CartController extends GetxController {
  static CartController instance = Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collection = 'carts';

  RxList<CartItem> listCart = <CartItem>[].obs;

  UserController userCtl = Get.find();

  String? docId;

  Rx<Map<String, dynamic>> rawItemfromFB =
      Rx<Map<String, dynamic>>(<String, dynamic>{});

  RxString ff = "".obs;

  final debouncer = Debouncer(delay: 300.milliseconds);

  @override
  void onInit() {
    ever(userController.isLoggedIn, connectToCloudCart);

    super.onInit();
  }

  Future connectToCloudCart(bool isLogged) async {
    if (isLogged) {
      docId = await CartService().getCartId();
      if (docId != null) {
        Get.log('connectToCloudCart: $docId');
        // listCart.clear();
        listCart.bindStream(firebaseStreamCart(docId!));
      } else if (docId == "useUserId") {
        // listCart.clear();
        // while (userController.user.value.id == null) {
        //   await Future.delayed(const Duration(milliseconds: 500));
        // }
        // listCart.bindStream(
        //     firebaseStreamCartUseWhere(userController.user.value.id!));
      }
    }
  }

  Stream<List<CartItem>> firebaseStreamCart(String docId) async* {
    // Subscribe to the Firestore document snapshots
    var snapshots = _db.collection(_collection).doc(docId).snapshots();

    // Wait for the first snapshot to be available
    var initialSnapshot = await snapshots.first;

    // Emit the initial list of cart items
    yield await CartService().getListCartItem();

    // Subscribe to future snapshot updates
    await for (var snapshot in snapshots.skip(1)) {
      // Emit the updated list of cart items
      yield await CartService().getListCartItem();
    }
  }
  //////////////////////////////////////////////////

  void addToCart(CartItem item) {
    var addMap = createMap(item, 1);
    addProductToMockLocal(item);
    CartService().postCart(addMap);
  }

  void updateQuantityToMockLocal(String id, num quantity) {
    int index = listCart.indexWhere((element) => element.productId == id);
    if (index != -1) {
      listCart[index].quantity = quantity;
      listCart.refresh();
    }
  }

  void addProductToMockLocal(CartItem item) {
    listCart.add(item);
  }

  void increaseQuan(String productId) {
    var cartItem = getCartItem(productId);
    num quan = cartItem.quantity! + 1;
    updateQuantityToMockLocal(productId, quan);
    var addMap = createMap(cartItem, quan);
    debouncer.cancel();
    debouncer.call(() => CartService().postCart(addMap));
    // CartService().postCart(addMap);
  }

  void removeFromMockLocal(String productId) {
    cartController.listCart
        .removeWhere((element) => element.productId == productId);
  }

  void decreaseQuan(String productId) {
    debouncer.cancel();
    var cartItem = getCartItem(productId);
    var quan = cartItem.quantity!;
    if (quan > 1) {
      num quanLocal = quan - 1;
      updateQuantityToMockLocal(productId, quanLocal);
      var addMap = createMap(cartItem, quanLocal);
      debouncer.call(() => CartService().postCart(addMap));
      // CartService().postCart(addMap);
    } else {
      showSnack(
        'Thông báo',
        'Đã xoá 1 sản phẩm khỏi giỏ hàng',
        SnackType.success,
      );
      removeFromMockLocal(productId);
      CartService().removeCart(productId, docId!);
    }
  }

  void customQuan(String productId, num quan) {
    if (quan >= 1) {
      var cartItem = getCartItem(productId);
      updateQuantityToMockLocal(productId, quan);
      var addMap = createMap(cartItem, quan);
      CartService().postCart(addMap);
    } else {
      Get.snackbar("Error", "Invalid Amount");
    }
  }

  Map<String, dynamic> createMap(CartItem cartItem, num quantity) {
    return {
      "deviceId": appController.androidInfo!.id,
      "item": {
        "productId": cartItem.productId,
        "quantity": quantity,
      }
    };
  }

  CartItem getCartItem(String productId) {
    return listCart.singleWhere((element) => element.productId == productId);
  }

  num calculateTotal() {
    double total = 0.0;
    for (var item in listCart) {
      total += item.priceTotal!;
    }
    return total;
  }

  double calculateTotalNonDiscount() {
    double total = 0.0;
    for (var item in listCart) {
      total += item.priceAfterDiscount! * item.quantity!;
    }
    return total;
  }
}
