import 'package:you_commute/app/app_textstyle/app_textstyles.dart';
import 'package:you_commute/imports.dart';
import 'exports.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 100, right: 100, top: 20),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: kcWhitecolor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [Text('YouCommute', style: getMediumStyle(fontSize: 30))],
          ),
        ),
      ),
    );
  }
}
