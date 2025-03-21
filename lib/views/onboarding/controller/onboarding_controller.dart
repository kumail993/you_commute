import 'package:you_commute/imports.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController(initialPage: 0);

  RxInt currentIndex = 0.obs;

  void changePage(int index) {
    currentIndex.value = index;
    pageController.jumpToPage(index);
  }

  void nextPage() {
    currentIndex.value++;
    pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void previousPage() {
    currentIndex.value--;
    pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void skip() {
    Get.offNamed(Routes.login);
  }

  @override
  void onInit() {
    super.onInit();
  }
}
