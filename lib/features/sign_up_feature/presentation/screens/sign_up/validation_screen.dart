import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mahaliii/common/params/sign_up_params.dart';
import 'package:mahaliii/common/widgets/refuse_button.dart';
import 'package:mahaliii/features/sign_up_feature/domain/entity/area_entity.dart';
import 'package:mahaliii/features/sign_up_feature/presentation/bloc/region_status.dart';
import 'package:mahaliii/features/sign_up_feature/presentation/bloc/register_status.dart';
import 'package:mahaliii/features/sign_up_feature/presentation/bloc/validation_status.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../../../common/widgets/global_elevated_button.dart';
import '../../../../../common/widgets/show_snack_bar.dart';
import '../../../../../config/color_palette.dart';
import '../../../../../config/texts_style.dart';
import '../../../../alert_feature/domain/entity/alert_type_entity.dart';
import '../../../../auth_feature/presentation/screens/login_screen.dart';
import '../../../domain/entity/region_entity.dart';
import '../../bloc/again_validation_status.dart';
import '../../bloc/area_status.dart';
import '../../bloc/sign_up_bloc.dart';

class ValidationScreen extends StatefulWidget {
  const ValidationScreen({super.key, required this.pageController});
  final PageController pageController;

  @override
  State<ValidationScreen> createState() => _ValidationScreenState();
}

class _ValidationScreenState extends State<ValidationScreen> {
  GlobalKey<FormState> signUpFormKey = GlobalKey();

  TextEditingController passController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  Timer? _timer; // تغییر از late به Nullable
    int _remainingSeconds = 120;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel(); // استفاده از ? برای جلوگیری از خطا در صورت null بودن
    super.dispose();
    passController.dispose();
    codeController.dispose();
  }

  void _startCountdown() {
    // ۱. اگر تایمر قبلی وجود داشت و فعال بود، آن را متوقف کن
    _timer?.cancel();

    // ۲. مقداردهی اولیه ثانیه‌ها و آپدیت UI
    setState(() {
      _remainingSeconds = 120;
    });

    // ۳. ساخت تایمر جدید
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(automaticallyImplyLeading: false),
          body: LayoutBuilder(builder: (context, constraints) {
            return SingleChildScrollView(
              child:ConstrainedBox(
                  constraints: BoxConstraints(
                    // تعیین حداقل ارتفاع محتوا به اندازه ارتفاع موجود در صفحه
                    minHeight: constraints.maxHeight,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: 30.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          "لطفا کد تایید پیامک شده را در کادر زیر وارد نمایید.",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 30.h),

                        Form(
                          key: signUpFormKey,
                          child: TextFormField(
                            controller: codeController,
                          ),
                        ),

                        SizedBox(
                          height: 10.h,
                        ),
                        BlocConsumer<SignUpBloc, SignUpState>(
                          listener: (BuildContext context, SignUpState state) {
                            if (state.againSendValidationStatus
                            is AgainSendValidationSuccess) {
                              AgainSendValidationSuccess againSendValidationSuccess=state.againSendValidationStatus as AgainSendValidationSuccess;
                              print("againSendValidationSuccess.id${againSendValidationSuccess.id}");

                              ShowSnacksBars.snack(context, "کد اعتبارسنجی ارسال شد",color: Colors.green);
                            }

                            if (state.againSendValidationStatus
                            is AgainSendValidationError) {
                              AgainSendValidationError againSendValidationError = state
                                  .againSendValidationStatus as AgainSendValidationError;
                              ShowSnacksBars.snack(context, againSendValidationError.error, duration: 1);
                            }
                          },
                          buildWhen: (previous, current) {
                            if (previous.againSendValidationStatus ==
                                current.againSendValidationStatus) {
                              return false;
                            }
                            return true;
                          },
                          listenWhen:(previous, current) => previous.againSendValidationStatus != current.againSendValidationStatus,
                          builder: (context, state) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                    onTap: _remainingSeconds > 0 || state.againSendValidationStatus is AgainSendValidationLoading
                                        ? null
                                        : () {
                                      BlocProvider.of<SignUpBloc>(context).add(
                                        AgainSendValidationButtonClicked(),
                                      );
                                      _startCountdown();

                                    },
                                    child: Text("دریافت مجدد رمز عبور",style: TextStyle(color:
                                    _remainingSeconds > 0 || state.againSendValidationStatus is AgainSendValidationLoading?
                                    ColorPalette.grey:ColorPalette.darkBlue),)),
                                _remainingSeconds > 0
                                    ? Text(
                                  "${_remainingSeconds.toString().toPersianDigit()} ثانیه",
                                  style: const TextStyle(fontSize: 14),
                                ): const SizedBox(),
                              ],
                            );
                          },
                        ),

                        SizedBox(
                          height: 30.h,
                        ),
                        BlocConsumer<SignUpBloc, SignUpState>(
                          listenWhen: (previous, current) => previous.sendValidationStatus!=current.sendValidationStatus,
                          listener: (BuildContext context, SignUpState state) {
                            if (state.sendValidationStatus is SendValidationSuccess) {
                              widget.pageController.nextPage(

                                duration: Duration(milliseconds: 5),
                                curve: Curves.bounceIn,
                              );
                            }
                            if (state.sendValidationStatus is SendValidationError) {
                              SendValidationError registerError = state.sendValidationStatus as SendValidationError;
                              ShowSnacksBars.snack(context, registerError.error);
                            }
                          },

                          builder: (context, state) {
                            return GlobalElevatedButton(
                              width: double.infinity,
                              backColor: ColorPalette.darkBlue,
                              onTap: () async {
                                if (signUpFormKey.currentState!.validate()) {

                                  BlocProvider.of<SignUpBloc>(context).add(
                                    SendValidation(
                                        state.signUpParams.copyWith(

                                          newServerId: state.serverId,
                                          newCode: int.parse(codeController.text.toString().toEnglishDigit()),
                                            newStep: state.step!+1
                                        )
                                    ),
                                  );
                                }
                              },
                              widget: state.registerStatus is RegisterLoading
                                  ? const CircularProgressIndicator()
                                  : Text("تایید", style: TextStyleP.colorBlack),
                            );
                          },
                        ),
                        RefuseButton(
                          text: "برگشت",

                          width: double.infinity,
                          onTap: () {
                            widget.pageController.previousPage(

                              duration: Duration(milliseconds: 5),
                              curve: Curves.bounceIn,
                            );
                          },)
                      ],
                    ),
                  )
              ),
            );
          },));
  }
}
