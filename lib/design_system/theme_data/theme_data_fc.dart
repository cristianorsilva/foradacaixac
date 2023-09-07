import 'package:flutter/material.dart';

ThemeData themeDataFC() {
  return ThemeData(
    appBarTheme: const AppBarTheme(backgroundColor: Colors.deepPurple),
    primaryColor: Colors.deepPurple,
    errorColor: Colors.purple,
    disabledColor: Colors.grey,
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Colors.deepPurple,
      padding: const EdgeInsets.only(left: 50, right: 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      textStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
    )),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
            foregroundColor: Colors.deepPurple,
            padding: const EdgeInsets.only(left: 50, right: 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            textStyle: const TextStyle(fontWeight: FontWeight.bold))),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold, color: Colors.black),
      headline1: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold, color: Colors.black),
      headline2: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w500, color: Colors.white),
      headline3: TextStyle(fontSize: 20.0, color: Colors.black),
      headline4: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400),
      headline5: TextStyle(fontSize: 16.0, color: Colors.black, fontWeight: FontWeight.bold), // Receipt - ajustar circularbutton e alert dialog
      headline6: TextStyle(fontSize: 16.0, color: Colors.black54, fontWeight: FontWeight.normal), //Receipt - ajustar o texto Fatura Atual
      bodyText1: TextStyle(fontSize: 15.0, color: Colors.black, fontWeight: FontWeight.normal),
      bodyText2: TextStyle(fontSize: 18.0, color: Colors.black),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: Colors.deepPurple),
  );
}
