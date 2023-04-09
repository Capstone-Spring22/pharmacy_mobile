import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Lottie.asset(
          "assets/lottie/user_circle.json",
          height: Get.height * .2,
          width: Get.height * .2,
        ),
        // Obx(() {
        //   if (!userController.isLoggedIn.value) {
        //     return Image.asset(
        //       "assets/icons/icon.png",
        //       height: Get.height * .13,
        //       width: Get.height * .13,
        //     );
        //   } else {
        //     return ClipRRect(
        //       borderRadius: BorderRadius.circular(50),
        //       // child: CachedNetworkImage(
        //       //   imageUrl: userController.user.value.imageURL!,
        //       //   errorWidget: (context, url, error) => Image.network(
        //       //     "https://png.pngtree.com/png-vector/20220709/ourmid/pngtree-businessman-user-avatar-wearing-suit-with-red-tie-png-image_5809521.png",
        //       //     height: Get.height * .155,
        //       //     width: Get.height * .155,
        //       //   ),
        //       // ),
        //       child: CachedNetworkImage(
        //         imageUrl:
        //             'https://png.pngtree.com/png-vector/20220709/ourmid/pngtree-businessman-user-avatar-wearing-suit-with-red-tie-png-image_5809521.png',
        //         height: Get.height * .155,
        //         width: Get.height * .155,
        //       ),
        //     );
        //   }
        // })
        Image.asset(
          "assets/icons/icon.png",
          height: Get.height * .13,
          width: Get.height * .13,
        ),
      ],
    );
  }
}
