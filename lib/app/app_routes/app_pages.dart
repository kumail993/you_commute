import 'package:you_commute/imports.dart';
import 'package:you_commute/views/authentication/views/login_view.dart';
import 'package:you_commute/views/home/home_view.dart';
import 'package:you_commute/views/onboarding/onboarding.dart';
import 'package:you_commute/views/splash/splash_view.dart';

class AppRouter {
  static String initialRoute = Routes.splash;

  static List<GetPage> pages() {
    return [
      GetPage(name: Routes.splash, page: () => const SplashView()),
      GetPage(name: Routes.home, page: () => const HomeView()),
      GetPage(name: Routes.login, page: () => const LoginView()),
      GetPage(name: Routes.onboarding, page: () => const OnboardingScreen()),
    ];
  }
}
