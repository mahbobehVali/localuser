import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mahaliii/common/utils/constants.dart';
import 'package:mahaliii/common/widgets/global_snackbar.dart';
import 'package:mahaliii/common/widgets/show_dialogs.dart';
import 'package:mahaliii/features/panel_feature/domain/usecase/change_alert_usecase.dart';
import 'package:mahaliii/features/panel_feature/domain/usecase/change_password_usecase.dart';
import 'package:mahaliii/features/panel_feature/domain/usecase/send_sms_usecase.dart';
import 'package:mahaliii/features/panel_feature/presentation/bloc/account_bloc.dart';
import 'package:mahaliii/features/panel_feature/presentation/bloc/send_sms_status.dart';
import 'package:mahaliii/features/panel_feature/presentation/screens/widgets/radio_row.dart';

import '../../../../common/utils/sharedpreference.dart';
import '../../../../common/widgets/account_box.dart';
import '../../../../common/widgets/account_box_title.dart';
import '../../../../config/texts_style.dart';
import '../../../../locator.dart';
import '../../../auth_feature/presentation/screens/login_screen.dart';


class AccountScreen extends StatefulWidget {
   const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen>{

  TextEditingController oldPassword=TextEditingController();
  TextEditingController newPassword=TextEditingController();
  final passwordKey = GlobalKey<FormState>();
  List<dynamic> info=[];
   int radioSelected=3;
  void loadUserData() async {
    // صبر می‌کنیم تا لیست از حافظه خوانده شود
    List<dynamic> userInfo = await locator<SharedPrefOperator>().getUserInformationEntity();
    int selected = await locator<SharedPrefOperator>().getAlertTyp();

    // حالا می‌توانیم از مقادیر استفاده کنیم
    if (userInfo.isNotEmpty ) {
      setState(()  {
        info= userInfo;
        radioSelected=selected;

      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadUserData();

  }

  @override
  Widget build(BuildContext context) {
// اگر هنوز اطلاعات لود نشده، یک لودینگ نشان بده و جلوتر نرو
    if (info.isEmpty && radioSelected==3) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
       appBar:  PreferredSize(
         preferredSize: const Size.fromHeight(70),
         child: Padding(
           padding: const EdgeInsets.all(6),
           child: AppBar(
             automaticallyImplyLeading: false,
              title: Text("حساب کاربری",
                style: TextStyleP.f16Medium,
              ),
              centerTitle: false,
              actions: [
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
         ),
       ),
        body: BlocProvider<AccountBloc>(
        create: (context) {

        AccountBloc accountBloc=AccountBloc(
        locator<SendSmsUseCase>(),
        locator<ChangePasswordUseCase>(),
        locator<ChangeAlertUseCase>(),
    );
      accountBloc.add(ChangeSelectedRadio(radioSelected));
      return accountBloc;
      },
      child: Padding(
          padding: const EdgeInsets.only(left: 8,right:8,bottom: 8,top: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [


                Container(
                  padding: EdgeInsets.all(10),
                  decoration: Constants().whiteFiveRadiusDecoration,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AccountBoxTitle(title: "اطلاعات حساب",titleIcon: "assets/icons/user-tick.png",),
                      AccountBox(title: "نام و نام خانوادگی",name:info.isNotEmpty ? (info[4] ?? "") : "در حال بارگذاری..."),

                      SizedBox(height: 16.h,),

                      AccountBox(title: "کد ملی",name: info.isNotEmpty ? (info[2] ?? "") : "در حال بارگذاری..."),
                      SizedBox(height: 16.h,),

                      AccountBox(title: "شماره تماس",name: info.isNotEmpty ? (info[1] ?? "") : "در حال بارگذاری..."),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: Constants().whiteFiveRadiusDecoration,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AccountBoxTitle(title: "رمز عبور",titleIcon: "assets/icons/Password.png"),
                          BlocBuilder<AccountBloc,AccountState>(
                            buildWhen: (previous, current) => previous.edit!=current.edit,

                            builder: (context, state) {
                           return state.edit?
                           Row(
                             children: [
                               BlocConsumer<AccountBloc, AccountState>(
                                 listenWhen: (previous, current) => previous.sendSmsStatus!=current.sendSmsStatus,
                                listener: (context, state) {

                                  if(state.sendSmsStatus is SendSmsSuccess){
                                    SendSmsSuccess sendSmsSuccess=state.sendSmsStatus as SendSmsSuccess;
                                    ShowDialogs().changePasswordShowDialog(context: context, panelBloc: BlocProvider.of<AccountBloc>(context),
                                        serverId: sendSmsSuccess.serverId,newPass: newPassword.text,previousPass: oldPassword.text);

                                  }
                                  if(state.sendSmsStatus is SendSmsExit){
                                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                                      return LoginScreen();
                                    },));
                                  }

                                  if(state.sendSmsStatus is SendSmsError){
                                    SendSmsError sendSmsError=state.sendSmsStatus as SendSmsError;
                                    GlobalSnackBar.show(context,message: sendSmsError.error);

                                  }
                                },
                                builder: (context, state) {
                                  return state.sendSmsStatus is SendSmsLoading?
                                  Center(child: CircularProgressIndicator(),):
                                  IconButton(onPressed: () {
                                  if(passwordKey.currentState!.validate()){
                                  BlocProvider.of<AccountBloc>(context).add(SendSmsEvent());
                                  }

                                  }, icon: Icon(Icons.check_box_outlined));
                                            },
                                          ),
                               IconButton(onPressed: () {
                                 passwordKey.currentState?.reset();

                                 oldPassword.clear();
                                 newPassword.clear();
                                 BlocProvider.of<AccountBloc>(context).add(ChangeEditEvent(false));

                               }, icon: Icon(Icons.cancel_presentation))
                             ],
                           ):
                           GestureDetector(
                               onTap: () {
                                 BlocProvider.of<AccountBloc>(context).add(ChangeEditEvent(true));
                               },
                               child: Image.asset("assets/icons/edit.png"));

                          },)

                        ],
                      ),
                      Form(
                        key: passwordKey,
                          child: BlocBuilder<AccountBloc, AccountState>(
                            buildWhen: (previous, current) => previous.edit!=current.edit,

                            builder: (context, state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("رمز قبلی"),

                          SizedBox(
                              width: MediaQuery.sizeOf(context).width*0.75,
                              height: 40.h,
                              child: TextFormField(

                                validator: (value) {
                                    if (value==null || value.isEmpty || value.length < 10) {
                                      return "وارد کردن رمز عبور قبلی الزامی است. حداقل ۱۰ کاراکتر";
                                    }

                                  return null;
                                },
                                readOnly: !state.edit,
                                controller: oldPassword,
                              )),
                          SizedBox(height: 16.h),
                          RichText(
                            text: TextSpan(
                              text: 'رمز جدید\n',
                              style: DefaultTextStyle.of(context).style,
                              children: const <TextSpan>[
                                TextSpan(text: '(طول رمز عبور حداقل ۱۰ کاراکتر، شامل حروف بزرگ، کوچک، عدد و کاراکتر خاص باشد)', style: TextStyle(fontSize: 10)),
                              ],
                            ),
                          ),
                          SizedBox(
                              width: MediaQuery.sizeOf(context).width*0.75,
                              height: 40.h,
                              child: TextFormField(
                                validator: (value) {
                                  if (value==null || value.isEmpty || value.length < 10 || !Constants.isPasswordValid(value)) {
                                    return "رمز عبور معتبر نیست";
                                  }
                                  return null;
                                },

                                readOnly: !state.edit,
                                controller: newPassword,
                              )),
                        ],
                      );
                  },
                )),
                      
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: Constants().whiteFiveRadiusDecoration,
                  child: Column(
                    children: [
                      AccountBoxTitle(title: "منطقه مسئولیت",titleIcon: "assets/icons/compass-tool.png",),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: AccountBox(title: "منطقه",name: info.isNotEmpty ? (info[8] ?? "") : "در حال بارگذاری...",)),
                          SizedBox(width: 5,),
                          Expanded(child: AccountBox(title: "ناحیه",name: info.isNotEmpty ? (info[7] ?? "") : "در حال بارگذاری...",)),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16.h),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: Constants().whiteFiveRadiusDecoration,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AccountBoxTitle(title: "هشدارها",titleIcon: "assets/icons/Alert triangle.png"),
                      Text("انتخاب نوع هشدار ارسالی"),
                      SizedBox(height: 24.w),
                      BlocBuilder<AccountBloc,AccountState>(builder: (context, state) {
                        return RadioRow(list: Constants().alert);
                      },)
                    ],
                  ),
                ),
                SizedBox(height: 40.h),

              ],
            ),
          ),
        ),
    ));
  }
}
