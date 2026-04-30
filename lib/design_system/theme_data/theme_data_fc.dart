import 'package:flutter/material.dart';

ThemeData themeDataFC() {
  return ThemeData(
    appBarTheme: const AppBarTheme(backgroundColor: Colors.deepPurple),
    primaryColor: Colors.deepPurple,
    hintColor: Colors.purple,
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
        titleLarge: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold, color: Colors.black),
        titleMedium: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w500, color: Colors.white),
        titleSmall: TextStyle(fontSize: 20.0, color: Colors.black),
        bodyLarge: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400),
        labelMedium: TextStyle(fontSize: 16.0, color: Colors.black, fontWeight: FontWeight.bold), // Receipt - ajustar circularbutton e alert dialog
        labelSmall: TextStyle(fontSize: 16.0, color: Colors.black54, fontWeight: FontWeight.normal), //Receipt - ajustar o texto Fatura Atual
        bodyMedium: TextStyle(fontSize: 18.0, color: Colors.black, fontWeight: FontWeight.normal),
        bodySmall: TextStyle(fontSize: 18.0, color: Colors.black),
        displaySmall: TextStyle(fontSize: 18.0, color: Colors.black),
        displayLarge: TextStyle(fontSize: 23.0, color: Colors.black),
        displayMedium: TextStyle(fontSize: 25.0, color: Colors.white)
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: Colors.deepPurple),
  );
}
