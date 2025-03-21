import 'dart:async';

import 'package:you_commute/imports.dart';

class SplashController extends GetxController {
  late Timer timer;
  late String token;
  @override
  void onInit() async {
    startTimer();
    super.onInit();
  }

  void startTimer() async {
    timer = Timer(const Duration(seconds: 3), () async {
      Get.offNamed(Routes.home);
    });
  }

  @override
  void onClose() {
    timer.cancel();
    super.onClose();
  }
}
