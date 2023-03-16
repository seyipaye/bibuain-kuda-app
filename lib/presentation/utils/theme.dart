import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';
import 'constants.dart';
import 'styles.dart';

kGetInputBorder(Color color) => OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(16),
      ),
      borderSide: BorderSide(color: color),
    );

kGetInputBorder2(Color color) => OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(4),
      ),
      borderSide: BorderSide(color: color),
    );

kGetInputBorder3(Color color) => UnderlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(4),
      ),
      borderSide: BorderSide(color: color),
    );

ThemeData getLightTheme() {
  final textTheme = GoogleFonts.poppinsTextTheme();

  return ThemeData.light().copyWith(
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: AppColors.primary,
      accentColor: AppColors.primary,
      errorColor: AppColors.red,
    ),

    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
    ),
    //splashColor: Colors.black.withOpacity(0.2),
    scaffoldBackgroundColor: AppColors.scaffold_bg,
    drawerTheme: DrawerThemeData(scrimColor: AppColors.scrim),
    textTheme: GoogleFonts.poppinsTextTheme(),

    toggleableActiveColor: AppColors.primary,
    dialogTheme: DialogTheme(
      shape: kRoundedRectangularBorder(),
    ),

    brightness: Brightness.light,
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.white,
      titleTextStyle: getAppBarTitleStyle(color: Colors.black),
    ),
    iconTheme: IconThemeData(size: 20),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(239, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        elevation: 2,
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
        ),
        primary: AppColors.primary,
        onPrimary: Colors.white,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
      minimumSize: Size(0, 48),
      textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
          height: kLineHeight(28, fontSize: 16)),
      shape: kRoundedRectangularBorder(),
      //onPrimary: Colors.white,
    )),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: Size(0, 35),
        textStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 1,
        ),
        side: BorderSide(color: AppColors.outline, width: 1),
        shape: kRoundedRectangularBorder(radius: 10),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      helperMaxLines: 2,
      errorMaxLines: 2,
      isDense: true,
      focusedBorder: kGetInputBorder(AppColors.primary),
      enabledBorder: kGetInputBorder(AppColors.outline),
      errorBorder: kGetInputBorder(AppColors.red),
      focusedErrorBorder: kGetInputBorder(AppColors.red),
      hintStyle: getLabelSmallStyle(
        color: AppColors.hint,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      indicatorColor: Colors.white,
      //backgroundColor: Colors.white,
      elevation: 10,
      surfaceTintColor: Colors.white,
      iconTheme: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return IconThemeData(size: 25, color: AppColors.primary);
        }
        return IconThemeData(size: 25, color: AppColors.buttonText);
      }),
      labelTextStyle: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return getBodyMediumStyle(color: AppColors.primary);
        }
        return getBodyMediumStyle(color: AppColors.buttonText);
      }),
    ),
  );
}

ThemeData getDarkTheme() {
  final theme = ThemeData(brightness: Brightness.dark);

  return ThemeData.dark().copyWith(
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: AppColors.primary,
      accentColor: AppColors.primary,
      errorColor: AppColors.red,
    ),
    scaffoldBackgroundColor: AppColors.scaffold_bg,
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.white,
      titleTextStyle: getAppBarTitleStyle(color: Colors.black),
    ),
    iconTheme: IconThemeData(size: 20, color: Colors.white),
    textTheme: GoogleFonts.poppinsTextTheme(
      theme.textTheme,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
      minimumSize: Size(0, 48),
      textStyle: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 1,
      ),
      onPrimary: Colors.white,
      shape: kRoundedRectangularBorder(),
    )),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
      minimumSize: Size(0, 48),
      textStyle: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 1,
      ),
      shape: kRoundedRectangularBorder(),
      //onPrimary: Colors.white,
    )),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: Size(0, 48),
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
        ),
        primary: AppColors.buttonText,
        shape: kRoundedRectangularBorder(),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      focusedBorder: kGetInputBorder(AppColors.primary),
      enabledBorder: kGetInputBorder(AppColors.outline),
    ),
  );
}
