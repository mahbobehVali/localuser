import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mahaliii/common/widgets/global_elevated_button.dart';
import 'package:mahaliii/common/widgets/global_snackbar.dart';
import 'package:mahaliii/features/auth_feature/presentation/bloc/login_bloc/forget_clicked_status.dart';
import 'package:mahaliii/features/auth_feature/presentation/screens/forget_password/forget_password_screen.dart';

import '../../../../../locator.dart';
import '../../../domain/usecase/forget_pass_usecase.dart';
import '../../../domain/usecase/get_code_usecase.dart';
import '../../../domain/usecase/login_usecase.dart';
import '../../bloc/login_bloc/login_bloc.dart';

class EnterMobileScreen extends StatefulWidget {

  const EnterMobileScreen({super.key});

  @override
  State<EnterMobileScreen> createState() => _EnterMobileScreenState();
}

class _EnterMobileScreenState extends State<EnterMobileScreen> {

  GlobalKey<FormState> mobileKey = GlobalKey();

  TextEditingController mobileController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    mobileController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (context) {
        return LoginBloc(
          locator<LoginUseCase>(),
          locator<GetCodeUseCase>(),
          locator<ForgetPassUseCase>(),
        );
      },
  child: Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("فراموشی رمز عبور"),
                Text(
                    "برای تغییر رمز عبور خود لطفا شماره تماس خود را وارد نمایید."),
                Form(
                    key: mobileKey,
                    child: TextFormField(
                      controller: mobileController,
                    )),
                BlocConsumer<LoginBloc, LoginState>(
                  listener: (context, state) {
                    if(state.forgetClickedStatus is ForgetClickedSuccess){
                      ForgetClickedSuccess forgetClickedSuccess=state.forgetClickedStatus as ForgetClickedSuccess;
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return ForgetPasswordScreen(serverId: forgetClickedSuccess.code,mobile: mobileController.text);
                        },));
                    }
                    if(state.forgetClickedStatus is ForgetClickedError){
                      ForgetClickedError forgetClickedError=state.forgetClickedStatus as ForgetClickedError;
                     GlobalSnackBar.show(context,message: forgetClickedError.error);
                    }
                  },
                  builder: (context, state) {
                    return GlobalElevatedButton(
                      width: double.infinity,

                      widget: state.forgetClickedStatus is ForgetClickedLoading?Center(child:CircularProgressIndicator()):
                        Text("دریافت کد اعتبار سنجی",style: TextStyle(color: Colors.white),),
                      backColor: Color(0xff5F8CC5),
                      onTap: () {
                        if (mobileKey.currentState!.validate()) {
                          print(mobileController.text);
                          BlocProvider.of<LoginBloc>(context).add(ForgetClicked(mobileController.text));
                        }
                      },);
                  },
                )
              ],
            ),
          )),
    ),
);
  }
}
