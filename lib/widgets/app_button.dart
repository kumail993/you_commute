import 'package:flutter/material.dart';
import 'package:you_commute/app/app_theme/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;
  final double padding;
  final double buttonWidth;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = kcPrimaryColor,
    this.textColor = kcWhitecolor,
    this.padding = 16.0,
    this.buttonWidth = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: buttonWidth,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.all(padding),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        onPressed: onPressed,
        child: Text(text, style: TextStyle(color: textColor, fontSize: 16.0)),
      ),
    );
  }
}
