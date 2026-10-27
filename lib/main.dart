
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
    return MaterialApp(
      title: 'UESPI of Thrones',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: const MenuScreen(),
    );
  }
}
