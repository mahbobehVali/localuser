import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mahaliii/common/widgets/icon_container.dart';

import '../../../../config/color_palette.dart';
import '../../../../config/texts_style.dart';
import '../../domain/entity/alert_data_entity.dart';

class AlertDetailScreen extends StatelessWidget {
  const AlertDetailScreen({super.key,required this.alertDataEntity});
  final AlertDataEntity alertDataEntity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:  EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text( "اطلاعات کامل هشدار ارسال شده",style: TextStyleP.f16Medium,),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconContainer(icon: Icon(Icons.alarm),color:ColorPalette.inverseGrey ,),
                      Text(alertDataEntity.message!),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: alertDataEntity.status==0 ?ColorPalette.lightBlue:
                        alertDataEntity.status==1?Colors.yellow:
                        ColorPalette.lightGreen,
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: Text(alertDataEntity.status==0 ?"جدید":
                    alertDataEntity.status==1?"در حال بررسی":
                    "پاسخ داده شده"),
                  ),
                ],
              ),


            ],
          ),
        ),
      ),
    );
  }
}
