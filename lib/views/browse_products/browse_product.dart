import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/helpers/loading.dart';
import 'package:pharmacy_mobile/models/main_cate.dart';
import 'package:pharmacy_mobile/models/product.dart';
import 'package:pharmacy_mobile/models/sub_category.dart';
import 'package:pharmacy_mobile/services/product_service.dart';
import 'package:pharmacy_mobile/views/drawer/cart_drawer.dart';
import 'package:pharmacy_mobile/views/drawer/menu_drawer.dart';
import 'package:pharmacy_mobile/views/home/widgets/cart_btn.dart';
import 'package:pharmacy_mobile/views/home/widgets/product_tile.dart';
import 'package:pharmacy_mobile/widgets/appbar.dart';
import 'package:pharmacy_mobile/widgets/back_button.dart';
import 'package:pharmacy_mobile/widgets/detail_content.dart';

class BrowseProductScreen extends StatefulWidget {
  const BrowseProductScreen({super.key});

  @override
  State<BrowseProductScreen> createState() => _BrowseProductScreenState();
}

class _BrowseProductScreenState extends State<BrowseProductScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool isLoadingMain = false;
  bool isLoadingSub = false;
  bool isLoadingProducts = false;

  List<MainCategory> categories = [];
  List<SubCategory> subCategories = [];
  List<PharmacyProduct> products = [];

  RxString selectedCategory = "".obs;
  RxString selectedSubCategory = "".obs;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

    _loadCategories();
    _loadProducts(1, 1000);

    ever(selectedCategory, _loadSubcategories);
    everAll([selectedCategory, selectedSubCategory], (v) {
      _loadProducts(1, 1000);
    });
  }

  _loadSubcategories(String id) async {
    final type = id.split("-")[0].trim();
    if (type == 'main') {
      final mainId = id.split("-")[1].trim();
      setState(() {
        isLoadingSub = true;
      });
      subCategories = await ProductService().fetchSubCategoriesById(mainId);
      setState(() {
        isLoadingSub = false;
      });
    }
  }

  _loadProducts(int page, int items) async {
    try {
      setState(() {
        isLoadingProducts = true;
      });

      products = await ProductService().getProductsCustomOption(
        1,
        10,
        selectedCategory.value.isEmpty
            ? ""
            : selectedCategory.value.split("-")[1].trim(),
        selectedSubCategory.value.isEmpty
            ? ""
            : selectedSubCategory.value.split("-")[1].trim(),
      );
      setState(() {
        isLoadingProducts = false;
      });
    } catch (e) {}
  }

  _loadCategories() async {
    setState(() {
      isLoadingMain = true;
    });
    categories = await ProductService().fetchCategories();
    setState(() {
      isLoadingMain = false;
      _animationController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MenuDrawer(),
      endDrawer: const CartDrawer(),
      appBar: PharmacyAppBar(
        leftWidget: const PharmacyBackButton(),
        midText: "Lướt sản phẩm",
        rightWidget: const CartButton(),
      ),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: 500.milliseconds,
          transitionBuilder: (child, animation) => ScaleTransition(
            scale: animation,
            child: child,
          ),
          child: isLoadingMain
              ? const Center(
                  child: LoadingWidget(
                    size: 60,
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //Main Categories
                      DetailContent(
                        title: "Danh mục",
                        content: SizedBox(
                          width: double.infinity,
                          child: Wrap(
                            runSpacing: 15,
                            spacing: 15,
                            alignment: WrapAlignment.spaceEvenly,
                            runAlignment: WrapAlignment.center,
                            children: categories
                                .map((mainCate) => ScaleTransition(
                                      scale: _animation,
                                      child: GestureDetector(
                                        onTap: () => selectedCategory.value =
                                            'main-${mainCate.id}',
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                            vertical: 5,
                                            horizontal: 1,
                                          ),
                                          width: Get.width * .4,
                                          height: Get.height * .08,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                              color: context.theme.primaryColor,
                                            ),
                                          ),
                                          child: Center(
                                              child: Text(
                                            mainCate.categoryName!,
                                            style: context.textTheme.bodyMedium!
                                                .copyWith(
                                              color: context.theme.primaryColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      ),

                      // Sub categories

                      DetailContent(
                        title: "Danh mục con",
                        content: isLoadingSub
                            ? const LoadingWidget(
                                size: 60,
                              )
                            : subCategories.isEmpty
                                ? const Center(
                                    child: Text("Không có danh mục"),
                                  )
                                : SizedBox(
                                    width: double.infinity,
                                    child: Wrap(
                                      alignment: WrapAlignment.spaceEvenly,
                                      runAlignment: WrapAlignment.center,
                                      runSpacing: 15,
                                      spacing: 15,
                                      children: subCategories
                                          .map((subCate) => ScaleTransition(
                                                scale: _animation,
                                                child: GestureDetector(
                                                  onTap: () =>
                                                      selectedSubCategory
                                                              .value =
                                                          'sub-${subCate.id}',
                                                  child: Container(
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                      vertical: 5,
                                                      horizontal: 1,
                                                    ),
                                                    width: Get.width * .4,
                                                    height: Get.height * .08,
                                                    padding:
                                                        const EdgeInsets.all(
                                                      15,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                        color: context
                                                            .theme.primaryColor,
                                                      ),
                                                    ),
                                                    child: Center(
                                                        child: Text(
                                                      subCate.subCategoryName!,
                                                      style: context
                                                          .textTheme.bodyMedium!
                                                          .copyWith(
                                                        color: context
                                                            .theme.primaryColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    )),
                                                  ),
                                                ),
                                              ))
                                          .toList(),
                                    ),
                                  ),
                      ),

                      subCategories.isEmpty
                          ? const Center(
                              child: Text("Không có sản phẩm"),
                            )
                          : DetailContent(
                              haveDivider: false,
                              title: "Sản phẩm",
                              content: isLoadingProducts
                                  ? const LoadingWidget(
                                      size: 60,
                                    )
                                  : SizedBox(
                                      width: double.infinity,
                                      child: Wrap(
                                        alignment: WrapAlignment.spaceEvenly,
                                        runAlignment: WrapAlignment.center,
                                        runSpacing: 20,
                                        spacing: 15,
                                        children: products
                                            .map((product) => SizedBox(
                                                  width: Get.width * .43,
                                                  height: Get.height * .37,
                                                  child: ProductTile(
                                                    fn: () => Get.toNamed(
                                                      '/product_detail',
                                                      preventDuplicates: false,
                                                      arguments: [product.id],
                                                    ),
                                                    product: product,
                                                  ),
                                                ))
                                            .toList(),
                                      ),
                                    )),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
