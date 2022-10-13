import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



ThemeData lightTheme = ThemeData(

    brightness: Brightness.light,
    primaryColor: Colors.deepPurple,
    scaffoldBackgroundColor: Colors.grey.shade200,
    textTheme: const TextTheme(
      headline2: TextStyle(fontFamily: 'josefin slab', color: Color(0xfffdcd00)),
      headline5: TextStyle(color: Colors.white)
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.purple,
      elevation: 12
    ),
    buttonTheme: const ButtonThemeData(
      disabledColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0)
            ),
            shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.0))
            ),
            textStyle: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.pressed)) {
                return const TextStyle(fontSize: 17, color: Colors.white);
              }
              return const TextStyle(fontSize: 17, color: Colors.white);
            }) ,
            backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent),
        )
    ),
    disabledColor: Colors.grey,
    inputDecorationTheme: InputDecorationTheme(
        hintStyle: const TextStyle(color: Colors.black12),
        labelStyle: const TextStyle(color: Colors.black45),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          gapPadding: 0.0,
          borderRadius: BorderRadius.circular(2),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.blue.withOpacity(0.1),
        contentPadding: const EdgeInsets.only(top: 15, bottom: 15, left:10),
    )
);

ThemeData darkTheme = ThemeData(

  brightness: Brightness.dark,
  switchTheme: SwitchThemeData(
    trackColor: MaterialStateProperty.all<Color>(Colors.grey),
    thumbColor: MaterialStateProperty.all<Color>(Colors.white),
  ),
  inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),borderSide: BorderSide.none
      ),
      enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.purple,
            width: 1,
          )
      ),
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.purple,
            width: 2,
          )
      ),
      filled: true,
      fillColor: Colors.grey.withOpacity(0.2),
      hintStyle: const TextStyle(color: Colors.black),
      labelStyle: const TextStyle(color: Colors.black87)
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.symmetric(horizontal: 40.0,vertical: 20.0)
          ),
          shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)
              )
          ),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
          overlayColor: MaterialStateProperty.all<Color>(Colors.black26),
      )
  ),
);
