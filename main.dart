import 'package:flutter/material.dart';

import 'screens/menu_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const UespiOfThrones());
}

class UespiOfThrones extends StatelessWidget {
  const UespiOfThrones({super.key});

  @override
  Widget build(BuildContext context) {
    final baseTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF8B6B32),
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
    );

    final medievalTextTheme = baseTheme.textTheme.apply(
      fontFamily: 'MedievalSharp',
      bodyColor: const Color(0xFFE8D8B5),
      displayColor: const Color(0xFFE8D8B5),
    );

    return MaterialApp(
      title: 'UESPI of Thrones',
      debugShowCheckedModeBanner: false,
      theme: baseTheme.copyWith(
        scaffoldBackgroundColor: const Color(0xFF211A16),
        textTheme: medievalTextTheme.copyWith(
          displayLarge: medievalTextTheme.displayLarge?.copyWith(
            fontFamily: 'UnifrakturCook',
            fontWeight: FontWeight.w700,
          ),
          displayMedium: medievalTextTheme.displayMedium?.copyWith(
            fontFamily: 'UnifrakturCook',
            fontWeight: FontWeight.w700,
          ),
          displaySmall: medievalTextTheme.displaySmall?.copyWith(
            fontFamily: 'UnifrakturCook',
            fontWeight: FontWeight.w700,
          ),
          headlineLarge: medievalTextTheme.headlineLarge?.copyWith(
            fontFamily: 'UnifrakturCook',
            fontWeight: FontWeight.w700,
          ),
          headlineMedium: medievalTextTheme.headlineMedium?.copyWith(
            fontFamily: 'UnifrakturCook',
            fontWeight: FontWeight.w700,
          ),
          headlineSmall: medievalTextTheme.headlineSmall?.copyWith(
            fontFamily: 'UnifrakturCook',
            fontWeight: FontWeight.w700,
          ),
        ),
        primaryTextTheme: baseTheme.primaryTextTheme.apply(
          fontFamily: 'MedievalSharp',
        ),
        appBarTheme: baseTheme.appBarTheme.copyWith(
          titleTextStyle: const TextStyle(
            fontFamily: 'UnifrakturCook',
            fontWeight: FontWeight.w700,
            fontSize: 25,
            color: Color(0xFFE8D8B5),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(
              fontFamily: 'MedievalSharp',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            textStyle: const TextStyle(fontFamily: 'MedievalSharp'),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            textStyle: const TextStyle(fontFamily: 'MedievalSharp'),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(fontFamily: 'MedievalSharp'),
          hintStyle: TextStyle(fontFamily: 'MedievalSharp'),
        ),
        dialogTheme: const DialogThemeData(
          titleTextStyle: TextStyle(
            fontFamily: 'UnifrakturCook',
            fontWeight: FontWeight.w700,
            fontSize: 26,
            color: Color(0xFFE8D8B5),
          ),
          contentTextStyle: TextStyle(
            fontFamily: 'MedievalSharp',
            color: Color(0xFFE8D8B5),
          ),
        ),
      ),
      home: const MenuScreen(),
    );
  }
}
