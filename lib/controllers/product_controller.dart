import 'package:get/get.dart';
import 'package:pharmacy_mobile/models/product.dart';
import 'package:pharmacy_mobile/services/product_service.dart';

class ProductController extends GetxController {
  static ProductController instance = Get.find();

  RxList<PharmacyProduct> products = <PharmacyProduct>[].obs;

  RxBool isFinishLoading = false.obs;

  loadProduct(int index, int count, bool isContinue) async {
    if (isContinue) {
      var tempList = await ProductService().getProducts(index, count);
      var tempProductList = products;
      Set set = {...tempProductList, ...tempList};
      products.value = set.toList() as List<PharmacyProduct>;
    }
    products.value = await ProductService().getProducts(index, count);
    isFinishLoading.value = true;
  }

  @override
  void onInit() {
    super.onInit();

    loadProduct(1, 10, false);
  }

  PharmacyProduct getProductById(String id) {
    return products.firstWhere((element) => element.id == id);
  }
}
