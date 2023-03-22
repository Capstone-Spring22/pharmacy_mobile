import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/helpers/loading.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageList extends StatefulWidget {
  final List<String> imageUrls;

  const ImageList({super.key, required this.imageUrls});

  @override
  _ImageListState createState() => _ImageListState();
}

class _ImageListState extends State<ImageList> {
  final int _currentIndex = 0;

  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: widget.imageUrls.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => PhotoViewGallery.builder(
                gaplessPlayback: true,
                pageController: _pageController,
                allowImplicitScrolling: true,
                scrollPhysics: const BouncingScrollPhysics(),
                builder: (BuildContext context, int index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: NetworkImage(widget.imageUrls[index]),
                    heroAttributes:
                        PhotoViewHeroAttributes(tag: widget.imageUrls[index]),
                    minScale: PhotoViewComputedScale.contained,
                    maxScale: PhotoViewComputedScale.contained * 2,
                  );
                },
                itemCount: widget.imageUrls.length,
                loadingBuilder: (context, event) => Center(
                  child: LoadingWidget(),
                ),
                backgroundDecoration:
                    const BoxDecoration(color: Colors.transparent),
              ),
            );
          },
          child: Hero(
            tag: widget.imageUrls[index],
            child: CachedNetworkImage(
              imageUrl: widget.imageUrls[index],
              width: double.infinity,
              height: Get.height * .3,
            ),
          ),
        );
      },
    );
  }
}
