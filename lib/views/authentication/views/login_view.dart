import 'package:you_commute/imports.dart';
import 'package:you_commute/widgets/app_button.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Login View'),
            PrimaryButton(
              text: 'Login',
              onPressed: () {
                Get.offNamed(Routes.home);
              },
            ),
          ],
        ),
      ),
    );
  }
}
