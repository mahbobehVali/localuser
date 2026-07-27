import 'package:bloc/bloc.dart';


class ThemeCubit extends Cubit<String> {
  ThemeCubit() : super("light");
  void theme(){
    emit(state=="light"?"dark":"light");
  }

}
