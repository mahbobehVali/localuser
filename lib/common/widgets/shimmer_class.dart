import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerClass {
  static Shimmer shimmerGridview() {
    return Shimmer.fromColors(
        baseColor: Colors.grey.shade400,
        highlightColor: Colors.grey.shade200,
        child: GridView.builder(
          itemCount: 4,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // number of items in each row
            mainAxisSpacing: 8.0, // spacing between rows
            crossAxisSpacing: 20, // spacing between columns
          ),
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Color(0xffEDEDED),
              ),
            );
          },
        ));
  }

  static Shimmer shimmerListviewHor({double width=115,double height=170,
    BorderRadiusGeometry borderRadius = const BorderRadius.all(Radius.circular(15))
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[200]!,
      highlightColor: Colors.grey[100]!,
      direction: ShimmerDirection.rtl,
      child: SizedBox(
        height: height,

        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 6,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(right: 3.sp),
              width: width,
              height: height,
              decoration: BoxDecoration(
                  color: Color(0xffEDEDED), borderRadius: borderRadius),

            );
          },
        ),
      ),
    );
  }

  static Shimmer shimmerListviewVertical({double height = 100,int count=10}) {
    return Shimmer.fromColors(
      baseColor: Color(0xffEDEDED),
      highlightColor:  Color(0xffffffff),
      direction: ShimmerDirection.rtl,
      child: ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.all(10),
        itemCount: count,
        itemBuilder: (context, index) {
          return Container(
            height: height.h,
            margin: const EdgeInsets.symmetric(vertical: 10),

            decoration: BoxDecoration(
              color: Color(0xffEDEDED),
              borderRadius: BorderRadius.circular(10),
            ),
          );
        },
      ),
    );
  }
}
