import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:you_commute/app/app_theme/app_colors.dart';
import 'package:you_commute/core/supabase_config.dart';
import 'package:you_commute/you_commute.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await supabaseInit();
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.custom
    ..backgroundColor = kcPrimaryColor
    ..radius = 12
    ..indicatorSize = 30
    ..textColor = Colors.white
    ..indicatorColor = Colors.white
    ..userInteractions = false
    ..displayDuration = const Duration(seconds: 1)
    ..dismissOnTap = false;
  runApp(const YouCommuteApp());
}
