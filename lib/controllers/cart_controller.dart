import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/controllers/user_controller.dart';
import 'package:pharmacy_mobile/models/cart.dart';
import 'package:pharmacy_mobile/models/product.dart';

class CartController extends GetxController {
  static CartController instance = Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collection = 'carts';

  RxList<CartItem> listCart = <CartItem>[].obs;
  UserController userCtl = Get.find();

  Rx<Map<String, dynamic>> rawItemfromFB =
      Rx<Map<String, dynamic>>(<String, dynamic>{});

  RxString ff = "".obs;

  @override
  void onInit() {
    super.onInit();
    everAll([userCtl.isLoggedIn, userCtl.user], (value) {
      if (value && FirebaseAuth.instance.currentUser != null) {
        FirebaseAuth.instance.currentUser!.reload();
        listCart.bindStream(_db
            .collection(_collection)
            // .doc("0${userCtl.user.value.phone}")
            .doc(
                "0${e164ToReadable(FirebaseAuth.instance.currentUser!.phoneNumber!)}")
            .snapshots()
            .map((event) {
          // print("data from fb syned ${event.data()}");
          if (event.data() == null) {
            return [];
          }
          var data = event.data()!['items'] as List;
          List<CartItem> tempList = [];
          for (var item in data) {
            var pro =
                listProducts.firstWhere((element) => element.id == item["pid"]);
            tempList.add(CartItem(
                product: pro,
                quantity: item['quantity'],
                price: pro.price * item['quantity']));
          }
          return tempList;
        }));
      } else {}
    }).printError();
  }

  void addToCart(CartItem item) {
    var f = checkExist(item);
    f ? increaseQuan(item) : listCart.add(item);
    recalcPrice(item.product.id);
  }

  void removeCart(CartItem item) => listCart.remove(item);

  void increaseQuan(CartItem item) =>
      updateQuantity(item.product.id, itemQuantity(item.product.id) + 1);

  void decreaseQuan(CartItem item) {
    if (itemQuantity(item.product.id) == 1) {
      removeCart(item);
      syncCartToFirebase();
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
    syncCartToFirebase();
  }

  void recalcPriceTotal() {
    for (int i = 0; i < listCart.length; i++) {
      var tempCart = listCart[i];
      var price = tempCart.quantity * tempCart.product.price;
      listCart[i] = tempCart.copyWith(price: price);
    }
  }

  Map<String, dynamic> listCartToMap() {
    List<Map<String, dynamic>> cartMap = [];
    for (int i = 0; i < listCart.length; i++) {
      cartMap.add({
        "pid": listCart[i].product.id,
        "quantity": listCart[i].quantity,
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
    // var exists = await checkExist(item);
    // if (exists) {
    //   await increaseQuan(item);
    // } else {
    //   await _db.collection(_collection).add(item.toJson());
    // }
    // await recalcPrice(item.product.id);

    if (userCtl.isLoggedIn.value) {
      await _db
          .collection(_collection)
          .doc("0${userCtl.user.value.phone}")
          .set(listCartToMap());
    } else {}
  }
}
