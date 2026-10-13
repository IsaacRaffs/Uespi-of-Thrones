import 'package:flutter/material.dart';

import 'screens/map_screen.dart';

void main() {
  runApp(const UespiOfThrones());
}

class UespiOfThrones extends StatelessWidget {
  const UespiOfThrones({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'UESPI of Thrones',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),

      home: const MapScreen(),
    );
  }
}