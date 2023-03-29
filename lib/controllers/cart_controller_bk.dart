// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
// import 'package:pharmacy_mobile/constrains/controller.dart';
// import 'package:pharmacy_mobile/controllers/user_controller.dart';
// import 'package:pharmacy_mobile/models/cart.dart';
// import 'package:pharmacy_mobile/services/cart_service.dart';

// class CartController extends GetxController {
//   static CartController instance = Get.find();

//   final FirebaseFirestore _db = FirebaseFirestore.instance;
//   final String _collection = 'carts';

//   RxList<CartItem> listCart = <CartItem>[].obs;
//   UserController userCtl = Get.find();

//   Rx<Map<String, dynamic>> rawItemfromFB =
//       Rx<Map<String, dynamic>>(<String, dynamic>{});

//   RxString ff = "".obs;

//   @override
//   void onInit() {
//     connectToCloudCart();
//     super.onInit();
//   }

//   Future connectToCloudCart() async {
//     if (userController.isLoggedIn.isTrue) {
//       var docId = await CartService().getCartId();
//       if (docId != null) {
//         listCart.clear();
//         listCart.bindStream(firebaseStreamCart(docId));
//       } else {
//         Get.log('Empty');
//       }
//     }
//   }

//   Stream<List<CartItem>> firebaseStreamCart(String docId) {
//     return _db.collection(_collection).doc(docId).snapshots().map((event) {
//       Get.log(event.data()!['items'].toString());
//       return [];
//     });
//   }

//   //////////////////////////////////////////////////

//   /////////////////////////////////////////////////

//   num getTotal() {
//     num total = 0;
//     for (var element in listCart) {
//       total += element.price;
//     }
//     return total;
//   }

//   void addToCart(CartItem item) {
//     var f = checkExist(item);
//     f ? increaseQuan(item) : listCart.add(item);
//     recalcPrice(item.pid);
//   }

//   void removeCart(CartItem item) => listCart.remove(item);

//   void increaseQuan(CartItem item) =>
//       updateQuantity(item.pid, itemQuantity(item.pid) + 1);

//   void decreaseQuan(CartItem item) {
//     if (itemQuantity(item.pid) == 1) {
//       Get.defaultDialog(
//         middleText: "Remove this item from cart ?",
//         onConfirm: () {
//           removeCart(item);
//           Get.back();
//         },
//         onCancel: () {},
//       );
//     } else {
//       updateQuantity(item.pid, itemQuantity(item.pid) - 1);
//     }
//   }

//   num itemQuantity(String id) =>
//       listCart.firstWhere((element) => element.pid == id).quantity;

//   int itemIndex(String id) =>
//       listCart.indexWhere((element) => element.pid == id);

//   CartItem cartItem({String? id, int? index}) {
//     if (id != null) {
//       return listCart.firstWhere((element) => element.pid == id);
//     } else {
//       return listCart[index!];
//     }
//   }

//   bool checkExist(CartItem item) {
//     var res = listCart.firstWhereOrNull((element) => element.pid == item.pid);
//     return res != null;
//   }

//   void updateQuantity(String id, num newQuantity) {
//     int index = itemIndex(id);
//     CartItem item = cartItem(index: index);
//     listCart[index] = item.copyWith(quantity: newQuantity);
//     recalcPrice(id);
//   }

//   void recalcPrice(String id) {
//     int index = itemIndex(id);
//     CartItem item = cartItem(index: index);

//     num price = num.parse(productController
//         .getProductById(listCart[index].pid)
//         .priceAfterDiscount
//         .toString());
//     num quan = listCart[index].quantity;
//     listCart[index] = item.copyWith(price: price * quan);
//     syncCartToFirebase(id);
//   }

//   void recalcPriceTotal() {
//     for (int i = 0; i < listCart.length; i++) {
//       var tempCart = listCart[i];
//       var price = tempCart.quantity *
//           num.parse(productController
//               .getProductById(tempCart.pid)
//               .priceAfterDiscount
//               .toString());
//       listCart[i] = tempCart.copyWith(price: price);
//     }
//   }

//   Map<String, dynamic> listCartToMap() {
//     List<Map<String, dynamic>> cartMap = [];
//     for (int i = 0; i < listCart.length; i++) {
//       cartMap.add({
//         "pid": listCart[i].pid,
//         "quantity": listCart[i].quantity,
//       });
//     }

//     Map<String, dynamic> map = {
//       'last-update': FieldValue.serverTimestamp(),
//       'items': cartMap
//     };

//     return map;
//   }

//   Future syncCartToFirebase(String pid) async {
//     final item = listCart.firstWhere((e) => e.pid == pid);

//     final map = {
//       "productId": item.pid,
//       "quantity": item.quantity,
//     };

//     await CartService().postCart(map, appController.androidInfo!.id);
//   }
// }
