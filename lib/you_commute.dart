import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:you_commute/app/app_routes/app_pages.dart';
import 'package:you_commute/imports.dart';

class YouCommuteApp extends StatelessWidget {
  const YouCommuteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'You Commute',
      debugShowCheckedModeBanner: false,
      theme: theme,
      locale: const Locale('en_US'),
      fallbackLocale: const Locale('en_US'),
      defaultTransition: Transition.cupertino,
      initialRoute: AppRouter.initialRoute,
      builder: EasyLoading.init(),
      getPages: AppRouter.pages(),
    );
  }
}
