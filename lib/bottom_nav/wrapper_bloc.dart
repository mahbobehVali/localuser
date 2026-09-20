import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';

import '../common/socket_repository.dart';
import '../features/status_summary_feature/domain/entity/wells_entity.dart';
import 'on_off_wrapper_status.dart';

part 'wrapper_event.dart';
part 'wrapper_state.dart';

class WrapperBloc extends Bloc<WrapperEvent, WrapperState> {
  SocketRepository socketRepository;
  WrapperBloc(this.socketRepository) : super(WrapperState(onOffWrapperStatus: OnOffWrapperInitial(),
      isSwitched: null,nav: 0, wellsStatusMap: {},wells: [])) {
    on<AutoWrapperSwitchChange>((event, emit) async {
      print("AutoSwitchChange");

      // ۲. مدیریت استریم با emit.forEach
      await emit.forEach<dynamic>(
        socketRepository.onAndOffTimeStream,
        onData: (onOff) {
          final int socketWellId = onOff.deviceId; // یا onOff['well_id']
          final int newStatus = onOff.status;
          print("Socket Data Received: $onOff");
          final updatedWells = state.wells.map((well) {
            if (well.data?.deviceId == socketWellId) {
              // تغییر وضعیت فقط برای چاهی که well_id آن برابر با سوکت است
              well.data?.statusWell = newStatus;
            }
            return well;
          }).toList();

          final newIsSwitched = (newStatus == 1);

          // اگر وضعیت سوکت دقیقاً با وضعیت فعلی isSwitched در BLoC یکی باشد،
          // هیچ تغییر استیتی فرستاده نمی‌شود تا اسنک‌بار بی‌مورد اجرا نشود.
          if (newIsSwitched == state.isSwitched && state.onOffWrapperStatus is OnOffWrapperSuccess) {
            return state;
          }

          return state.copyWith(
            newIsSwitched: newIsSwitched,
              newWells: updatedWells,
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

    // // ۱. هندلر مقداردهی اولیه
    // on<SetInitialWellsEvent>((event, emit) {
    //   final Map<int, bool> newMap = {};
    //
    //   for (var well in event.wellsList) {
    //     // مثلاً فیلد id و status اولیه چاه
    //     newMap[well.data!.deviceId!] = well.data!.statusWell==1 ;
    //   }
    //
    //   emit(state.copyWith(newWellsStatusMap: newMap));
    // });

    on<SetInitialWellsEvent>((event, emit) {
      print("SetInitialWellsEvent");
      emit(state.copyWith(newWells: List.from(event.wellsList)));
    });

    on<UpdateWellStatusEvent>((event, emit) {
      final currentMap = Map<int, bool>.from(state.wellsStatusMap);
      currentMap[event.wellId] = (event.status == 1);
      emit(state.copyWith(newWellsStatusMap: currentMap));
    });

  }
}
