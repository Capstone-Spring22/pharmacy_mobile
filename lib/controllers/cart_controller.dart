import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/controllers/user_controller.dart';
import 'package:pharmacy_mobile/models/cart.dart';
import 'package:pharmacy_mobile/services/cart_service.dart';

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

  @override
  void onInit() {
    ever(userController.isLoggedIn, connectToCloudCart);

    super.onInit();
  }

  Future connectToCloudCart(bool isLogged) async {
    if (isLogged) {
      docId = await CartService().getCartId();
      if (docId != null) {
        listCart.clear();
        listCart.bindStream(firebaseStreamCart(docId!));
      } else {
        Get.log('Empty');
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
    CartService().postCart(addMap);
  }

  void increaseQuan(String productId) {
    var cartItem = getCartItem(productId);
    var addMap = createMap(cartItem, cartItem.quantity! + 1);
    CartService().postCart(addMap);
  }

  void decreaseQuan(String productId) {
    var cartItem = getCartItem(productId);
    var quan = cartItem.quantity!;
    if (quan > 1) {
      var addMap = createMap(cartItem, quan - 1);
      CartService().postCart(addMap);
    } else {
      CartService().removeCart(productId, docId!);
    }
  }

  void customQuan(String productId, num quan) {
    if (quan >= 1) {
      var cartItem = getCartItem(productId);
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

  double calculateTotal() {
    double total = 0.0;
    for (var item in listCart) {
      total += item.priceTotal! * item.quantity!;
    }
    return total;
  }

  double calculateTotalNonDiscount() {
    double total = 0.0;
    for (var item in listCart) {
      total += item.price! * item.quantity!;
    }
    return total;
  }
}
