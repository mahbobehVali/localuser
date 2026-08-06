// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:shimmer/shimmer.dart';
//
// //the photo we receive from server, is located in this package
// //and no need to download the photo again for the next time
// class ImageCacheLoading extends StatelessWidget {
//   const ImageCacheLoading({
//     super.key,
//     required this.image,
//     this.width,
//     this.height,
//
//       this.borderRadiusBottomRight,
//
//       this.borderRadiusBottomLeft,
//
//       this.borderRadiusTopLeft,
//
//       this.borderRadiusTopRight,
//   });
//
//   final String image;
//   final double? width;
//  final  double? height;
//   final double? borderRadiusTopLeft;
//   final double? borderRadiusTopRight;
//   final double? borderRadiusBottomLeft;
//   final double? borderRadiusBottomRight;
//
//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//
//       borderRadius: BorderRadius.only(topRight: Radius.circular(borderRadiusTopRight??0),
//         topLeft: Radius.circular(borderRadiusTopLeft??0),
//         bottomRight: Radius.circular(borderRadiusBottomRight??0),
//         bottomLeft: Radius.circular(borderRadiusBottomLeft??0),),
//       child: CachedNetworkImage(
//
//
//         placeholder: (context, url) {
//           return Center(
//             child: Shimmer.fromColors(baseColor: Colors.grey.shade300,
//               highlightColor: Colors.grey.shade400,child: Container(
//                   // width: 200.w,
//                   // height: 200.h,
//                 color: Colors.white38,
//                 ),
//
//             ),
//           );
//         },
//         fit: BoxFit.cover,
//         width: width,
//         height: height,
//         imageUrl: image,
//
//       ),
//     );
//   }
// }
