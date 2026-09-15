import 'dart:async';

extension FirstTimeoutStreamExt<T> on Stream<T> {
  /// این متد فقط برای دریافت **اولین** دیتا تایم‌اوت اعمال می‌کند.
  Stream<T> timeoutFirst(Duration duration) {
    StreamSubscription<T>? subscription;
    late StreamController<T> controller;

    // استفاده از StreamController با مدیریت onListen و onCancel
    controller = StreamController<T>(
      onListen: () {
        bool isFirstEventReceived = false;

        final timer = Timer(duration, () {
          if (!isFirstEventReceived && !controller.isClosed) {
            controller.addError(TimeoutException('زمان پاسخگویی سرور به پایان رسید', duration));
            controller.close();
          }
        });

        // this به معنی همان استریمی است که متد روی آن صدا زده شده
        subscription = this.listen(
              (data) {
            isFirstEventReceived = true;
            timer.cancel();
            if (!controller.isClosed) controller.add(data);
          },
          onError: (error) {
            if (!controller.isClosed) controller.addError(error);
          },
          onDone: () {
            timer.cancel();
            if (!controller.isClosed) controller.close();
          },
        );
      },
      onCancel: () {
        // بسیار مهم: اگر از صفحه خارج شدیم، استریم اصلی هم قطع شود
        subscription?.cancel();
      },
    );

    return controller.stream;
  }
}