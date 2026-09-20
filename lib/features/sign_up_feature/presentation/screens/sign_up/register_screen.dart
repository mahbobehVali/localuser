import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mahaliii/common/params/change_alert_params.dart';
import 'package:mahaliii/common/params/sign_up_params.dart';
import 'package:mahaliii/common/widgets/refuse_button.dart';
import 'package:mahaliii/features/sign_up_feature/domain/entity/area_entity.dart';
import 'package:mahaliii/features/sign_up_feature/presentation/bloc/region_status.dart';
import 'package:mahaliii/features/sign_up_feature/presentation/bloc/register_status.dart';

import '../../../../../common/utils/constants.dart';
import '../../../../../common/widgets/global_elevated_button.dart';
import '../../../../../common/widgets/show_snack_bar.dart';
import '../../../../../config/color_palette.dart';
import '../../../../../config/texts_style.dart';
import '../../../../alert_feature/domain/entity/alert_type_entity.dart';
import '../../../../auth_feature/presentation/screens/login_screen.dart';
import '../../../domain/entity/region_entity.dart';
import '../../bloc/area_status.dart';
import '../../bloc/sign_up_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, required this.pageController});
  final PageController pageController;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  GlobalKey<FormState> signUpFormKey = GlobalKey();

  TextEditingController passController = TextEditingController();
  TextEditingController codeController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    passController.dispose();
    codeController.dispose();
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

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("نوع مسئولیت"),
                            SizedBox(height: 8.h),
                            BlocBuilder<SignUpBloc, SignUpState>(
                              // buildWhen: (previous, current) =>
                              // current.selectedAlertType!=previous.selectedAlertType,

                              builder: (context, state) {

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          border: Border.all(color: Colors.grey)),
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      child:
                                      DropdownButton<AlertTypeEntity>(
                                          hint: const Text("لطفا یک مورد را انتخاب کنید"),
                                          underline: const SizedBox(),
                                          isExpanded: true,
                                          padding: EdgeInsets.only(right: 15.w),
                                          value: (state.selectedResponsibility != null &&
                                              state.selectedResponsibility! < state.responsibilityList.length)
                                              ? state.responsibilityList[state.selectedResponsibility!]
                                              : null,
                                          items: state.responsibilityList
                                              .map((alertType) =>
                                              DropdownMenuItem<AlertTypeEntity>(
                                                value: alertType,
                                                child: Text(alertType.name),
                                              ))
                                              .toList(),
                                          onChanged: (value) {
                                            BlocProvider.of<SignUpBloc>(context)
                                                .add(ResponsibilityChanged(value!));
                                          }),
                                    ),
                                    Visibility(
                                        visible: state.changeAlertParams.res,

                                        child: Text("لطفاً مسئولیت خود را انتخاب کنید")),
                                  ],
                                );
                              },
                            ),

                            SizedBox(height: 10.h),

                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("انتخاب منطقه"),
                                      SizedBox(height: 8.h),
                                      Container(
                                        height: 40.h,
                                        padding: const EdgeInsets.symmetric(horizontal: 5),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          border: Border.all(color: Colors.grey),
                                        ),
                                        width: double.infinity,
                                        alignment: Alignment.center,
                                        child: BlocBuilder<SignUpBloc, SignUpState>(
                                          builder: (context, state) {
                                            if (state.regionStatus is RegionSuccess) {
                                              RegionSuccess regionSuccess = state.regionStatus as RegionSuccess;

                                              // ۱. در ابتدا مقدار پیش‌فرض را روی null قرار می‌دهیم
                                              int? regionIndex;

                                              if (state.oneRegionEntity != null) {
                                                final foundIndex = regionSuccess.regionEntity.indexWhere(
                                                        (element) => element.id == state.oneRegionEntity!.id);
                                                // اگر آیتم مورد نظر پیدا شد، ایندکس آن را ست می‌کنیم، در غیر این صورت همان null می‌ماند
                                                if (foundIndex != -1) {
                                                  regionIndex = foundIndex;
                                                }
                                              }

                                              return DropdownButton<RegionEntity>(
                                                underline: const SizedBox(),
                                                isExpanded: true,
                                                padding: EdgeInsets.only(right: 15.w),

                                                // متن راهنما وقتی هنوز چیزی انتخاب نشده است
                                                // hint: const Text("یک منطقه را انتخاب کنید"),

                                                // ۲. اگر ایندکس null بود، value هم null می‌شود و چیزی انتخاب نخواهد شد
                                                value: regionIndex != null ? regionSuccess.regionEntity[regionIndex] : null,

                                                items: regionSuccess.regionEntity
                                                    .map((region) => DropdownMenuItem<RegionEntity>(
                                                  value: region,
                                                  child: Text(region.name!.toString()),
                                                ))
                                                    .toList(),
                                                onChanged: (value) {
                                                  BlocProvider.of<SignUpBloc>(context)
                                                      .add(OneRegionClicked(value!));
                                                },
                                              );
                                            } else if (state.regionStatus is RegionLoading) {
                                              return const Center(child: CircularProgressIndicator());
                                            } else if (state.regionStatus is RegionError) {
                                              RegionError regionError = state.regionStatus as RegionError;
                                              return Center(child: Text(regionError.error));
                                            } else {
                                              return const SizedBox();
                                            }
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20.h,
                                        child: BlocBuilder<SignUpBloc, SignUpState>(builder: (context, state) {
                                          return state.changeAlertParams.region?Text("لطفا منطقه را انتخاب کنید"):
                                          SizedBox();
                                        },),
                                      )



                                    ],
                                  ),
                                ),
                                SizedBox(width: 10.w,),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,

                                    children: [

                                      Text("انتخاب ناحیه"),
                                      SizedBox(height: 8.h),
                                      Container(
                                        height: 40.h,
                                        padding: const EdgeInsets.symmetric(horizontal: 5),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          border: Border.all(color: Colors.grey),
                                        ),
                                        width: double.infinity,
                                        alignment: Alignment.center,
                                        child: BlocBuilder<SignUpBloc, SignUpState>(
                                          builder: (context, state) {
                                            if(state.areaStatus is AreaSuccess){
                                              AreaSuccess areaSuccess=state.areaStatus as AreaSuccess;
                                              if (areaSuccess.areaEntity.isEmpty) {
                                                return const Center(
                                                  child: Text(
                                                    "ناحیه ای برای این انتخاب وجود ندارد",
                                                    style: TextStyle(color: Colors.grey),
                                                  ),
                                                );
                                              }
                                              // ۱. در ابتدا مقدار پیش‌فرض را روی null قرار می‌دهیم
                                              int? regionIndex;

                                              if (state.oneAreaEntity != null) {
                                                final foundIndex = areaSuccess.areaEntity.indexWhere(
                                                        (element) => element.id == state.oneAreaEntity!.id);
                                                // اگر آیتم مورد نظر پیدا شد، ایندکس آن را ست می‌کنیم، در غیر این صورت همان null می‌ماند
                                                if (foundIndex != -1) {
                                                  regionIndex = foundIndex;
                                                }
                                              }

                                              return DropdownButton<AreaEntity>(
                                                  underline: const SizedBox(),
                                                  isExpanded: true,
                                                  padding: EdgeInsets.only(right: 15.w),
                                                  value: regionIndex != null ? areaSuccess.areaEntity[regionIndex] : null,

                                                  items:  areaSuccess.areaEntity
                                                      .map((area) =>
                                                      DropdownMenuItem<AreaEntity>(
                                                        value: area,
                                                        child:
                                                        Text(area.name!.toString()),
                                                      ))
                                                      .toList(),
                                                  onChanged: (value) {
                                                    BlocProvider.of<SignUpBloc>(context)
                                                        .add(OneAreaClicked(value!));
                                                  });
                                            }else if (state.areaStatus is AreaLoading){
                                              return Center(child: CircularProgressIndicator(),);
                                            }else if (state.areaStatus is AreaError){
                                              AreaError areaError=state.areaStatus as AreaError;
                                              return Center(child: Text(areaError.error));
                                            }else {
                                              return SizedBox();
                                            }
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20.h,
                                        child: BlocBuilder<SignUpBloc, SignUpState>(builder: (context, state) {
                                         return state.changeAlertParams.area?Text("لطفا ناحیه را انتخاب کنید"):
                                          SizedBox();
                                        },),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),

                            SizedBox(height: 8.h),

                            RichText(
                              text: TextSpan(
                                text: 'رمز عبور\n',
                                style: DefaultTextStyle.of(context).style,
                                children: const <TextSpan>[
                                  TextSpan(text: '(طول رمز عبور حداقل ۱۰ کاراکتر، شامل حروف بزرگ، کوچک، عدد و کاراکتر خاص باشد)', style: TextStyle(fontSize: 10)),
                                ],
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Form(
                              key: signUpFormKey,
                              child: TextFormField(
                                controller: passController,
                                validator: (value) {
                                  if (value==null || value.isEmpty || value.length < 10 || !Constants.isPasswordValid(value)) {
                                    return "رمز عبور معتبر نیست";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 30.h,
                            ),
                            BlocConsumer<SignUpBloc, SignUpState>(
                              listener: (BuildContext context, SignUpState state) {
                                if (state.registerStatus is RegisterComplete) {
                                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) {
                                    return LoginScreen();
                                  },), (route) => false);
                                }
                                if (state.registerStatus is RegisterError) {
                                  RegisterError registerError = state.registerStatus as RegisterError;
                                  ShowSnacksBars.snack(context, registerError.error);
                                }
                              },

                              builder: (context, state) {
                                return GlobalElevatedButton(
                                  borderRadius: 5,
                                  width: double.infinity,
                                  backColor: ColorPalette.darkBlue,
                                  onTap: () async {

                                    if (signUpFormKey.currentState!.validate()) {
                                      // ۱. بررسی وضعیت هر سه فیلد در همان لحظه
                                      bool isResError = state.selectedResponsibility == null;
                                      bool isRegionError = state.oneRegionEntity == null;
                                      bool isAreaError = state.oneAreaEntity == null;

                                      bool hasError = isResError || isRegionError || isAreaError;

                                      // ۲. اگر خطایی وجود داشت، همه را یکجا با هم روی استیت اعمال می‌کنیم
                                      if (hasError) {
                                        print("fdsf${state.selectedResponsibility}");
                                        BlocProvider.of<SignUpBloc>(context).add(
                                          ChangeParams(
                                            state.changeAlertParams.copyWith(
                                              newRes: isResError,
                                              newRegion: isRegionError,
                                              newArea: isAreaError,
                                            ),
                                          ),
                                        );
                                        return; // توقف اجرای کد
                                      }

                                      // ۳. اگر همه چیز پر شده بود، ثبت‌نام انجام می‌شود و خطاها ریست می‌شوند
                                      BlocProvider.of<SignUpBloc>(context)
                                        ..add(
                                          RegisterClicked(
                                            SignUpParams(
                                              password: passController.text,
                                              areaId: state.oneAreaEntity!.id,
                                              type: state.selectedResponsibility!,
                                              mobile: state.signUpParams.mobile,
                                              serverId: state.signUpParams.serverId,
                                              nationalCode: state.signUpParams.nationalCode,
                                              name: state.signUpParams.name,
                                              code: state.signUpParams.code,
                                            ),
                                          ),
                                        )
                                        ..add(
                                          ChangeParams(
                                             ChangeAlertParams(res: false, region: false, area: false),
                                          ),
                                        );
                                    }
                                  },
                                  widget: state.registerStatus is RegisterLoading
                                      ? const CircularProgressIndicator()
                                      : Text("تکمیل ثبت نام", style: TextStyleP.colorBlack),
                                );
                              },
                            ),
                            RefuseButton(
                              width: double.infinity,
                              borderRadius: 5,
                              onTap: () {
                              widget.pageController.previousPage(

                                duration: Duration(milliseconds: 5),
                                curve: Curves.bounceIn,
                              );
                            },)

                          ],
                        ),
                      ],
                    ),
                  )
              ),
            );
          },));
  }
}
