import '../../imports.dart';

TextStyle getBoldStyle({
  Color color = kcBlackColor,
  double fontSize = 24,
  FontWeight fontWeight = FontWeight.bold,
}) {
  return GoogleFonts.roboto(
    fontSize: fontSize,
    color: color,
    fontWeight: fontWeight,
    letterSpacing: -0.5,
  );
}

TextStyle getRegularBoldStyle({
  Color color = kcBlackColor,
  double fontSize = 24,
  FontWeight fontWeight = FontWeight.w500,
}) {
  return GoogleFonts.roboto(
    fontSize: fontSize,
    color: color,
    fontWeight: fontWeight,
    letterSpacing: -0.5,
  );
}

TextStyle getMediumStyle({Color color = kcBlackColor, double fontSize = 14}) {
  return GoogleFonts.roboto(
    fontSize: fontSize,
    color: color,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.5,
  );
}

TextStyle getRegularStyle({Color color = kcBlackColor, double fontSize = 12}) {
  return GoogleFonts.roboto(
    fontSize: fontSize,
    color: color,
    letterSpacing: -0.5,
  );
}
