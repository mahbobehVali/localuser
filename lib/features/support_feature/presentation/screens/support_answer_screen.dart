import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mahaliii/common/widgets/global_elevated_button.dart';
import 'package:mahaliii/config/color_palette.dart';
import 'package:mahaliii/config/texts_style.dart';
import 'package:mahaliii/features/support_feature/domain/entity/support_answer_list_entity.dart';
import 'package:mahaliii/features/support_feature/domain/entity/support_data_entity.dart';
import 'package:mahaliii/features/support_feature/domain/usecase/send_support_usecase.dart';
import 'package:mahaliii/features/support_feature/domain/usecase/support_answers_usecase.dart';
import 'package:mahaliii/features/support_feature/domain/usecase/support_usecase.dart';
import 'package:mahaliii/features/support_feature/presentation/bloc/support_answers_status.dart';
import 'package:mahaliii/features/support_feature/presentation/bloc/support_bloc.dart';
import 'package:mahaliii/features/support_feature/presentation/bloc/support_close_status.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../../common/params/send_new_request_to_support_params.dart';
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
      appBar: AppBar(),
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
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(supportDataEntity.subject??"", style: TextStyleP.f16Medium),
              SizedBox(height: 24.h),
             Expanded(
               child: Container(
                 color: Colors.white,
                 padding: EdgeInsets.all(20.sp),
                 child: Column(
                   children: [
                     Expanded(
                       child: BlocBuilder<SupportBloc,SupportState>(builder: (context, state) {
                         if(state.supportAnswersStatus is SupportAnswersLoading){
                           return Center(child: CircularProgressIndicator(),);
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
                                             Text(supportAnswersSuccess.supportAnswerEntity.user!),
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

                                         Container(
                                           width: double.infinity,
                                           padding: EdgeInsets.all(8),
                                           decoration: BoxDecoration(
                                               borderRadius: BorderRadius.circular(4),

                                               border: BoxBorder.all(color: ColorPalette.inverseGrey)
                                           ),
                                           //https://abyarinovin.ir/uploads/support/file-1785157876168-204219303.jpg
                                           child: Center(child: Text("فایل پیوست شده")),

                                         )
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
                                                 Text(supportAnswerListEntity.name??"نامشخص"),
                                                 Text("${supportAnswerListEntity.clock!.toString().toPersianDigit()}     ${supportAnswerListEntity.date!.toString().toPersianDigit()}"),
                                                 // Expanded(child: Text(supportDataEntity.date!)),
                                               ],
                                             ),
                                             SizedBox(height: 8,),
                                             Container(
                                               width: double.infinity,

                                               padding: EdgeInsets.all(8),
                                               decoration: BoxDecoration(
                                                   borderRadius: BorderRadius.circular(4),

                                                   border: BoxBorder.all(color: ColorPalette.inverseGrey)
                                               ),
                                               child: Text(supportAnswerListEntity.description!),

                                             ),

                                           ],
                                         ),
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
                     SizedBox(height: 20.h),
                     BlocBuilder<SupportBloc, SupportState>(builder: (context, state) {
                       print("ff");
                       return state.answer
                           ? Container(
                         width: double.infinity,
                         decoration: BoxDecoration(
                           border: Border.all(), // اصلاح کوچک: Border.all بجای BoxBorder.all
                         ),
                         child: Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Row(
                             children: [
                               Expanded(
                                 child: TextFormField(
                                   controller: answerController,
                                   decoration: const InputDecoration(
                                     hintText: "پیام خود را بنویسید",
                                     border: InputBorder.none,
                                     focusedBorder: InputBorder.none,
                                     enabledBorder: InputBorder.none,
                                     errorBorder: InputBorder.none,
                                     disabledBorder: InputBorder.none,
                                   ),
                                 ),
                               ),
                               // گوش دادن به تغییرات کنترلر فقط برای دکمه ارسال
                               // گوش دادن به تغییرات کنترلر فقط برای دکمه ارسال
                               ValueListenableBuilder<TextEditingValue>(
                                 valueListenable: answerController,
                                 builder: (context, value, child) {
                                   final isTextEmpty = value.text.trim().isEmpty;

                                   return GlobalElevatedButton(
                                     widget: Text(
                                       "ارسال",
                                       style: TextStyle(color: ColorPalette.white),
                                     ),
                                     backColor: ColorPalette.darkBlue,
                                     onTap: isTextEmpty
                                         ? null
                                         : () {
                                       print("supportDataEntity.id ${supportDataEntity.id}");
                                       BlocProvider.of<SupportBloc>(context).add(
                                         SendAnswer(
                                             SendNewSupportParams(
                                                 description: answerController.text,
                                                 id: supportDataEntity.id,
                                                 payVast:null
                                             )
                                         ),
                                       );
                                     },
                                   );
                                 },
                               ),
                             ],
                           ),
                         ),
                       )
                           : Row(
                         mainAxisAlignment: MainAxisAlignment.end,
                         children: [
                           GlobalElevatedButton(backColor: Colors.transparent,
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

                             },),
                           SizedBox(
                             width: 10.w,
                           ),
                           BlocBuilder<SupportBloc, SupportState>(
                             builder: (context, state) {
                               return GlobalElevatedButton(backColor: Colors.transparent,
                                 borderColor: ColorPalette.inverseGrey,
                                 widget: Row(
                                   children: [
                                     Text("پاسخ",style: TextStyle(color: ColorPalette.black),),
                                     SizedBox(width: 3.w,),
                                     Icon(Icons.arrow_circle_left_outlined,color: ColorPalette.black),

                                   ],
                                 ),onTap: () {
                                   print("state.answer${state.answer}");
                                   BlocProvider.of<SupportBloc>(context).add(ChangeAnswer(!state.answer));

                                 },);
                             },
                           ),

                         ],
                       );

                     },),
                   ],
                 ),
               ),
             ),



            ],
          ),
        ),
      ),
    );
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