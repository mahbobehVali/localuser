import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../config/color_palette.dart';
import '../../config/texts_style.dart';

class PaginationWidget extends StatelessWidget {
  const PaginationWidget({
    super.key,
    required this.selected,
    required this.lastPage,
    required this.onPageChanged,
  });

  final int selected;
  final int lastPage;
  final Function(int page) onPageChanged;

  /// منطق دقیق تولید شماره صفحات با سه نقطه ثابت
  List<dynamic> _buildPageItems() {
    if (lastPage <= 1) return [1];

    final List<dynamic> items = [];

    if (selected == lastPage) {
      // اگر روی آخرین صفحه هستید: نمایش عدد قبل‌تر + سه نقطه + صفحه آخر (مثلاً: 28 ... 30)
      if (lastPage - 2 > 0) {
        items.add(lastPage - 2);
        items.add("...");
      }
      items.add(lastPage);
    } else {
      // در سایر صفحات: شماره صفحه فعلی + سه نقطه + شماره صفحه آخر (مثلاً: 1 ... 30 یا 2 ... 30)
      items.add(selected);

      // اگر فاصله بین صفحه فعلی و صفحه آخر بیشتر از ۱ است، سه نقطه بگذار
      if (lastPage - selected > 1) {
        items.add("...");
      }

      items.add(lastPage);
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    if (lastPage <= 1) return const SizedBox();

    final pageItems = _buildPageItems();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // متن وضعیت صفحه
        Text(
          "صفحه ${selected.toString().toPersianDigit()} از ${lastPage.toString().toPersianDigit()}",
          style: TextStyleP.f10Regular,
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ۱. دکمه رفتن به اولین صفحه (<<)
            _buildIconButton(
              icon: Icons.first_page,
              isDisabled: selected == 1,
              onTap: () => onPageChanged(1),
            ),

            // ۲. دکمه صفحه قبل (<)
            _buildIconButton(
              icon: Icons.navigate_before,
              isDisabled: selected == 1,
              onTap: () => onPageChanged(selected - 1),
            ),

            const SizedBox(width: 4),

            // ۳. مربعات شماره صفحه و سه نقطه‌ها
            Row(
              mainAxisSize: MainAxisSize.min,
              children: pageItems.map((item) {
                // رندر کردن سه نقطه (...)
                if (item == "...") {
                  return Container(
                    width: 20.w,
                    height: 30.h,
                    alignment: Alignment.center,
                    child: Text(
                      "...",
                      style: TextStyle(
                        color: ColorPalette.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }

                // رندر کردن مربع اعداد
                final int page = item as int;
                final isSelected = selected == page;

                return GestureDetector(
                  onTap: isSelected ? null : () => onPageChanged(page),
                  child: Container(
                    width: 30.w,
                    height: 30.h,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: isSelected ? const Color(0xff82A5D2) : Colors.transparent,
                      border: Border.all(color: Colors.black),
                    ),
                    child: Center(
                      child: Text(
                        page.toString().toPersianDigit(),
                        style: TextStyle(color: ColorPalette.black),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(width: 4),

            // ۴. دکمه صفحه بعد (>)
            _buildIconButton(
              icon: Icons.navigate_next,
              isDisabled: selected == lastPage,
              onTap: () => onPageChanged(selected + 1),
            ),

            // ۵. دکمه رفتن به آخرین صفحه (>>)
            _buildIconButton(
              icon: Icons.last_page,
              isDisabled: selected == lastPage,
              onTap: () => onPageChanged(lastPage),
            ),
          ],
        ),
      ],
    );
  }

  /// ویجت ساخت دکمه‌های آیکون‌دار
  Widget _buildIconButton({
    required IconData icon,
    required bool isDisabled,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: Container(
        width: 30.w,
        height: 30.h,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isDisabled ? ColorPalette.grey : ColorPalette.black,
          ),
        ),
        child: Icon(
          icon,
          color: isDisabled ? ColorPalette.grey : ColorPalette.black,
          size: 18.sp,
        ),
      ),
    );
  }
}