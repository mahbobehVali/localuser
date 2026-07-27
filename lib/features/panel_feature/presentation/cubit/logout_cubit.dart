import 'package:bloc/bloc.dart';

import '../../../../common/utils/sharedpreference.dart';
import '../../../../locator.dart';

// part 'logout_state.dart';

class LogoutCubit extends Cubit<void> {
  LogoutCubit() : super(());

  void logout(){
    locator<SharedPrefOperator>().logout();
  }
}
