import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mahaliii/config/color_palette.dart';
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

  static Shimmer shimmerListviewHor({double width=115,double height=170,int count=5,
    BorderRadiusGeometry borderRadius = const BorderRadius.all(Radius.circular(15))
  }) {
    return Shimmer.fromColors(
      baseColor: ColorPalette.lightGrey.withValues(alpha: 0.3),
      highlightColor: ColorPalette.lightGrey,
      direction: ShimmerDirection.rtl,
      child: SizedBox(
        height: height,

        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: count,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(right: 3.sp),
              width: width,
              height: height,
              decoration: BoxDecoration(
                  color: ColorPalette.lightGrey, borderRadius: borderRadius),

            );
          },
        ),
      ),
    );
  }

  static Shimmer shimmerListviewVertical({double height = 100,int count=5}) {
    return Shimmer.fromColors(
      baseColor: ColorPalette.lightGrey.withValues(alpha: 0.3),
      highlightColor: ColorPalette.lightGrey,
      direction: ShimmerDirection.rtl,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),

        shrinkWrap: true,
        padding: const EdgeInsets.all(10),
        itemCount: count,
        itemBuilder: (context, index) {
          return Container(
            height: height.h,
            margin: const EdgeInsets.symmetric(vertical: 10),

            decoration: BoxDecoration(
              color: ColorPalette.lightGrey,
              borderRadius: BorderRadius.circular(10),
            ),
          );
        },
      ),
    );
  }

  static Shimmer shimmerListviewVerticalAbdRow({double height = 100, int count = 4}) {
    return Shimmer.fromColors(
      baseColor: ColorPalette.lightGrey.withValues(alpha: 0.3),
      highlightColor: ColorPalette.lightGrey,
      direction: ShimmerDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.all(10),
            itemCount: count,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Row(
                        children: [
                          Container(
                            width: 30.w,
                            height: 30.h,
                            decoration: BoxDecoration(
                              color: ColorPalette.lightGrey,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          SizedBox(width: 10.w,),
                          Container(
                            width: 70.w,
                            height: 20.h,
                            decoration: BoxDecoration(
                              color: ColorPalette.lightGrey,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 120.w,
                        height: 20.h,
                        decoration: BoxDecoration(
                          color: ColorPalette.lightGrey,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: height.h,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: ColorPalette.lightGrey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  static Shimmer shimmerTable({double height = 100, int count = 4}) {
    return Shimmer.fromColors(
      baseColor: ColorPalette.lightGrey.withValues(alpha: 0.3),
      highlightColor: ColorPalette.lightGrey,
      direction: ShimmerDirection.rtl,
      child: Column(
        children: [

          Row(
            children: List.generate(
              4,
                  (index) => Expanded(
                child: Container(
                  height: 36.h,
                  margin: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                    color: ColorPalette.lightGrey,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 6.h),

          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 4,
            itemBuilder: (context, row) {
              return Row(
                children: List.generate(
                  4,
                      (col) => Expanded(
                    child: Container(
                      height: 42.h,
                      margin: const EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                        color: ColorPalette.lightGrey,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }


  static Shimmer lineChartShimmer({double height = 100,int count=5}) {
    return Shimmer.fromColors(
      baseColor: ColorPalette.lightGrey.withValues(alpha: 0.3),
      highlightColor: ColorPalette.lightGrey,
      child: Container(
        height: 300,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            // خطوط متقاطع پس‌زمینه + خط موج‌دار نمودار
            Expanded(
              child: CustomPaint(
                size: Size.infinite,
                painter: _ChartLinePainter(),
              ),
            ),
            const SizedBox(height: 12),
            // محور پایین
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                6,
                    (index) => Container(
                  width: 24,
                  height: 10,
                  decoration: BoxDecoration(
                    color: ColorPalette.lightGrey,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  static Shimmer barChartShimmer({double height = 100,int count=5}) {
    // ارتفاع‌های دلخواه برای طبیعی‌تر شدن شکل نمودار
    final List<double> barHeights = [120, 180, 90, 220, 150, 200, 110];
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 300,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            // محوطه اصلی نمودار
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: barHeights.map((height) {
                  return Container(
                    width: 14, // عرض میله‌ها
                    height: height,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),
            // خط محور X پایین
            Container(
              height: 2,
              color: Colors.white,
            ),
            const SizedBox(height: 8),
            // لیبل‌های محور X
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                barHeights.length,
                    (index) => Container(
                  width: 20,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  static Shimmer pieChartShimmer({double height = 100,int count=5}) {

    return Shimmer.fromColors(
      baseColor: ColorPalette.lightGrey.withValues(alpha: 0.3),
      highlightColor: ColorPalette.lightGrey,
      child: Container(
        height: 300,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Expanded(
              child: Center(
                child: SizedBox(
                  width: 180,
                  height: 180,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // دایره اصلی بیرونی
                      Container(
                        decoration:  BoxDecoration(
                          color: ColorPalette.lightGrey,
                          shape: BoxShape.circle,
                        ),
                      ),
                      // اگر نمودار دوناتی باشد، دایره توخالی وسط را می‌سازد

                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: ColorPalette.lightGrey,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                3, // تعداد آیتم‌های فرض شده راهنما
                    (index) => Row(
                  children: [
                    // آیکون دایره‌ای کوچک رنگ راهنما
                    Container(
                      width: 12,
                      height: 12,
                      decoration:  BoxDecoration(
                        color: ColorPalette.lightGrey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    // متن لایه‌بندی شده راهنما
                    Container(
                      width: 45,
                      height: 10,
                      decoration: BoxDecoration(
                        color: ColorPalette.lightGrey,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget shimmerContainer({double height = 100}) {
    return Shimmer.fromColors(
      // استفاده از رنگ‌های استاندارد و دارای تضاد مناسب
      baseColor: Colors.grey.shade800,
      highlightColor: Colors.grey.shade300,
      direction: ShimmerDirection.rtl,
      child: Container(
        height: height.h, // اعمال .h فقط در همین‌جا
        // width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white, // رنگ ماسک باید کاملاً کدر (مثل سفید) باشد
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  static Shimmer shimmerChartAndListVertical({double height = 50}) {
    return Shimmer.fromColors(
      baseColor: ColorPalette.lightGrey.withValues(alpha: 0.3),
      highlightColor: ColorPalette.lightGrey,
      direction: ShimmerDirection.rtl,
      child: Column(
        children: [
          Container(
            height: 300,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              children: [
                // خطوط متقاطع پس‌زمینه + خط موج‌دار نمودار
                Expanded(
                  child: CustomPaint(
                    size: Size.infinite,
                    painter: _ChartLinePainter(),
                  ),
                ),
                const SizedBox(height: 12),
                // محور پایین
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(
                    6,
                        (index) => Container(
                      width: 24,
                      height: 10,
                      decoration: BoxDecoration(
                        color: ColorPalette.lightGrey,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),

            shrinkWrap: true,
            padding: const EdgeInsets.all(10),
            itemCount: 4,
            itemBuilder: (context, index) {
              return Container(
                height: height.h,
                margin: const EdgeInsets.symmetric(vertical: 10),

                decoration: BoxDecoration(
                  color: ColorPalette.lightGrey,
                  borderRadius: BorderRadius.circular(10),
                ),
              );
            },
          )
        ],

      ),
    );
  }


  static Widget shimmerBarChartAndListVertical({double height = 50}) {
    // درصد ارتفاع میله‌ها برای طبیعی‌تر شدن ظاهر نمودار شیمر
    final List<double> barHeights = [0.4, 0.7, 0.5, 0.85, 0.6, 0.75];

    return Shimmer.fromColors(
      baseColor: ColorPalette.lightGrey.withValues(alpha: 0.3),
      highlightColor: ColorPalette.lightGrey,
      direction: ShimmerDirection.rtl,
      child: Column(
        children: [
          // بخش نمودار میله‌ای (BarChart)
          Container(
            height: 300,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              children: [
                // میله‌های نمودار
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: barHeights.map((factor) {
                      return FractionallySizedBox(
                        heightFactor: factor, // تنظیم ارتفاع نسبی هر میله
                        child: Container(
                          width: 22,
                          decoration:  BoxDecoration(
                            color: ColorPalette.lightGrey,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(6), // گرد کردن بالای میله‌ها
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 12),
                // محور پایین (X-Axis Labels)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(
                    barHeights.length,
                        (index) => Container(
                      width: 24,
                      height: 10,
                      decoration: BoxDecoration(
                        color: ColorPalette.lightGrey,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),

          // بخش لیست زیر نمودار
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.all(10),
            itemCount: 4,
            itemBuilder: (context, index) {
              return Container(
                height: height.h,
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: ColorPalette.lightGrey,
                  borderRadius: BorderRadius.circular(10),
                ),
              );
            },
          )
        ],
      ),
    );
  }


}

// نقاش اختصاصی برای کشیدن شکل خط نمودار
class _ChartLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    // رسم یک منحنی شبیه نمودار خطی real
    path.moveTo(0, size.height * 0.7);
    path.quadraticBezierTo(
      size.width * 0.2, size.height * 0.2,
      size.width * 0.4, size.height * 0.5,
    );
    path.quadraticBezierTo(
      size.width * 0.6, size.height * 0.8,
      size.width * 0.8, size.height * 0.3,
    );
    path.lineTo(size.width, size.height * 0.4);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
