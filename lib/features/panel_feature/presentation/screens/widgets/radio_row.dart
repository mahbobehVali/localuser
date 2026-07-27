import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/widgets/global_snackbar.dart';
import '../../bloc/account_bloc.dart';
import '../../bloc/change_alert_status.dart';

class RadioRow extends StatelessWidget {
 const RadioRow({
    super.key,
    required this.list,
  });
  final List<dynamic> list;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountBloc, AccountState>(
      buildWhen: (previous, current) =>
      previous.changeAlertStatus != current.changeAlertStatus ||
          previous.selectedRadio != current.selectedRadio,

      listenWhen: (previous, current) =>
      previous.changeAlertStatus != current.changeAlertStatus &&
          (current.changeAlertStatus is ChangeAlertSuccess ||
              current.changeAlertStatus is ChangeAlertError),
      listener: (context, state) {
        if(state.changeAlertStatus is ChangeAlertSuccess){
          ChangeAlertSuccess changeAlertSuccess=state.changeAlertStatus as ChangeAlertSuccess;
          GlobalSnackBar.show(context,message: changeAlertSuccess.message);

        }
        if(state.changeAlertStatus is ChangeAlertError){
          ChangeAlertError changeAlertError=state.changeAlertStatus as ChangeAlertError;
          GlobalSnackBar.show( context,message: changeAlertError.error);


        }
      },
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          children: List.generate(list.length, (index) {
            return RadioMenuButton(
              value:list[index]["id"],
              groupValue: state.selectedRadio,
              onChanged: (value) {
                BlocProvider.of<AccountBloc>(context).add(ChangeAlert(value!));
              },
              child: Text(list[index]["title"]),
            );
          },),
        );
      },
    );
  }
}