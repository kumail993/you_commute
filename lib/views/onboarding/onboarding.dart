import 'package:you_commute/app/app_constants/app_images.dart';
import 'package:you_commute/app/app_textstyle/app_textstyles.dart';
import 'package:you_commute/app/app_theme/ui_helper.dart';
import 'package:you_commute/imports.dart';
import 'package:you_commute/views/onboarding/controller/onboarding_controller.dart';
import 'package:you_commute/views/onboarding/widgets/onbaording_page.dart';
import 'package:you_commute/widgets/app_button.dart'; // Assuming this has your necessary imports

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(OnboardingController());
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<OnboardingController>(
          builder: (controller) {
            return Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: controller.pageController,
                    onPageChanged: controller.changePage,
                    children: [
                      OnboardingPage(
                        title: 'Welcome to YouCommute',
                        description: 'Your daily commute companion',
                        imagePath: Assets.onboarding,
                      ),
                      OnboardingPage(
                        title: 'Easy Navigation',
                        description: 'Find the best routes effortlessly',
                        imagePath: Assets.onboarding2,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            2,
                            (index) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    controller.currentIndex.value == index
                                        ? Colors.blue
                                        : Colors.grey.withValues(alpha: 0.5),
                              ),
                            ),
                          ),
                        ),
                      ),
                      verticalSpace(20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => controller.skip(),
                            child: Text(
                              'Skip',
                              style: getRegularStyle(fontSize: 16),
                            ),
                          ),
                          Obx(
                            () => PrimaryButton(
                              padding: 5,
                              buttonWidth: 150,
                              color: kcPrimaryColor,
                              text:
                                  controller.currentIndex.value == 1
                                      ? 'Get Started'
                                      : 'Next',
                              onPressed: () => controller.nextPage(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
