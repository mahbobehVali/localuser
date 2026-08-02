import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mahaliii/common/params/flowmeter_params.dart';
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
import 'package:mahaliii/features/support_feature/presentation/bloc/support_status.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:readmore/readmore.dart';
import '../../../../common/utils/constants.dart';
import '../../../../common/widgets/pagination_widget.dart';
import '../../../../locator.dart';
import '../../../alert_feature/domain/entity/alert_type_entity.dart';

class SupportAnswerScreen extends StatelessWidget {
  const SupportAnswerScreen({super.key,required this.supportDataEntity});
  final SupportDataEntity supportDataEntity;
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
               child: BlocBuilder<SupportBloc,SupportState>(builder: (context, state) {
                 if(state.supportAnswersStatus is SupportAnswersLoading){
                   return Center(child: CircularProgressIndicator(),);
                 } if(state.supportAnswersStatus is SupportAnswersError){
                   SupportAnswersError supportAnswersError=state.supportAnswersStatus as SupportAnswersError;
                   return Center(child: Text(supportAnswersError.error));
                 } if(state.supportAnswersStatus is SupportAnswersSuccess){
                   SupportAnswersSuccess supportAnswersSuccess=state.supportAnswersStatus as SupportAnswersSuccess;
                   return  Container(
                     color: Colors.white,
                     padding: EdgeInsets.all(8),
                     child: SingleChildScrollView(
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
                           SizedBox(height: 20.h),
                           Row(
                             mainAxisAlignment: MainAxisAlignment.end,
                             children: [
                               GlobalElevatedButton(backColor: Colors.transparent,
                                 borderColor: ColorPalette.inverseGrey,
                                 widget: Row(
                                   children: [
                                     Text("بستن",style: TextStyle(color: ColorPalette.black),),
                                     SizedBox(width: 3.w,),
                                     Icon(Icons.cancel_outlined,color: ColorPalette.black),

                                   ],
                                 ),onTap: () {

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
                                       BlocProvider.of<SupportBloc>(context).add(ChangeAnswer(!state.answer));

                                     },);
                                 },
                               ),
                               // if(state.answer) Container(
                               //   decoration: BoxDecoration(
                               //       border: BoxBorder.all()
                               //   ),
                               //   child: Text("data"),
                               // )
                             ],
                           )


                         ],
                       ),
                     ),
                   );
                 }else{
                   return SizedBox();
                 }
               },),
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
    Key? key,
    required this.text,
    this.maxChars = 100, // حداکثر تعداد کاراکتر قبل از قطع شدن
  }) : super(key: key);

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