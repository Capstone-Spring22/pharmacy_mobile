import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class ProductTile extends StatelessWidget {
  const ProductTile({super.key});

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      style: const NeumorphicStyle(
        color: Colors.white,
        lightSource: LightSource.top,
      ),
      onPressed: () {},
      child: Column(
        children: [
          Image.network(
              "https://cdn.tgdd.vn/Products/Images/10250/181211/dc-ve-sinh-mui-rohto-nose-wash-400ml-2-1.jpg"),
          const Text(
            "Bộ dụng cụ vệ sinh mũi Rohto NoseWash hộp 1 bình + 400ml dung dịch",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
