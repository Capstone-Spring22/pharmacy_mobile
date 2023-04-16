// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:lottie/lottie.dart';
// import 'package:pharmacy_mobile/constrains/controller.dart';

// class UserAvatar extends StatelessWidget {
//   const UserAvatar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: Get.width * .05, vertical: 20),
//       child: Container(
//         height: Get.height * .22,
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: const Color(0xff4380ff),
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: const [
//             BoxShadow(
//               color: Color(0xff4380ff),
//               blurRadius: 2,
//               offset: Offset(0, 5),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             Row(
//               children: [
//                 Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     Lottie.asset(
//                       "assets/lottie/user_circle.json",
//                       height: Get.height * .1,
//                       width: Get.height * .1,
//                     ),
//                     Container(
//                       height: Get.height * .09,
//                       width: Get.height * .09,
//                       decoration: const BoxDecoration(
//                         color: Colors.white, // Set white background color
//                         shape: BoxShape.circle, // Set circular shape
//                       ),
//                       child: Image.asset(
//                         "assets/icons/icon.png",
//                         fit: BoxFit
//                             .cover, // Ensure the image fills the circular shape
//                       ),
//                     ),
//                   ],
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 10),
//                   child: AutoSizeText(
//                     userController.user.value!.name!,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     maxLines: 2,
//                   ),
//                 ),
//               ],
//             ),
//             AutoSizeText(
//               userController.detailUser.value!.phoneNo!,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 20,
//                 letterSpacing: 1.5,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

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
        Image.asset(
          "assets/icons/icon.png",
          height: Get.height * .13,
          width: Get.height * .13,
        ),
      ],
    );
  }
}
