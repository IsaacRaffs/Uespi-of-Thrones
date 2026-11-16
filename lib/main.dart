import 'package:flutter/material.dart';

import 'screens/menu_screen.dart';
import 'services/audio_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await AudioService.instance.initialize();
    debugPrint('AudioService inicializado com sucesso.');
  } catch (error) {
    debugPrint('Erro ao inicializar AudioService: $error');
  }

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MenuScreen(),
    );
  }
}