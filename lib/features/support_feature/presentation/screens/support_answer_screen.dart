
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mahaliii/common/utils/constants.dart';
import 'package:mahaliii/common/widgets/download_image.dart';
import 'package:mahaliii/common/widgets/global_elevated_button.dart';
import 'package:mahaliii/common/widgets/icon_container.dart';
import 'package:mahaliii/common/widgets/shimmer_class.dart';
import 'package:mahaliii/config/color_palette.dart';
import 'package:mahaliii/config/texts_style.dart';
import 'package:mahaliii/features/support_feature/domain/entity/support_answer_list_entity.dart';
import 'package:mahaliii/features/support_feature/domain/entity/support_data_entity.dart';
import 'package:mahaliii/features/support_feature/domain/usecase/send_support_usecase.dart';
import 'package:mahaliii/features/support_feature/domain/usecase/support_answers_usecase.dart';
import 'package:mahaliii/features/support_feature/domain/usecase/support_usecase.dart';
import 'package:mahaliii/features/support_feature/presentation/bloc/send_answer_status.dart';
import 'package:mahaliii/features/support_feature/presentation/bloc/support_answers_status.dart';
import 'package:mahaliii/features/support_feature/presentation/bloc/support_bloc.dart';
import 'package:mahaliii/features/support_feature/presentation/bloc/support_close_status.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../../common/params/flowmeter_params.dart';
import '../../../../common/params/send_new_request_to_support_params.dart';
import '../../../../common/widgets/bottom_sheets.dart';
import '../../../../common/widgets/global_snackbar.dart';
import '../../../../common/widgets/image_converter.dart';
import '../../../../locator.dart';
import '../../domain/usecase/send_answer_usecase.dart';
import '../../domain/usecase/support_close_usecase.dart';

