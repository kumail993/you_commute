import 'package:flutter/services.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:you_commute/app/app_textstyle/app_textstyles.dart';
import 'package:you_commute/imports.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String labelText;
  final bool obscureText;
  final bool? suffixIcon;
  final Widget? prefixIcon;
  final Icon? suffixIconData;
  final Icon? prefixIconData;
  final bool? isPasswordVisible;
  final double? borderRadius;
  final Color? fillColor;
  final Color? textColor;
  final String? preText;
  final Function(String)? onChanged;
  final Function()? onVisibilityToggle;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool? readOnly;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;

  const AppTextField({
    super.key,
    this.controller,
    this.readOnly = false,
    required this.labelText,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon = false,
    this.preText,
    this.isPasswordVisible,
    this.onVisibilityToggle,
    this.inputFormatters,
    this.validator,
    this.borderRadius,
    this.fillColor,
    this.textColor,
    this.prefixIcon,
    this.onChanged,
    this.suffixIconData,
    this.prefixIconData,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      cursorColor: kcBlackColor,
      readOnly: readOnly!,
      onChanged: onChanged,
      obscureText: obscureText,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      controller: controller,
      validator: validator,
      focusNode: FocusNode(),
      style: getRegularStyle(fontSize: 12, color: textColor ?? kcBlackColor),
      decoration: InputDecoration(
        hintText: labelText,
        filled: true,
        prefixText: preText,
        fillColor: fillColor ?? kcLightGrey,
        hintStyle: getRegularStyle(
          fontSize: 12,
          color: textColor ?? kcTextGrey,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 5.0),
          borderSide: const BorderSide(color: kcBorderColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 5.0),
          borderSide: const BorderSide(color: kcBorderColor, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 5.0),
          borderSide: const BorderSide(color: kcBorderColor, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 5.0),
          borderSide: const BorderSide(color: kcBorderColor, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 5.0),
          borderSide: const BorderSide(color: kcBorderColor, width: 1),
        ),
        contentPadding: const EdgeInsets.only(
          left: 15,
          right: 15,
          top: 13,
          bottom: 13,
        ),
        prefixIcon: prefixIcon,
        suffixIcon:
            suffixIcon == false
                ? null
                : obscureText == true
                ? GestureDetector(
                  onTap: onVisibilityToggle,
                  child: const Icon(FlutterRemix.eye_off_line),
                )
                : GestureDetector(
                  onTap: onVisibilityToggle,
                  child: const Icon(FlutterRemix.eye_line),
                ),
      ),
    );
  }
}
