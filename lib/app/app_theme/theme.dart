import 'package:you_commute/imports.dart';

ThemeData get theme => AppTheme.theme;

abstract final class AppTheme {
  static TextDirection textDirection = TextDirection.rtl;
  static ThemeData theme = getTheme();

  static ThemeData getTheme() {
    return lightTheme;
  }

  /// -------------------------- Light Theme  -------------------------------------------- ///
  static final ThemeData lightTheme = ThemeData(
    /// Brightness
    brightness: Brightness.light,

    /// Primary Color
    primaryColor: kcPrimaryColor,
    scaffoldBackgroundColor: const Color(0xffffffff),
    canvasColor: Colors.transparent,

    /// AppBar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xffffffff),
      iconTheme: IconThemeData(color: Color(0xff495057)),
      actionsIconTheme: IconThemeData(color: Color(0xff495057)),
    ),

    /// Card Theme
    cardTheme: const CardTheme(color: Color(0xfff0f0f0)),
    cardColor: const Color(0xfff0f0f0),

    textTheme: TextTheme(
      titleLarge: GoogleFonts.aBeeZee(),
      bodyLarge: GoogleFonts.abel(),
    ),

    /// Floating Action Theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: const Color(0xffD17E0F),
      splashColor: const Color(0xffeeeeee).withAlpha(100),
      highlightElevation: 8,
      elevation: 4,
      focusColor: const Color(0xffD17E0F),
      hoverColor: const Color(0xffD17E0F),
      foregroundColor: const Color(0xffeeeeee),
    ),

    /// Divider Theme
    dividerTheme: const DividerThemeData(
      color: Color(0xffe8e8e8),
      thickness: 1,
    ),
    dividerColor: const Color(0xffe8e8e8),

    /// Bottom AppBar Theme
    bottomAppBarTheme: const BottomAppBarTheme(
      color: Color(0xffeeeeee),
      elevation: 2,
    ),

    /// Tab bar Theme
    tabBarTheme: const TabBarTheme(
      unselectedLabelColor: Color(0xff495057),
      labelColor: kcPrimaryColor,
      indicatorSize: TabBarIndicatorSize.label,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: kcPrimaryColor, width: 2),
      ),
    ),

    /// CheckBox theme
    checkboxTheme: CheckboxThemeData(
      checkColor: WidgetStateProperty.all(const Color(0xffeeeeee)),
      fillColor: WidgetStateProperty.all(kcPrimaryColor),
    ),

    /// Radio theme
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.all(kcPrimaryColor),
    ),

    ///Switch Theme
    switchTheme: SwitchThemeData(
      trackColor: WidgetStateProperty.resolveWith((state) {
        const Set<WidgetState> interactiveStates = <WidgetState>{
          WidgetState.pressed,
          WidgetState.hovered,
          WidgetState.focused,
          WidgetState.selected,
        };
        if (state.any(interactiveStates.contains)) {
          return const Color(0xffabb3ea);
        }
        return null;
      }),
      thumbColor: WidgetStateProperty.resolveWith((state) {
        const Set<WidgetState> interactiveStates = <WidgetState>{
          WidgetState.pressed,
          WidgetState.hovered,
          WidgetState.focused,
          WidgetState.selected,
        };
        if (state.any(interactiveStates.contains)) {
          return kcPrimaryColor;
        }
        return null;
      }),
    ),

    /// Slider Theme
    sliderTheme: SliderThemeData(
      activeTrackColor: kcPrimaryColor,
      inactiveTrackColor: kcPrimaryColor.withAlpha(140),
      trackShape: const RoundedRectSliderTrackShape(),
      trackHeight: 4,
      thumbColor: kcPrimaryColor,
      thumbShape: const RoundSliderThumbShape(),
      overlayShape: const RoundSliderOverlayShape(),
      tickMarkShape: const RoundSliderTickMarkShape(),
      inactiveTickMarkColor: Colors.red[100],
      valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
      valueIndicatorTextStyle: const TextStyle(color: Color(0xffeeeeee)),
    ),

    /// Other Colors
    splashColor: Colors.white.withAlpha(100),
    indicatorColor: const Color(0xffeeeeee),
    highlightColor: const Color(0xffeeeeee),
    colorScheme: ColorScheme.fromSeed(seedColor: kcPrimaryColor)
        .copyWith(surface: const Color(0xffffffff))
        .copyWith(error: const Color(0xfff0323c)),
  );
}
