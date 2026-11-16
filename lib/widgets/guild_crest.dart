import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Brasão oficial de cada guilda. Os arquivos SVG ficam em assets/images/guilds/.
class GuildCrest extends StatelessWidget {
  final String guildId;
  final double size;
  final IconData fallbackIcon;
  final Color fallbackColor;
  final bool framed;
  final Color frameColor;
  final Color backgroundColor;

  const GuildCrest({
    super.key,
    required this.guildId,
    this.size = 72,
    this.fallbackIcon = Icons.castle,
    this.fallbackColor = const Color(0xFFD6AD55),
    this.framed = true,
    this.frameColor = const Color(0xFFD6AD55),
    this.backgroundColor = const Color(0xFF30251F),
  });

  static const Map<String, String> _assets = {
    'psicologia': 'assets/images/guilds/guilda_psicologia.svg',
    'computacao': 'assets/images/guilds/guilda_computacao.svg',
    'engenharia_civil': 'assets/images/guilds/guilda_engenharia_civil.svg',
    'engenharia_eletrica':
        'assets/images/guilds/guilda_engenharia_eletrica.svg',
    'zootecnia': 'assets/images/guilds/guilda_zootecnia.svg',
    'historia': 'assets/images/guilds/guilda_historia.svg',
    'medicina': 'assets/images/guilds/guilda_medicina.svg',
    'fisica': 'assets/images/guilds/guilda_fisica.svg',
    'educacao_fisica': 'assets/images/guilds/guilda_educacao_fisica.svg',
    'quimica': 'assets/images/guilds/guilda_quimica.svg',
    'letras': 'assets/images/guilds/guilda_letras.svg',
    'biologia': 'assets/images/guilds/guilda_biologia.svg',
    'direito': 'assets/images/guilds/guilda_direito.svg',
    'jornalismo': 'assets/images/guilds/guilda_jornalismo.svg',
    'turismo': 'assets/images/guilds/guilda_turismo.svg',
  };

  @override
  Widget build(BuildContext context) {
    final asset = _assets[guildId];

    final image = asset == null
        ? Icon(fallbackIcon, color: fallbackColor, size: size * 0.58)
        : SvgPicture.asset(
            asset,
            width: size * 0.76,
            height: size * 0.76,
            fit: BoxFit.contain,
            placeholderBuilder: (_) =>
                Icon(fallbackIcon, color: fallbackColor, size: size * 0.58),
          );

    if (!framed) return Center(child: image);

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: Border.all(color: frameColor, width: size >= 90 ? 3 : 2),
        boxShadow: const [
          BoxShadow(color: Colors.black38, blurRadius: 7, offset: Offset(0, 3)),
        ],
      ),
      child: image,
    );
  }
}
