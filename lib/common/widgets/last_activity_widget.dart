import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mahaliii/common/widgets/export_to_excel.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../config/color_palette.dart';
import '../../config/texts_style.dart';
import '../../features/status_summary_feature/domain/entity/last_activity_entity.dart';
import '../utils/constants.dart';

class LastActivityWidget extends StatelessWidget {
  const LastActivityWidget({
    super.key,
    required this.lastActivityEntity,
    required this.report,
  });

  final LastActivityEntity lastActivityEntity;
  final bool report;

  @override
  Widget build(BuildContext context) {
    List<LastActivitySlot> flatList = [];
    for (var park in lastActivityEntity.data!) {
      // چک کردن اینکه آیا لیست تاریخ‌ها وجود دارد و خالی نیست
      if (park.dates == null || (park.dates as List).isEmpty) continue;
      for (var dateItem in park.dates!) {
        // چک کردن اینکه آیا لیست ساعت‌ها وجود دارد و خالی نیست
        if (dateItem.hours == null || (dateItem.hours as List).isEmpty) continue;
        for (var time in dateItem.hours!) {
          flatList.add(LastActivitySlot(park.name ?? "نامشخص",
              dateItem.date ?? "بدون تاریخ",
              time.time ?? "-",
              time.name??"-",
              time.status??"-",
              time.type??"-"));
        }
      }
    }
    return Column(
      children: [
       if(report)
         Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             Text("جدول اطلاعات دستوردهی به دستگاه", style: TextStyleP.f12Regular),
             IconButton(
                 onPressed: () {
                   exportActivityToExcel(context, flatList);

                 },
                 icon:Icon(Icons.file_download_outlined))
           ],
         ),
         SizedBox(height: 10.h),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,

          child: Container(
            width: 500,
            decoration: BoxDecoration(
                border: BoxBorder.all(color: ColorPalette.lightGrey),
                borderRadius: BorderRadius.circular(5)
            ),

            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: flatList.length+1,
              itemBuilder: (context, index) {
                return
                  index==0? Container(
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),

                    decoration: BoxDecoration(
                      color: ColorPalette.lightGrey,
                    ),
                    child: Row(
                      children: [
                        Expanded(flex: 2,child: Text("نام چاه",style: TextStyleP.f12Regular, textAlign: TextAlign.center)),
                        Expanded(flex: 1,child: Text("تاریخ",style: TextStyleP.f12Regular, textAlign: TextAlign.center)),
                        Expanded(flex: 1,child: Text("ساعت",style: TextStyleP.f12Regular, textAlign: TextAlign.center)),
                        Expanded(flex: 1,child: Text("وضعیت",style: TextStyleP.f12Regular, textAlign: TextAlign.center)),
                        Expanded(flex: 2,child: Text("توسط",style: TextStyleP.f12Regular, textAlign: TextAlign.center)),

                      ],
                    ),
                  ):
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                    decoration: BoxDecoration(
                        border: BoxBorder.fromLTRB(bottom: BorderSide(color: ColorPalette.lightGrey,
                           ))
                    ),
                    child: Row(
                      children: [
                        Expanded(flex: 2,child: Text(flatList[index-1].wellName,style: TextStyleP.f10Regular, textAlign: TextAlign.center)),
                        Expanded(flex: 1,child: Text(flatList[index-1].date.toPersianDigit(),style: TextStyleP.f10Regular, textAlign: TextAlign.center)),
                        Expanded(flex: 1,child: Text(flatList[index-1].time.toPersianDigit(),style: TextStyleP.f10Regular, textAlign: TextAlign.center)),
                        Expanded(flex: 1,child: Text(flatList[index-1].status,style: TextStyleP.f10Regular, textAlign: TextAlign.center)),
                        Expanded(flex: 2,child: Text(flatList[index-1].name,style: TextStyleP.f10Regular, textAlign: TextAlign.center)),


                      ],
                    ),
                  );
              },
            ),
          ),
        ),
      ],
    );
  }
}
