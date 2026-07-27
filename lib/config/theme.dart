import 'package:flutter/material.dart';

import 'color_palette.dart';

class MyThemes {
  static final darkTheme = ThemeData(
      dividerTheme: const DividerThemeData(color: Colors.grey, thickness: 2),

      fontFamily: "Vazir",
      textTheme: TextTheme(
        bodyMedium: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: ColorPalette.white),

      ),
      // highlightColor: ColorPalette.indio,
      canvasColor: ColorPalette.grey,
      unselectedWidgetColor: Colors.white70,
      // primaryColorLight: ColorPalette.yellowO1,
      scaffoldBackgroundColor: Colors.grey.shade900,
      // secondaryHeaderColor: ColorPalette.orangeO1,
      // iconTheme: IconThemeData(color: ColorPalette.teal),
      textSelectionTheme: TextSelectionThemeData(
        // cursorColor: ColorPalette.red,
        selectionColor: ColorPalette.primaryTextGreen,
        selectionHandleColor: ColorPalette.darkBlue,
      ),
      // colorScheme:
          // const ColorScheme.dark().copyWith(surface: ColorPalette.black), tabBarTheme: TabBarThemeData(indicatorColor: ColorPalette.amber)
  );

  static final lightTheme = ThemeData(
    checkboxTheme: CheckboxThemeData(

    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(
        fontSize: 12
      ),
      hintStyle: TextStyle(
        fontSize: 12
      ),


      focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
          ),
          borderRadius:  BorderRadius.circular(5)),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color:  Colors.grey,
          ),
          borderRadius:BorderRadius.circular(5)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color:  Colors.grey,
          ),
          borderRadius:  BorderRadius.circular(5)),
      errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
          ),
          borderRadius: BorderRadius.circular(5)),
    ),

    dividerTheme: const DividerThemeData(color: Colors.grey, thickness: 2),



    fontFamily: "Vazir",

    textTheme: const TextTheme(

      bodyMedium: TextStyle(
          color: Colors.black, fontSize: 15, fontWeight: FontWeight.w400),

    ),
    unselectedWidgetColor: ColorPalette.black,
    // primaryColorLight: Colors.green,
    scaffoldBackgroundColor: ColorPalette.white,
    // primaryColor: ColorPalette.amberShade800,
    // secondaryHeaderColor: Colors.green

    // iconTheme: IconThemeData(color: ColorPalette.black), tabBarTheme: TabBarThemeData(indicatorColor: ColorPalette.amber),

    // colorScheme: const ColorScheme.light()
  );
}