class SupportAnswerScreen extends StatelessWidget {
   SupportAnswerScreen({super.key,required this.supportDataEntity});
  final SupportDataEntity supportDataEntity;
  final GlobalKey<FormState> answerFormKey = GlobalKey();
  TextEditingController answerController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<SupportBloc>(
        create: (context) {
          SupportBloc supportBloc = SupportBloc(
            locator<SupportUseCase>(),
            locator<SupportAnswersUseCase>(),
            locator<SendSupportUseCase>(),
            locator<SendAnswerUseCase>(),
            locator<SupportCloseUseCase>(),


          );
          supportBloc.add(GetSupportAnswers(supportDataEntity.id!));
          return supportBloc;
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 50.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(supportDataEntity.subject??"", style: TextStyleP.f16Medium),
                  IconButton(
                    style: ButtonStyle(
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)
                        ),
                      ),
                      side: WidgetStatePropertyAll(
                        BorderSide(),
                      ),
                    ),
                    icon: const Icon(Icons.navigate_next),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              SizedBox(height: 24.h),
             Expanded(
               child: Container(
                 color: Colors.white,
                 padding: EdgeInsets.all(20.sp),
                 child: BlocBuilder<SupportBloc,SupportState>(builder: (context, state) {
                   if(state.supportAnswersStatus is SupportAnswersLoading){
                     return ShimmerClass.shimmerListviewVerticalAbdRow(height: 40);
                   } if(state.supportAnswersStatus is SupportAnswersError){
                     SupportAnswersError supportAnswersError=state.supportAnswersStatus as SupportAnswersError;
                     return Center(child: Text(supportAnswersError.error));
                   } if(state.supportAnswersStatus is SupportAnswersSuccess){
                     SupportAnswersSuccess supportAnswersSuccess=state.supportAnswersStatus as SupportAnswersSuccess;
                     return  SingleChildScrollView(
                       scrollDirection: Axis.vertical,
                       child: Column(
                         children: [
                           ListView.builder(
                             physics: NeverScrollableScrollPhysics(),
                             shrinkWrap: true,
                             itemCount: supportAnswersSuccess.supportAnswerEntity.support?.length,
                             itemBuilder: (context, index) {
                               SupportDataEntity supportDataEntity=supportAnswersSuccess.supportAnswerEntity.support![index];
                               return Column(
                                 children: [
                                   Row(
                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                     children: [
                                       Row(
                                         children: [
                                           IconContainer(icon: Icon(Icons.person_2_outlined), color: ColorPalette.lightBlue,),
                                           SizedBox(width: 5.w,),
                                           Text(supportAnswersSuccess.supportAnswerEntity.user!),
                                         ],
                                       ),
                                       Text("${supportDataEntity.clock!.toString().toPersianDigit()}     ${supportDataEntity.date!.toString().toPersianDigit()}"),
                                       // Expanded(child: Text(supportDataEntity.date!)),
                                     ],
                                   ),
                                   SizedBox(height: 8,),
                                   // Container(
                                   //   width: double.infinity,
                                   //
                                   //   padding: EdgeInsets.all(8),
                                   //   decoration: BoxDecoration(
                                   //     borderRadius: BorderRadius.circular(4),
                                   //     border: BoxBorder.all(color: ColorPalette.inverseGrey)
                                   //   ),
                                   //   child: Text(supportDataEntity.description??""),
                                   //
                                   // ),
                                   // ReadMoreText(
                                   //   supportDataEntity.description??"",
                                   // trimLines: 2, // یا می‌توانید تعداد خطوط را مشخص کنید
                                   // trimLength: 100, // یا بر اساس تعداد کاراکتر (مثلاً ۱۰۰ کاراکتر)
                                   // trimMode: TrimMode.Length, // حالت محدودسازی بر اساس تعداد کاراکتر
                                   // trimCollapsedText: ' بیشتر',
                                   // trimExpandedText: ' بستن',
                                   // moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue),
                                   // lessStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red),
                                   // style: TextStyle(fontSize: 16, color: Colors.black),
                                   // ),
                                   ExpandableText(
                                     text: supportDataEntity.description??"",
                                     maxChars: 200,
                                   ),
                                   SizedBox(height: 8,),

                                  supportDataEntity.payvast==null?SizedBox():
                                  PayvastSupportFile(url: "${Constants.baseUrl}uploads/support/${supportDataEntity.payvast}")
                                 ],
                               );

                             },),
                           if(supportAnswersSuccess.supportAnswerEntity.list!=null)
                             ListView.builder(
                               physics: NeverScrollableScrollPhysics(),
                               shrinkWrap: true,
                               itemCount: supportAnswersSuccess.supportAnswerEntity.list?.length,
                               itemBuilder: (context, index) {
                                 SupportAnswerListEntity supportAnswerListEntity=supportAnswersSuccess.supportAnswerEntity.list![index];
                                 return Padding(
                                   padding: const EdgeInsets.symmetric(vertical: 8.0),
                                   child: Column(
                                     children: [
                                       Row(
                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                         children: [
                                           Row(
                                             children: [
                                               IconContainer(icon: Icon(Icons.contact_support_outlined), color: ColorPalette.lightBlue,),
                                               SizedBox(width: 5.w,),
                                               Text(supportAnswerListEntity.name??"نامشخص"),
                                             ],
                                           ),
                                           Text("${supportAnswerListEntity.clock!.toString().toPersianDigit()}     ${supportAnswerListEntity.date!.toString().toPersianDigit()}"),
                                           // Expanded(child: Text(supportDataEntity.date!)),
                                         ],
                                       ),
                                       SizedBox(height: 8,),
                                       ExpandableText(
                                         text: supportAnswerListEntity.description??"",
                                         maxChars: 200,
                                       ),
                                       SizedBox(height: 8,),

                                       supportAnswerListEntity.payvast==null?SizedBox():
                                       PayvastSupportFile(url: "${Constants.baseUrl}uploads/support/${supportAnswerListEntity.payvast}")

                                     ],
                                   ),
                                 );

                               },),
                         if(supportDataEntity.status!=3)  BlocBuilder<SupportBloc, SupportState>(builder: (context, state) {
                             return state.answer
                                 ? BlocConsumer<SupportBloc, SupportState>(builder: (context, state) {
                               return Row(
                                 children: [
                                   Expanded(
                                     child: SizedBox(
                                       height: 40.h,

                                       child: TextFormField(
                                         maxLines: 2,
                                         controller: answerController,
                                         decoration: InputDecoration(
                                           prefixIcon:  BlocConsumer<SupportBloc, SupportState>(
                                             listener: (context, state) {
                                               if(state.overImage==true) {
                                                 GlobalSnackBar.show(context, message: "حجم فایل بیشتر از یک مگابایت نباشد.");
                                               }
                                             },
                                             listenWhen: (previous, current) => state.overImage==true,
                                             buildWhen: (previous, current) =>
                                             previous.supportFile != current.supportFile ||
                                                 previous.overImage != current.overImage,
                                             builder: (context, state) {
                                               // print("file${state.supportFile}");
                                               // print("state.overImage${state.overImage}");
                                               return GestureDetector(onTap: () {
                                                 BottomSheets().imageSupport(context, BlocProvider.of<SupportBloc>(context));
                                               }, child: _buildImageContent(state.supportFile,state.overImage));
                                             },
                                           ),


                                           suffixIcon: SizedBox(
                                             width: 90.w,
                                             height: double.infinity,
                                             child: ValueListenableBuilder<TextEditingValue>(
                                               valueListenable: answerController,
                                               builder: (context, value, child) {
                                                 final isTextEmpty = value.text.trim().isEmpty;


                                                 return  GlobalElevatedButton(
                                                   borderRadius: 2.5,
                                                   widget:state.sendAnswerStatus is SendAnswerLoading?
                                                   Center(child: CircularProgressIndicator(),): Text(
                                                     "ارسال",
                                                     style: TextStyle(color: ColorPalette.white),
                                                   ),
                                                   backColor: ColorPalette.darkBlue,
                                                   onTap: isTextEmpty
                                                       ? null
                                                       : () async {
                                                     dynamic file = await ImageConverter.getMultiPart(
                                                         state.supportFile,
                                                         state.supportFile.split("/").last);


                                                     BlocProvider.of<SupportBloc>(context).add(
                                                       SendAnswer(
                                                           SendNewSupportParams(
                                                               description: answerController.text,
                                                               id: supportDataEntity.id,
                                                               payVast:file
                                                           )
                                                       ),
                                                     );
                                                   },
                                                 );
                                               },
                                             ),
                                           ),
                                           hintText: "پیام خود را بنویسید",

                                           errorBorder: InputBorder.none,
                                           disabledBorder: InputBorder.none,
                                         ),
                                       ),
                                     ),
                                   ),
                                 ],
                               );
                             },
                               listenWhen: (previous, current) => previous.sendAnswerStatus!=current.sendAnswerStatus,

                               listener: (context, state) {
                                 if(state.sendAnswerStatus is SendAnswerSuccess){
                                   GlobalSnackBar.show(context, message: "ارسال شد");
                                 }
                                 if(state.sendAnswerStatus is SendAnswerError){
                                   GlobalSnackBar.show(context, message: "خطایی رخ داده");
                                 }

                               },
                             )
                                 : Row(
                               mainAxisAlignment: MainAxisAlignment.end,
                               children: [
                                 BlocConsumer<SupportBloc, SupportState>(
                                   listenWhen: (previous, current) => previous.supportCloseStatus != current.supportCloseStatus,
                                   listener: (context, state) {
                                     if (state.supportCloseStatus is SupportCloseSuccess) {
                                       print("Status is success");

                                       // ۱. ابتدا رویداد جدید را برای دریافت لیست جدید اضافه کنید
                                       // BlocProvider.of<SupportBloc>(context).add(GetSupportMessage(FlowMeterParams(page: 1)));

                                       // ۲. اسنک‌بار را نمایش دهید
                                       GlobalSnackBar.show(context, message: "بسته شد");

                                       // ۳. در صورت نیاز صفحه را ببندید (اگر این ویجت صفحه جزئی است یا باید پاپ شود)
                                       if (Navigator.canPop(context)) {
                                         Navigator.of(context).pop(true);
                                       }
                                     }
                                     if (state.supportCloseStatus is SupportCloseError) {
                                       GlobalSnackBar.show(context, message: "خطایی رخ داده");
                                     }

                                   },
                                   buildWhen: (previous, current) => current.supportStatus != previous.supportStatus || current.supportCloseStatus != previous.supportCloseStatus,
                                   builder: (context, state) {
                                     return GlobalElevatedButton(
                                       borderRadius: 2.5,
                                       backColor: Colors.transparent,
                                       borderColor: ColorPalette.inverseGrey,
                                       widget: Row(
                                         children: [
                                           state.supportCloseStatus is SupportCloseLoading?
                                           Center(child: CircularProgressIndicator(),):
                                           Text("بستن",style: TextStyle(color: ColorPalette.black),),
                                           SizedBox(width: 3.w,),
                                           Icon(Icons.cancel_outlined,color: ColorPalette.black),

                                         ],
                                       ),onTap: () {
                                         BlocProvider.of<SupportBloc>(context).add(SupportClose(supportDataEntity.id!));

                                       },);
                                   },
                                 ),
                                 SizedBox(
                                   width: 10.w,
                                 ),
                                 BlocBuilder<SupportBloc, SupportState>(
                                   buildWhen: (previous, current) => previous.answer!=current.answer,
                                   builder: (context, state) {
                                     return GlobalElevatedButton(
                                       borderRadius: 2.5,
                                       backColor: Colors.transparent,
                                       borderColor: ColorPalette.inverseGrey,
                                       widget: Row(
                                         children: [
                                           Text("پاسخ",style: TextStyle(color: ColorPalette.black),),
                                           SizedBox(width: 3.w,),
                                           Icon(Icons.arrow_circle_left_outlined,color: ColorPalette.black),

                                         ],
                                       ),onTap: () {
                                         BlocProvider.of<SupportBloc>(context).add(ChangeAnswer(!state.answer));

                                       },);
                                   },
                                 ),

                               ],
                             );

                           },),


                         ],
                       ),
                     );
                   }else{
                     return SizedBox();
                   }
                 },),
               ),
             ),

            ],
          ),
        ),
      ),
    );
  }

   Widget _buildImageContent(dynamic image,bool over) {
     if (image.isEmpty || over) {
       return const Icon(
         Icons.attach_file,
         size: 30,
         color: Colors.grey,
       );
     }
     // else if (image.startsWith("http")) {
     //   return Image.network(
     //     image,
     //     fit: BoxFit.cover,
     //     errorBuilder: (context, error, stackTrace) =>
     //     const Icon(Icons.error, color: Colors.red),
     //   );
     // }
     else {
       return Icon(Icons.check);
       // return Image.file(
       //   File(image),
       //   fit: BoxFit.cover,
       //   errorBuilder: (context, error, stackTrace) =>
       //   const Icon(Icons.error, color: Colors.red),
       // );
     }
   }

}

class ExpandableText extends StatefulWidget {
  final String text;
  final int maxChars;

  const ExpandableText({
    super.key,
    required this.text,
    this.maxChars = 100, // حداکثر تعداد کاراکتر قبل از قطع شدن
  });

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    // اگر طول متن کمتر از حد مجاز باشد، کل متن را نشان بده
    if (widget.text.length <= widget.maxChars) {
      return Container(
        width: double.infinity,
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: BoxBorder.all(color: ColorPalette.inverseGrey)
          ),
          child: Text(widget.text,textAlign: TextAlign.right,));
    }

    // برش متن تا تعداد کاراکتر مشخص‌شده
    final displayText = isExpanded
        ? widget.text
        : '${widget.text.substring(0, widget.maxChars)}...';

    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: BoxBorder.all(color: ColorPalette.inverseGrey)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            displayText,
            style: const TextStyle(fontSize: 16),
          ),





          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: Text(
                isExpanded ? 'کمتر' : 'بیشتر',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}