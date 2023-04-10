import 'package:get/get.dart';
import 'package:pharmacy_mobile/models/product.dart';
import 'package:pharmacy_mobile/models/site.dart';
import 'package:pharmacy_mobile/services/product_service.dart';

class ProductController extends GetxController {
  static ProductController instance = Get.find();

  RxList<PharmacyProduct> products = <PharmacyProduct>[].obs;

  RxBool isFinishLoading = false.obs;

  RxList<PharmacyProduct> trending = <PharmacyProduct>[].obs;

  RxList<PharmacySite> listSite = <PharmacySite>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadProduct(1, 10, false);
    loadSite();
  }

  loadProduct(int index, int count, bool isContinue) async {
    if (isContinue) {
      var tempList = await ProductService().getProducts(index, count);
      var tempProductList = products;
      Set set = {...tempProductList, ...tempList};
      products.value = set.toList() as List<PharmacyProduct>;
    }
    products.value = await ProductService().getProducts(index, count);
    isFinishLoading.value = true;
    // await fetchTrending();
  }

  loadSite() async {
    listSite.value = await ProductService().getSite();
  }

  // Future fetchTrending() async {
  //   try {
  //     trending.value = await ProductService().getTopSelling();
  //     for (final i in trending) {
  //       if (!products.contains(i)) {
  //         products.add(i);
  //       }
  //     }
  //   } catch (e) {
  //     Get.log("Error loading trending - $e");
  //   }
  // }

  Future<PharmacyProduct?> getProductById(String id) async {
    try {
      return products.firstWhere((element) => element.id == id);
    } catch (e) {
      var p = await ProductService().getProductByName(id);
      if (p != null) {
        products.addIf(!products.contains(p), p);
        return p;
      }
    }
    return null;
  }
}
