import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/helpers/loading.dart';
import 'package:pharmacy_mobile/main.dart';
import 'package:pharmacy_mobile/models/product.dart';

class SearchItem extends StatelessWidget {
  const SearchItem({
    super.key,
    required this.item,
  });

  final PharmacyProduct item;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        // border: Border.all(color: context.theme.primaryColor),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Color(0xfff6f5f8),
            spreadRadius: 10,
            blurRadius: 10,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: ListTile(
        leading: CachedNetworkImage(
          imageUrl: item.imageModel!.imageURL!,
          height: Get.height * .2,
          width: Get.width * .2,
          placeholder: (context, url) => const LoadingWidget(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        title: Text(item.name!),
        subtitle: Text(
          '${item.price!.convertCurrentcy()} - ${item.productUnitReferences![0].unitName}',
        ),
        onTap: () => Get.toNamed(
          '/product_detail',
          preventDuplicates: false,
          arguments: item.id,
        ),
      ),
    );
  }
}
