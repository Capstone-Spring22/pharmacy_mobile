import 'package:flutter/material.dart';
import 'package:pharmacy_mobile/screens/home/widgets/product_tile.dart';

class ListItemBuilder extends StatelessWidget {
  const ListItemBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 0),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return const Padding(
          padding: EdgeInsets.all(20.0),
          child: ProductTile(),
        );
      },
      itemCount: 10,
    );
  }
}
