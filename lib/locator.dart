import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:mahaliii/features/alert_feature/data/datasource/remote/alert_api_provider.dart';
import 'package:mahaliii/features/alert_feature/data/repository/alert_repositoryimpl.dart';
import 'package:mahaliii/features/alert_feature/domain/repository/alert_repository.dart';
import 'package:mahaliii/features/alert_feature/domain/usecase/alert_usecase.dart';
import 'package:mahaliii/features/auth_feature/domain/usecase/get_code_usecase.dart';
import 'package:mahaliii/features/panel_feature/data/datasource/remote/account_provider.dart';
import 'package:mahaliii/features/panel_feature/data/repository/account_repositoryimpl.dart';
import 'package:mahaliii/features/panel_feature/domain/repository/account_repository.dart';
import 'package:mahaliii/features/panel_feature/domain/usecase/send_sms_usecase.dart';
import 'package:mahaliii/features/report_feature/data/datasource/remote/report_api_provider.dart';
import 'package:mahaliii/features/report_feature/data/repository/report_repositoryimpl.dart';
import 'package:mahaliii/features/report_feature/domain/repository/report_repository.dart';
import 'package:mahaliii/features/sign_up_feature/domain/usecase/area_usecase.dart';
import 'package:mahaliii/features/status_summary_feature/domain/repository/status_summary_repository.dart';
import 'package:mahaliii/features/support_feature/data/datasource/remote/support_api_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common/socket_repository.dart';
import 'common/utils/constants.dart';
import 'common/utils/sharedpreference.dart';
import 'features/alert_feature/domain/usecase/alert_create_usecase.dart';
import 'features/alert_feature/domain/usecase/alert_detail_usecase.dart';
import 'features/auth_feature/data/datasource/remote/auth_api_provider.dart';
import 'features/auth_feature/data/repository/auth_repositoryimpl.dart';
import 'features/auth_feature/domain/repository/auth_repository.dart';
import 'features/auth_feature/domain/usecase/forget_pass_usecase.dart';
import 'features/auth_feature/domain/usecase/login_usecase.dart';
import 'features/panel_feature/domain/usecase/change_alert_usecase.dart';
import 'features/panel_feature/domain/usecase/change_password_usecase.dart';
import 'features/report_feature/domain/usecase/get_capacity_usecase.dart';
import 'features/sign_up_feature/data/datasource/remote/sign_up_api_provider.dart';
import 'features/sign_up_feature/data/repository/sign_up_repositoryimpl.dart';
import 'features/sign_up_feature/domain/repository/sign_up_repository.dart';
import 'features/sign_up_feature/domain/usecase/first_sign_up.dart';
import 'features/sign_up_feature/domain/usecase/region_usecase.dart';
import 'features/sign_up_feature/domain/usecase/register_usecase.dart';
import 'features/sign_up_feature/domain/usecase/send_validation_code_usecase.dart';
import 'features/status_summary_feature/data/datasource/remote/status_summary_api_provider.dart';
import 'features/status_summary_feature/data/repository/status_summary_repositoryimpl.dart';
import 'features/status_summary_feature/domain/usecase/last_activity_usecase.dart';
import 'features/status_summary_feature/domain/usecase/report_flowmeter_usecase.dart';
import 'features/status_summary_feature/domain/usecase/wells_list_usecase.dart';
import 'features/support_feature/data/repository/support_repositoryimpl.dart';
import 'features/support_feature/domain/repository/support_repository.dart';
import 'features/support_feature/domain/usecase/send_answer_usecase.dart';
import 'features/support_feature/domain/usecase/send_support_usecase.dart';
import 'features/support_feature/domain/usecase/support_answers_usecase.dart';
import 'features/support_feature/domain/usecase/support_close_usecase.dart';
import 'features/support_feature/domain/usecase/support_usecase.dart';
import 'features/well_feature/data/datasource/remote/wells_api_provider.dart';
import 'features/well_feature/data/repository/wells_repositoryimpl.dart';
import 'features/well_feature/domain/repository/wells_repository.dart';
import 'features/well_feature/domain/usecase/alert_count_usecase.dart';
import 'features/well_feature/domain/usecase/flow_meter_usecase.dart';
import 'features/well_feature/domain/usecase/get_program_usecase.dart';
import 'features/well_feature/domain/usecase/well_work_usecase.dart';
import 'features/well_feature/presentation/bloc/well_detail_bloc/well_detail_bloc.dart';

final locator = GetIt.instance;
// import کنید جایی که SharedPrefOperator در آن قرار دارد

class AuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {

    try {
      // بررسی اینکه آیا اصلاً SharedPrefOperator ثبت شده یا نه
      if (locator.isRegistered<SharedPrefOperator>()) {
        final token =locator<SharedPrefOperator>().getUserToken();
        if (token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
      }
    } catch (e) {
      print("Interceptor Error: $e");
    }

    return handler.next(options);
  }
}

