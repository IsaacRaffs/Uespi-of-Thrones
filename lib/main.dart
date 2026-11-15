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
        seedColor: const Color(0xFFD6AD55),
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
    );

    // Fonte padrão dos textos.
    final textTheme = baseTheme.textTheme.apply(fontFamily: 'MedievalSharp');

    // Fonte gótica para títulos.
    final medievalTheme = textTheme.copyWith(
      displayLarge: textTheme.displayLarge?.copyWith(
        fontFamily: 'UnifrakturCook',
      ),
      displayMedium: textTheme.displayMedium?.copyWith(
        fontFamily: 'UnifrakturCook',
      ),
      displaySmall: textTheme.displaySmall?.copyWith(
        fontFamily: 'UnifrakturCook',
      ),
      headlineLarge: textTheme.headlineLarge?.copyWith(
        fontFamily: 'UnifrakturCook',
      ),
      headlineMedium: textTheme.headlineMedium?.copyWith(
        fontFamily: 'UnifrakturCook',
      ),
      headlineSmall: textTheme.headlineSmall?.copyWith(
        fontFamily: 'UnifrakturCook',
      ),
      titleLarge: textTheme.titleLarge?.copyWith(fontFamily: 'UnifrakturCook'),
      titleMedium: textTheme.titleMedium?.copyWith(
        fontFamily: 'UnifrakturCook',
      ),
      titleSmall: textTheme.titleSmall?.copyWith(fontFamily: 'UnifrakturCook'),
    );

    return MaterialApp(
      title: 'UESPI of Thrones',
      debugShowCheckedModeBanner: false,
      theme: baseTheme.copyWith(
        textTheme: medievalTheme,
        primaryTextTheme: medievalTheme,
      ),
      home: const MenuScreen(),
    );
  }
}
