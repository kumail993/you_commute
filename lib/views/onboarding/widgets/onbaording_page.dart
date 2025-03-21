import 'package:you_commute/app/app_textstyle/app_textstyles.dart';
import 'package:you_commute/app/app_theme/ui_helper.dart';
import 'package:you_commute/imports.dart';

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 120, // Adjust radius as needed
            backgroundImage: AssetImage(imagePath), // Your image asset path
          ),

          verticalSpace(50),
          Text(
            title,
            style: getBoldStyle(fontSize: 24),
            textAlign: TextAlign.center,
          ),
          verticalSpace(20),
          Text(
            description,
            style: getRegularStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
