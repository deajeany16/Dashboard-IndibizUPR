import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webui/helper/theme/theme_type.dart';
import 'package:webui/helper/widgets/my_text_style.dart';

ThemeData get theme => AppTheme.theme;

class AppTheme {
  static ThemeType themeType = ThemeType.light;
  static TextDirection textDirection = TextDirection.rtl;

  static ThemeData theme = getTheme();

  AppTheme._();

  static init() {
    initTextStyle();
  }

  static initTextStyle() {
    MyTextStyle.changeFontFamily(GoogleFonts.ibmPlexSans);
    MyTextStyle.changeDefaultFontWeight({
      100: FontWeight.w100,
      200: FontWeight.w200,
      300: FontWeight.w300,
      400: FontWeight.w300,
      500: FontWeight.w400,
      600: FontWeight.w500,
      700: FontWeight.w600,
      800: FontWeight.w700,
      900: FontWeight.w800,
    });

    MyTextStyle.changeDefaultTextFontWeight({
      MyTextType.displayLarge: 500,
      MyTextType.displayMedium: 500,
      MyTextType.displaySmall: 500,
      MyTextType.headlineLarge: 500,
      MyTextType.headlineMedium: 500,
      MyTextType.headlineSmall: 500,
      MyTextType.titleLarge: 500,
      MyTextType.titleMedium: 500,
      MyTextType.titleSmall: 500,
      MyTextType.labelLarge: 500,
      MyTextType.labelMedium: 500,
      MyTextType.labelSmall: 500,
      MyTextType.bodyLarge: 500,
      MyTextType.bodyMedium: 500,
      MyTextType.bodySmall: 500,
    });
  }

  static ThemeData getTheme([ThemeType? themeType]) {
    themeType = themeType ?? AppTheme.themeType;
    return lightTheme;
  }

  /// -------------------------- Light Theme  -------------------------------------------- ///
  static final ThemeData lightTheme = ThemeData(
    /// Brightness
    brightness: Brightness.light,

    useMaterial3: false,

    /// Primary Color
    primaryColor: Color(0x004466FF),
    scaffoldBackgroundColor: Color(0xfff0f0f0),
    canvasColor: Colors.transparent,

    /// AppBar Theme
    appBarTheme: AppBarTheme(
        backgroundColor: Color(0xffffffff),
        iconTheme: IconThemeData(color: Color(0xff495057)),
        actionsIconTheme: IconThemeData(color: Color(0xff495057))),

    /// Card Theme
    cardTheme: CardTheme(color: Color(0xffffffff)),
    cardColor: Color(0xffffffff),

    textTheme: TextTheme(
        titleLarge: GoogleFonts.aBeeZee(), bodyLarge: GoogleFonts.abel()),

    /// Floating Action Theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Color(0x004466FF),
        splashColor: Color(0xffeeeeee).withAlpha(100),
        highlightElevation: 8,
        elevation: 4,
        focusColor: Color(0x004466FF),
        hoverColor: Color(0x004466FF),
        foregroundColor: Color(0xffeeeeee)),

    /// Divider Theme
    dividerTheme: DividerThemeData(color: Color(0xffe8e8e8), thickness: 1),
    dividerColor: Color(0xffe8e8e8),

    /// Bottom AppBar Theme
    bottomAppBarTheme:
        BottomAppBarTheme(color: Color(0xffeeeeee), elevation: 2),

    /// Tab bar Theme
    tabBarTheme: TabBarTheme(
      unselectedLabelColor: Color(0xff495057),
      labelColor: Color(0x004466FF),
      indicatorSize: TabBarIndicatorSize.label,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: Color(0x004466FF), width: 2.0),
      ),
    ),

    /// CheckBox theme
    checkboxTheme: CheckboxThemeData(
      checkColor: WidgetStateProperty.all(Color(0xffeeeeee)),
      fillColor: WidgetStateProperty.all(Color(0x004466FF)),
    ),

    /// Radio theme
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.all(
        Color(0x004466FF),
      ),
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
          return Color(0xffabb3ea);
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
          return Color(0x004466FF);
        }
        return null;
      }),
    ),

    /// Slider Theme
    sliderTheme: SliderThemeData(
      activeTrackColor: Color(0x004466FF),
      inactiveTrackColor: Color(0x004466FF).withAlpha(140),
      trackShape: RoundedRectSliderTrackShape(),
      trackHeight: 4.0,
      thumbColor: Color(0x004466FF),
      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.0),
      overlayShape: RoundSliderOverlayShape(overlayRadius: 24.0),
      tickMarkShape: RoundSliderTickMarkShape(),
      inactiveTickMarkColor: Colors.red[100],
      valueIndicatorShape: PaddleSliderValueIndicatorShape(),
      valueIndicatorTextStyle: TextStyle(
        color: Color(0xffeeeeee),
      ),
    ),

    /// Other Colors
    splashColor: Colors.white.withAlpha(100),
    indicatorColor: Color(0xffeeeeee),
    highlightColor: Color(0xffeeeeee),
    colorScheme: ColorScheme.fromSeed(
            seedColor: Color(0x004466FF), brightness: Brightness.light)
        .copyWith(surface: Color(0xffffffff))
        .copyWith(error: Color(0xfff0323c)),
  );

  static ThemeData createThemeM3(ThemeType themeType, Color seedColor) {
    return lightTheme.copyWith(
        colorScheme: ColorScheme.fromSeed(
            seedColor: seedColor, brightness: Brightness.light));
  }

  static ThemeData createTheme(ColorScheme colorScheme) {
    return lightTheme.copyWith(colorScheme: colorScheme);
  }

  static ThemeData getNFTTheme() {
    return lightTheme.copyWith(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Color(0xff232245), brightness: Brightness.light));

    // return createTheme(ColorScheme.fromSeed(seedColor: Color(0xff232245)));
  }

  static ThemeData getRentalServiceTheme() {
    return createThemeM3(themeType, Color(0xff2e87a6));
  }
}