Future<void> setup() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  Dio dio = Dio(BaseOptions(baseUrl: Constants.baseUrl));
  dio.interceptors.add(AuthInterceptor());
  locator.registerFactory<SignUpApiProvider>(() =>SignUpApiProvider(dio));
  locator.registerFactory<SignUpRepository>(() =>SignUpRepositoryImpl(apiProvider: locator()));
  locator.registerFactory<RegisterUseCase>(() =>RegisterUseCase(locator()));
  locator.registerFactory<FirstSignupUseCase>(() =>FirstSignupUseCase(locator()));
  locator.registerFactory<SendValidationCodeUseCase>(() =>SendValidationCodeUseCase(locator()));
  locator.registerFactory<RegionUseCase>(() =>RegionUseCase(locator()));
  locator.registerFactory<AreaUseCase>(() =>AreaUseCase(locator()));
  locator.registerSingleton<SharedPrefOperator>(SharedPrefOperator(sharedPreferences));

  ///auth
  locator.registerFactory<AuthApiProvider>(() =>AuthApiProvider(dio));
  locator.registerFactory<AuthRepository>(() =>AuthRepositoryImpl(authApiProvider: locator()));
  locator.registerFactory<LoginUseCase>(() =>LoginUseCase(locator()));
  locator.registerFactory<GetCodeUseCase>(() =>GetCodeUseCase(locator()));
  locator.registerFactory<ForgetPassUseCase>(() =>ForgetPassUseCase(locator()));

  ///well
  locator.registerFactory<WellsApiProvider>(() =>WellsApiProvider(dio));
  locator.registerFactory<WellsRepository>(() =>WellsRepositoryImpl(locator()));
  locator.registerFactory<WellWorkHourUseCase>(() =>WellWorkHourUseCase(locator()));
  locator.registerFactory<WellFlowMeterUseCase>(() =>WellFlowMeterUseCase(locator()));
  locator.registerFactory<GetProgramUseCase>(() =>GetProgramUseCase(locator()));
  locator.registerFactory<AlertCountUseCase>(() =>AlertCountUseCase(locator()));
  locator.registerLazySingleton<WellDetailBloc>(() =>WellDetailBloc(
    locator<WellsRepository>(),
    locator<WellWorkHourUseCase>(),
    locator<WellFlowMeterUseCase>(),
    locator<WellsListUseCase>(),
    locator<GetProgramUseCase>(),
    locator<SocketRepository>(),
    locator<AlertCountUseCase>(),
  ));

  ///alert
  locator.registerFactory<AlertApiProvider>(() =>AlertApiProvider(dio));
  locator.registerFactory<AlertRepository>(() =>AlertRepositoryImpl(alertApiProvider: locator()));
  locator.registerFactory<AlertUseCase>(() =>AlertUseCase( locator()));

  ///report
  locator.registerFactory<ReportApiProvider>(() =>ReportApiProvider(dio));
  locator.registerFactory<ReportRepository>(() =>ReportRepositoryImpl(reportApiProvider: locator(), alertApiProvider: locator(), wellsApiProvider: locator()));
  locator.registerFactory<GetCapacityUseCase>(() =>GetCapacityUseCase( locator()));

  ///StatusSummary
  locator.registerFactory<StatusSummaryApiProvider>(() =>StatusSummaryApiProvider(dio));
  locator.registerFactory<StatusSummaryRepository>(() =>StatusSummaryRepositoryImpl(statusSummaryApiProvider: locator()));
  locator.registerFactory<WellsListUseCase>(() =>WellsListUseCase(locator()));
  locator.registerFactory<LastActivityUseCase>(() =>LastActivityUseCase(locator()));
  locator.registerFactory<ReportFlowMeterUseCase>(() =>ReportFlowMeterUseCase(locator()));
  locator.registerLazySingleton<SocketRepository>(() => SocketRepository());

  ///panel
  locator.registerFactory<PanelApiProvider>(() =>PanelApiProvider(dio));
  locator.registerFactory<PanelRepository>(() =>PanelRepositoryImpl(panelApiProvider: locator()));
  locator.registerFactory<SendSmsUseCase>(() =>SendSmsUseCase(locator()));
  locator.registerFactory<ChangePasswordUseCase>(() =>ChangePasswordUseCase(locator()));
  locator.registerFactory<ChangeAlertUseCase>(() =>ChangeAlertUseCase(locator()));
  locator.registerFactory<AlertDetailUseCase>(() =>AlertDetailUseCase(locator()));
  locator.registerFactory<AlertCreateUseCase>(() =>AlertCreateUseCase(locator()));


  locator.registerFactory<SupportApiProvider>(() =>SupportApiProvider(dio));
  locator.registerFactory<SupportRepository>(() =>SupportRepositoryImpl(supportApiProvider: locator()));
  locator.registerFactory<SupportUseCase>(() =>SupportUseCase(locator()));
  locator.registerFactory<SupportAnswersUseCase>(() =>SupportAnswersUseCase(locator()));
  locator.registerFactory<SendSupportUseCase>(() =>SendSupportUseCase(locator()));
  locator.registerFactory<SendAnswerUseCase>(() =>SendAnswerUseCase(locator()));
  locator.registerFactory<SupportCloseUseCase>(() =>SupportCloseUseCase(locator()));

}
