
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
    const parchment = Color(0xFFE8D8B5);
    const background = Color(0xFF211A16);

    final baseTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF8B6B32),
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
    );

    // Fonte padrão para textos comuns.
    final medievalTextTheme = baseTheme.textTheme.apply(
      fontFamily: 'MedievalSharp',
      bodyColor: parchment,
      displayColor: parchment,
    );

    // Fonte decorativa para títulos.
    const gothic = TextStyle(
      fontFamily: 'UnifrakturCook',
      fontWeight: FontWeight.w700,
      color: parchment,
    );

    final finalTextTheme = medievalTextTheme.copyWith(
      // Títulos principais.
      displayLarge: gothic.copyWith(fontSize: 57),
      displayMedium: gothic.copyWith(fontSize: 45),
      displaySmall: gothic.copyWith(fontSize: 36),

      // Cabeçalhos.
      headlineLarge: gothic.copyWith(fontSize: 32),
      headlineMedium: gothic.copyWith(fontSize: 28),
      headlineSmall: gothic.copyWith(fontSize: 24),

      // Títulos de cards, seções e componentes.
      titleLarge: gothic.copyWith(fontSize: 22),
      titleMedium: gothic.copyWith(fontSize: 18),
      titleSmall: gothic.copyWith(fontSize: 16),

      // Textos informativos e botões.
      bodyLarge: medievalTextTheme.bodyLarge,
      bodyMedium: medievalTextTheme.bodyMedium,
      bodySmall: medievalTextTheme.bodySmall,
      labelLarge: medievalTextTheme.labelLarge,
      labelMedium: medievalTextTheme.labelMedium,
      labelSmall: medievalTextTheme.labelSmall,
    );

    return MaterialApp(
      title: 'UESPI of Thrones',
      debugShowCheckedModeBanner: false,

      theme: baseTheme.copyWith(
        scaffoldBackgroundColor: background,
        textTheme: finalTextTheme,

        primaryTextTheme: baseTheme.primaryTextTheme.apply(
          fontFamily: 'MedievalSharp',
        ),

        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'UnifrakturCook',
            fontWeight: FontWeight.w700,
            fontSize: 25,
            color: parchment,
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
            textStyle: const TextStyle(
              fontFamily: 'MedievalSharp',
            ),
          ),
        ),

        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            textStyle: const TextStyle(
              fontFamily: 'MedievalSharp',
            ),
          ),
        ),

        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(
            fontFamily: 'MedievalSharp',
            color: parchment,
          ),
          hintStyle: TextStyle(
            fontFamily: 'MedievalSharp',
          ),
        ),

        dialogTheme: const DialogThemeData(
          titleTextStyle: TextStyle(
            fontFamily: 'UnifrakturCook',
            fontWeight: FontWeight.w700,
            fontSize: 26,
            color: parchment,
          ),
          contentTextStyle: TextStyle(
            fontFamily: 'MedievalSharp',
            color: parchment,
          ),
        ),

        tabBarTheme: const TabBarThemeData(
          labelStyle: TextStyle(
            fontFamily: 'UnifrakturCook',
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: 'MedievalSharp',
          ),
        ),
      ),

      home: const MenuScreen(),
    );
  }
}
