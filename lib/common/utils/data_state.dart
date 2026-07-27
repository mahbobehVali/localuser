abstract class DataState<T> {
  final T? data;
  final String? error;

  const DataState(this.data, this.error);
}

class DataSuccess<T> extends DataState<T> {
  final bool total;
  const DataSuccess(T? data, {this.total = false}) : super(data, null);
}

class DataFailed<T> extends DataState<T> {
  final bool isTokenExpired; // 🚨 اضافه کردن این فیلد
  final bool isNotLogin; // 🚨 اضافه کردن این فیلد
  const DataFailed({String? error,this.isTokenExpired = false,this.isNotLogin=false}) : super(null, error);
}
