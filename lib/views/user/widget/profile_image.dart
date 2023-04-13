import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pharmacy_mobile/helpers/loading.dart';

class CircleProfilePicture extends StatelessWidget {
  final String imageUrl;
  final double size;
  final VoidCallback onTap;

  const CircleProfilePicture(
      {super.key,
      required this.imageUrl,
      required this.size,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 3, color: Colors.transparent),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(size / 2),
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Center(child: LoadingWidget()),
                    errorWidget: (context, url, error) => Padding(
                      padding: const EdgeInsets.all(12),
                      child: Image.asset('assets/icons/icon.png'),
                    ),
                  ),
                ),
              ),
            ),
            Lottie.asset(
              'assets/lottie/user_circle.json',
            ),
          ],
        ),
      ),
    );
  }
}
