import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class ProductTile extends StatelessWidget {
  const ProductTile({super.key});

  @override
  Widget build(BuildContext context) {
    const String img =
        "https://cdn.tgdd.vn/Products/Images/10250/181211/dc-ve-sinh-mui-rohto-nose-wash-400ml-2-1.jpg";
    const String name =
        "Bộ dụng cụ vệ sinh mũi Rohto NoseWash hộp 1 bình + 400ml dung dịch";
    return NeumorphicButton(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      style: const NeumorphicStyle(
        color: Colors.white,
        lightSource: LightSource.top,
      ),
      onPressed: () {},
      child: Column(
        children: [
          CachedNetworkImage(
            filterQuality: FilterQuality.low,
            maxHeightDiskCache: 512,
            imageUrl: img,
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                CircularProgressIndicator(value: downloadProgress.progress),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          const Text(
            name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
