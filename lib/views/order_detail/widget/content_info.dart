// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter/material.dart';

// class DetailContent extends StatelessWidget {
//   const DetailContent({
//     super.key,
//     required this.title,
//     required this.content,
//     this.haveDivider = true,
//     this.zeroPadding = false,
//   });

//   final String title;
//   final Widget content;
//   final bool haveDivider;
//   final bool zeroPadding;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Padding(
//           padding: zeroPadding
//               ? EdgeInsets.zero
//               : const EdgeInsets.symmetric(vertical: 5),
//           child: ListTile(
//             title: AutoSizeText(
//               title,
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 20,
//               ),
//             ),
//             subtitle: content,
//           ),
//         ),
//         if (haveDivider) const Divider()
//       ],
//     );
//   }
// }
