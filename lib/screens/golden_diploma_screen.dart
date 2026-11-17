import 'package:flutter/material.dart';

/// Tela de recompensa exibida uma única vez ao conquistar todas as guildas.
class GoldenDiplomaScreen extends StatelessWidget {
  const GoldenDiplomaScreen({super.key});

  static const Color _gold = Color(0xFFD6AD55);
  static const Color _parchment = Color(0xFFE8D8B5);
  static const Color _background = Color(0xFF211A16);

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      backgroundColor: _background,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 18),
            const Icon(Icons.emoji_events, color: _gold, size: 42),
            const SizedBox(height: 8),
            const Text(
              'CONQUISTA LENDÁRIA',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _gold,
                fontSize: 20,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
                fontFamily: 'UnifrakturCook',
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Text(
                'Você dominou todas as guildas do reino!',
                textAlign: TextAlign.center,
                style: TextStyle(color: _parchment, fontSize: 14),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1536 / 1024,
                    child: Image.asset(
                      'assets/images/golden_diploma.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Text(
                            'Diploma de Ouro\nMestre Supremo do Reino',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _gold,
                              fontSize: 28,
                              fontFamily: 'UnifrakturCook',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Seu título foi registrado permanentemente nesta jornada.',
                textAlign: TextAlign.center,
                style: TextStyle(color: _parchment, fontSize: 13),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 22),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _gold,
                    foregroundColor: _background,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.workspace_premium),
                  label: const Text(
                    'RECEBER DIPLOMA E CONTINUAR',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
