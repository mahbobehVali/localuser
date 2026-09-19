import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';

import '../common/socket_repository.dart';
import 'on_off_wrapper_status.dart';

part 'wrapper_event.dart';
part 'wrapper_state.dart';

class WrapperBloc extends Bloc<WrapperEvent, WrapperState> {
  SocketRepository socketRepository;
  WrapperBloc(this.socketRepository) : super(WrapperState(onOffWrapperStatus: OnOffWrapperInitial(),isSwitched: false,nav: 0)) {
    on<AutoWrapperSwitchChange>((event, emit) async {
      print("AutoSwitchChange");
      // اگر از قبل متصل هستیم و فقط می‌خواهیم دیتا بگیریم، لودینگ نشان ندهیم
      // if (state.onOffStatus is! OnOffSuccess) {
      //   emit(state.copyWith(newOnOffStatus: OnOffSuccess()));
      // }
      // ارسال درخواست مخصوص این صفحه
      // emit(state.copyWith(newOnOffStatus: OnOffLoading()));

      // socketRepository.onAndOff(event.createTimeParams);


      // ۲. مدیریت استریم با emit.forEach
      await emit.forEach<dynamic>(
        socketRepository.onAndOffTimeStream,
        onData: (onOff) {
          print("Socket Data Received: $onOff");
          final newIsSwitched = (onOff["status"] == 1);

          // اگر وضعیت سوکت دقیقاً با وضعیت فعلی isSwitched در BLoC یکی باشد،
          // هیچ تغییر استیتی فرستاده نمی‌شود تا اسنک‌بار بی‌مورد اجرا نشود.
          if (newIsSwitched == state.isSwitched && state.onOffWrapperStatus is OnOffWrapperSuccess) {
            return state;
          }

          return state.copyWith(
            newIsSwitched: newIsSwitched,
            newOnOffWrapperStatus: OnOffWrapperSuccess(onOff),
          );
        },
        onError: (error, stackTrace) {
          return state.copyWith(
            newOnOffWrapperStatus: OnOffWrapperError(error.toString()),
          );
        },
      );

    },
      transformer: concurrent(),);

    on<ChangeNav>((event, emit) async {
      emit(state.copyWith(newNav: event.value));

    });
  }
}
