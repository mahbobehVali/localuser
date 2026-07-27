//
//
// import '../../../../common/params/validation_params.dart';
// import '../../../../common/utils/data_state.dart';
// import '../../../../common/utils/use_case.dart';
// import '../repository/sign_up_repository.dart';
//
// class JustCodeUseCase extends UseCase<DataState<dynamic>,ValidationParams>{
//   SignUpRepository authRepository;
//
//   JustCodeUseCase(this.authRepository);
//
//   @override
//   Future<DataState<dynamic>> call(validationParams) {
//     return authRepository.codeValidation(validationParams);
//   }
// }