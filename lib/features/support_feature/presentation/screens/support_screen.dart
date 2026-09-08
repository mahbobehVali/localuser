import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mahaliii/common/params/flowmeter_params.dart';
import 'package:mahaliii/common/widgets/shimmer_class.dart';
import 'package:mahaliii/config/color_palette.dart';
import 'package:mahaliii/config/texts_style.dart';
import 'package:mahaliii/features/support_feature/domain/entity/support_data_entity.dart';
import 'package:mahaliii/features/support_feature/domain/usecase/send_answer_usecase.dart';
import 'package:mahaliii/features/support_feature/domain/usecase/send_support_usecase.dart';
import 'package:mahaliii/features/support_feature/domain/usecase/support_answers_usecase.dart';
import 'package:mahaliii/features/support_feature/domain/usecase/support_usecase.dart';
import 'package:mahaliii/features/support_feature/presentation/bloc/support_bloc.dart';
import 'package:mahaliii/features/support_feature/presentation/bloc/support_close_status.dart';
import 'package:mahaliii/features/support_feature/presentation/bloc/support_status.dart';
import 'package:mahaliii/features/support_feature/presentation/screens/support_answer_screen.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../../common/utils/constants.dart';
import '../../../../common/widgets/pagination_widget.dart';
import '../../../../common/widgets/show_dialogs.dart';
import '../../../../locator.dart';
import '../../../alert_feature/domain/entity/alert_type_entity.dart';
import '../../../auth_feature/presentation/screens/login_screen.dart';
import '../../domain/usecase/support_close_usecase.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) {
          SupportBloc supportBloc = SupportBloc(
            locator<SupportUseCase>(),
            locator<SupportAnswersUseCase>(),
            locator<SendSupportUseCase>(),
            locator<SendAnswerUseCase>(),
            locator<SupportCloseUseCase>(),
          );
          supportBloc.add(GetSupportMessage(FlowMeterParams(page: 1)));
          return supportBloc;
        },
        child: Padding(
          padding: EdgeInsets.only(left: 16.w,right: 16.w,top: 50.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("پشتیبانی", style: TextStyleP.f16Medium),
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
              SizedBox(height: 16.h),
               Text("ثبت درخواست جدید",style: TextStyleP.f16Bold),
              SizedBox(height: 16.h),
              Row(
                children: List.generate(
                  2,
                      (index) {
                    return Expanded(
                      child: Builder(
                        builder: (context) {
                          return GestureDetector(
                            onTap: () {
                              ShowDialogs().sendRequestToSupport(
                                context,
                                BlocProvider.of<SupportBloc>(context),
                                AlertTypeEntity(
                                  Constants().rowSupport[index]["title"],
                                  Constants().rowSupport[index]["part"],
                                ),
                              );
                            },
                            child: Container(
                              height: 70.h,
                              margin: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: ColorPalette.lightBlue,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Constants().rowSupport[index]["icon"],
                                  Text(Constants().rowSupport[index]["title"]),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              // استفاده از Expanded برای پر کردن باقی‌مانده صفحه
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    color: ColorPalette.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text("پیام‌های ارسال شده در پشتیبانی", style: TextStyleP.f12Regular),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: BlocBuilder<SupportBloc, SupportState>(
                            buildWhen: (previous, current) => current.selectedSupportStatus!=previous.selectedSupportStatus,
                            builder: (context, state) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Colors.grey),
                                ),
                                width: MediaQuery.sizeOf(context).width / 2,
                                alignment: Alignment.center,
                                child: DropdownButton<AlertTypeEntity>(
                                  underline: const SizedBox(),
                                  isExpanded: true,
                                  iconEnabledColor: ColorPalette.black,
                                  iconDisabledColor: ColorPalette.black,
                                  padding: EdgeInsets.only(right: 15.w),
                                  value: state.supportStatusList[state.selectedSupportStatus],
                                  items: state.supportStatusList
                                      .map((alertType) => DropdownMenuItem<AlertTypeEntity>(
                                    value: alertType,
                                    child: Text(alertType.name),
                                  ))
                                      .toList(),
                                  onChanged: (value) {
                                    BlocProvider.of<SupportBloc>(context)
                                        .add(OneSupportStatusClicked(value!));
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 10.h),
                        // بخش اصلی محتوا که فضای باقی‌مانده را تا Pagination پر می‌کند
                        Expanded(
                          child: Container(
                            decoration: Constants().whiteFiveRadiusDecoration,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: BlocConsumer<SupportBloc, SupportState>(
                                listener: (context, state) {

                                  if(state.supportStatus is SupportExit){
                                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                                      return LoginScreen();
                                    },));
                                  }
                                },
                                buildWhen: (previous, current) => current.supportStatus != previous.supportStatus,
                                builder: (context, state) {
                                  if (state.supportStatus is SupportSuccess) {
                                    SupportSuccess supportSuccess = state.supportStatus as SupportSuccess;

                                    return Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // چسباندن Pagination به ته
                                      children: [
                                        // لیست جداول داخل Expanded قرار گرفت تا فضای خالی را پر کند
                                        Expanded(
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: SizedBox(
                                              width: 500,
                                              child: ListView.builder(
                                                padding: EdgeInsets.zero,
                                                itemCount: supportSuccess.supportEntity.data!.length + 1,
                                                itemBuilder: (context, index) {
                                                  List<SupportDataEntity> data = [];
                                                  if (index > 0) data = supportSuccess.supportEntity.data!;

                                                  return index == 0
                                                      ? Container(
                                                    padding: const EdgeInsets.all(12),
                                                    decoration: Constants().boxDecoration,
                                                    child: const Row(
                                                      children: [
                                                        Expanded(flex: 4, child: Text("نوع پشتیبانی", textAlign: TextAlign.center)),
                                                        Expanded(flex: 2, child: Text("تاریخ", textAlign: TextAlign.center)),
                                                        Expanded(flex: 3, child: Text("ساعت", textAlign: TextAlign.center)),
                                                        Expanded(flex: 4, child: Text("موضوع", textAlign: TextAlign.center)),

                                                        Expanded(flex: 4, child: Text("وضعیت", textAlign: TextAlign.center)),
                                                      ],
                                                    ),
                                                  )
                                                      : GestureDetector(
                                                    onTap: () async {
                                                      // در صفحه والد هنگام باز کردن این صفحه/دیالوگ:
                                                      final result = await Navigator.push(
                                                        context,
                                                        MaterialPageRoute(builder: (context) => SupportAnswerScreen(supportDataEntity: data[index - 1],)),
                                                      );

                                                            // اگر عملیات موفق بود، ایونت را در صفحه والد صدا بزنید
                                                      if (result == true) {
                                                        BlocProvider.of<SupportBloc>(context).add(GetSupportMessage(FlowMeterParams(page: 1)));
                                                      }
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets.all(12),
                                                      decoration: const BoxDecoration(
                                                        border: Border(bottom: BorderSide(color: Color(0xffD7D7D7))),
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            flex: 4,
                                                            child: Text(data[index - 1].part == 1 ? "درخواست به مدیر" : "پشتیبانی دستگاه", textAlign: TextAlign.center),
                                                          ),
                                                          Expanded(flex: 2, child: Text(data[index - 1].clock?.toPersianDigit() ?? "", textAlign: TextAlign.center)),
                                                          Expanded(flex: 3, child: Text(data[index - 1].date?.toPersianDigit() ?? "", textAlign: TextAlign.center)),
                                                          Expanded(flex: 4, child: Text(data[index - 1].subject.toString().toPersianDigit(), textAlign: TextAlign.center)),

                                                          Expanded(
                                                            flex: 4,
                                                            child: Container(
                                                              padding: const EdgeInsets.all(5),
                                                              decoration: BoxDecoration(
                                                                color:
                                                                    data[index - 1].status == 0
                                                                    ? ColorPalette.lightBlue
                                                                    : data[index - 1].status == 1
                                                                    ? Colors.yellow
                                                                    : data[index - 1].status == 2
                                                                    ? ColorPalette.lightGreen
                                                                    : ColorPalette.lightGrey,
                                                                borderRadius: BorderRadius.circular(5),
                                                              ),
                                                              child: Text(
                                                                data[index - 1].status == 0
                                                                    ? "جدید"
                                                                    : data[index - 1].status == 1
                                                                    ? "در حال بررسی"
                                                                    : data[index - 1].status == 2
                                                                    ? "پاسخ داده شده"
                                                                    : "بسته شده",
                                                                textAlign: TextAlign.center,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                        // این ویجت حالا همیشه در انتهای باکس باقی می‌ماند
                                        Padding(
                                          padding: EdgeInsets.only(top: 8.h),
                                          child: PaginationWidget(
                                            selected: state.selectedSupportPage,
                                            lastPage: supportSuccess.supportEntity.meta!.lastPage!,
                                            onPageChanged: (newPage) {
                                              BlocProvider.of<SupportBloc>(context).add(
                                                GetSupportMessage(
                                                  FlowMeterParams(
                                                    page: newPage,
                                                    status: state.selectedSupportStatus,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  } else if (state.supportStatus is SupportLoading) {
                                    return ShimmerClass.shimmerListviewVertical(height: 50);
                                  } else if (state.supportStatus is SupportAgainLoading) {
                                    return const Center(
                                      child: SizedBox(),
                                    );
                                  } else if (state.supportStatus is SupportEmpty) {
                                    return const SizedBox(
                                      height: 150,
                                      child: Center(child: Text("پیامی وجود ندارد")),
                                    );
                                  } else if (state.supportStatus is SupportError) {
                                    SupportError alertError = state.supportStatus as SupportError;
                                    return Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Text(alertError.error),
                                      ),
                                    );
                                  } else {
                                    return const SizedBox.shrink();
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }
}