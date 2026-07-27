import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../config/texts_style.dart';

class PaginationWidget extends StatelessWidget {
  const PaginationWidget({super.key,required this.selected,required this.lastPage,
    required this.onPageChanged});

  final int selected;
  final int lastPage;
  final Function(int page) onPageChanged; // تعریف جدید
  @override
  Widget build(BuildContext context) {
    return lastPage>1?
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("صفحه ${selected.toString().toPersianDigit()} از ${lastPage.toString().toPersianDigit()} ",style: TextStyleP.f10Regular),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: selected == 1 ? null : () => onPageChanged(selected - 1), // پاس دادن صفحه قبلی
                child: Container(
                    width: 30.w,
                    height: 30.h,
                    // padding: const EdgeInsets.symmetric(vertical: 7),
                    margin: const EdgeInsets.symmetric(horizontal: 4),

                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),

                        border: Border.all(color: Colors.grey)
                    ),
                    child: Icon(Icons.navigate_before)),
              ),

              SizedBox(

                width: lastPage*46> MediaQuery.sizeOf(context).width*0.4?
                MediaQuery.sizeOf(context).width*0.4:
                lastPage*46,
                height: 30.h,

                child: ListView.builder(

                  scrollDirection: Axis.horizontal,
                  itemCount: lastPage,itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: selected == index+1 ? null : () => onPageChanged(index+1), // پاس دادن صفحه قبلی

                    child: Container(
                      width: 30.w,
                      height: 30.h,
                      // padding: const EdgeInsets.all(7),
                      margin: const EdgeInsets.symmetric(horizontal: 4),

                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color:selected==index+1?Color(0xff82A5D2):Colors.transparent,

                          border: Border.all(
                              color: selected==index+1?Colors.transparent:Colors.grey
                          )
                      ),
                      child: Center(child: Text((index+1).toString().toPersianDigit()))

                    ),
                  );
                },),
              ),
              GestureDetector(
                onTap: selected == lastPage ? null : () => onPageChanged(selected + 1), // پاس دادن صفحه قبلی
                child: Container(
                    width: 30.w,
                    height: 30.h,
                    // padding: const EdgeInsets.symmetric(vertical: 7),
                    margin: const EdgeInsets.symmetric(horizontal: 4),

                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),

                        border: Border.all(color: Colors.grey)
                    ),
                    child: Icon(Icons.navigate_next)),
              ),

            ],
          ),
        ],
      ),
    ):
    const SizedBox();
  }
}
