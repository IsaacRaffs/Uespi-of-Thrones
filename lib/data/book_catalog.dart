import 'package:flutter/material.dart';

import 'guild_data.dart';

/// Um livro é associado diretamente ao ID estável da guilda.
/// O preço elevado é intencional: 10.000 coins por tomo.
class GuildBook {
  final String guildId;
  final String title;
  final String subtitle;
  final IconData icon;
  final List<KnowledgeChapter> chapters;

  const GuildBook({
    required this.guildId,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.chapters,
  });

  static const int price = 100;
}

class KnowledgeChapter {
  final String title;
  final String summary;
  final List<String> topics;

  const KnowledgeChapter(this.title, this.summary, this.topics);
}

final List<GuildBook> guildBooks = [
  GuildBook(
    guildId: 'psicologia',
    title: 'Tratado da Mente Humana',
    subtitle: 'O saber dos estudiosos da psique',
    icon: Icons.psychology,
    chapters: [
      KnowledgeChapter(
        'Fundamentos da Psicologia',
        'Estudo científico do comportamento e dos processos mentais.',
        [
          'História da Psicologia',
          'Métodos de pesquisa',
          'Comportamento e cognição',
        ],
      ),
      KnowledgeChapter(
        'Processos psicológicos',
        'Estudo de como as pessoas percebem, aprendem, lembram e sentem.',
        ['Percepção e atenção', 'Memória e aprendizagem', 'Emoção e motivação'],
      ),
      KnowledgeChapter(
        'Desenvolvimento e sociedade',
        'Compreensão do desenvolvimento humano e das relações sociais.',
        [
          'Desenvolvimento ao longo da vida',
          'Personalidade',
          'Psicologia social',
        ],
      ),
    ],
  ),
  GuildBook(
    guildId: 'engenharia_civil',
    title: 'Códice dos Grandes Construtores',
    subtitle: 'A arte de erguer pontes e fortalezas',
    icon: Icons.architecture,
    chapters: [
      KnowledgeChapter(
        'Materiais e estruturas',
        'Propriedades dos materiais e comportamento das estruturas.',
        ['Concreto e aço', 'Esforços e tensões', 'Resistência dos materiais'],
      ),
      KnowledgeChapter(
        'Construção e planejamento',
        'Métodos para planejar, executar e acompanhar obras.',
        [
          'Tecnologia da construção',
          'Orçamento e cronograma',
          'Segurança do trabalho',
        ],
      ),
      KnowledgeChapter(
        'Território e infraestrutura',
        'Fundamentos das obras que organizam cidades e terrenos.',
        ['Topografia', 'Geotecnia', 'Transportes e saneamento'],
      ),
    ],
  ),
  GuildBook(
    guildId: 'engenharia_eletrica',
    title: 'Manual das Forças Invisíveis',
    subtitle: 'Os segredos da energia e dos circuitos',
    icon: Icons.bolt,
    chapters: [
      KnowledgeChapter(
        'Circuitos elétricos',
        'Grandezas e leis fundamentais para analisar circuitos.',
        [
          'Tensão, corrente e resistência',
          'Leis de Ohm e Kirchhoff',
          'Circuitos CA e CC',
        ],
      ),
      KnowledgeChapter(
        'Eletrônica e sistemas',
        'Componentes e sistemas usados no controle de sinais e energia.',
        ['Semicondutores', 'Eletrônica analógica', 'Eletrônica digital'],
      ),
      KnowledgeChapter(
        'Energia e máquinas',
        'Conversão, geração, transmissão e utilização da energia.',
        ['Máquinas elétricas', 'Sistemas de potência', 'Instalações elétricas'],
      ),
    ],
  ),
  GuildBook(
    guildId: 'zootecnia',
    title: 'Bestiário e Tratado dos Rebanhos',
    subtitle: 'O conhecimento sobre criação e produção animal',
    icon: Icons.pets,
    chapters: [
      KnowledgeChapter(
        'Produção animal',
        'Princípios de criação, manejo e bem-estar dos animais.',
        ['Sistemas de produção', 'Bem-estar animal', 'Manejo de rebanhos'],
      ),
      KnowledgeChapter(
        'Nutrição e genética',
        'Bases para alimentação, melhoramento e saúde produtiva.',
        ['Nutrição animal', 'Melhoramento genético', 'Reprodução'],
      ),
      KnowledgeChapter(
        'Ambiente e sustentabilidade',
        'Relação entre produção animal e recursos naturais.',
        ['Pastagens e forragicultura', 'Sanidade', 'Produção sustentável'],
      ),
    ],
  ),
  GuildBook(
    guildId: 'historia',
    title: 'Crônicas das Eras e Civilizações',
    subtitle: 'A memória dos povos e dos reinos',
    icon: Icons.history_edu,
    chapters: [
      KnowledgeChapter(
        'Ofício do historiador',
        'Como se produz conhecimento histórico a partir de evidências.',
        ['Fontes históricas', 'Tempo e memória', 'Historiografia'],
      ),
      KnowledgeChapter(
        'Sociedades e poder',
        'Transformações políticas, econômicas e culturais ao longo do tempo.',
        ['Antiguidade e medievo', 'Estado e sociedade', 'Cultura e religião'],
      ),
      KnowledgeChapter(
        'História do Brasil',
        'Processos de formação da sociedade brasileira.',
        ['Colonização', 'Império e República', 'História do Piauí'],
      ),
    ],
  ),
  GuildBook(
    guildId: 'medicina',
    title: 'Compêndio da Arte da Cura',
    subtitle: 'Os fundamentos do corpo e da saúde',
    icon: Icons.medical_services,
    chapters: [
      KnowledgeChapter(
        'Bases biomédicas',
        'Organização e funcionamento do organismo humano.',
        ['Anatomia', 'Fisiologia', 'Bioquímica'],
      ),
      KnowledgeChapter(
        'Doenças e diagnóstico',
        'Fundamentos para compreender doenças e investigação clínica.',
        ['Microbiologia e imunologia', 'Patologia', 'Semiologia'],
      ),
      KnowledgeChapter(
        'Cuidado e saúde coletiva',
        'Princípios de prevenção, cuidado e organização da saúde.',
        ['Farmacologia', 'Epidemiologia', 'Atenção à saúde'],
      ),
    ],
  ),
  GuildBook(
    guildId: 'fisica',
    title: 'Grimório das Leis do Universo',
    subtitle: 'As leis que regem matéria e energia',
    icon: Icons.science,
    chapters: [
      KnowledgeChapter(
        'Mecânica',
        'Descrição matemática do movimento e das interações.',
        ['Cinemática', 'Dinâmica', 'Energia e conservação'],
      ),
      KnowledgeChapter(
        'Campos e ondas',
        'Estudo dos fenômenos eletromagnéticos e ondulatórios.',
        ['Eletromagnetismo', 'Oscilações', 'Ondas e óptica'],
      ),
      KnowledgeChapter(
        'Física moderna',
        'Modelos físicos desenvolvidos para escalas atômicas e relativísticas.',
        ['Termodinâmica', 'Relatividade', 'Mecânica quântica'],
      ),
    ],
  ),
  GuildBook(
    guildId: 'educacao_fisica',
    title: 'Livro dos Corpos e da Disciplina',
    subtitle: 'Movimento, saúde e desempenho',
    icon: Icons.fitness_center,
    chapters: [
      KnowledgeChapter(
        'Corpo e movimento',
        'Bases biológicas e biomecânicas do movimento humano.',
        ['Anatomia funcional', 'Fisiologia do exercício', 'Biomecânica'],
      ),
      KnowledgeChapter(
        'Treinamento',
        'Princípios de preparação física e desenvolvimento motor.',
        [
          'Capacidades físicas',
          'Planejamento do treino',
          'Aprendizagem motora',
        ],
      ),
      KnowledgeChapter(
        'Educação e saúde',
        'Práticas corporais em contextos educativos e de promoção da saúde.',
        [
          'Esporte e sociedade',
          'Educação física escolar',
          'Atividade física e saúde',
        ],
      ),
    ],
  ),
  GuildBook(
    guildId: 'computacao',
    title: 'Grande Tomo da Computação',
    subtitle: 'A lógica por trás das máquinas',
    icon: Icons.computer,
    chapters: [
      KnowledgeChapter(
        'Algoritmos e programação',
        'Representação de soluções e construção de programas.',
        [
          'Lógica de programação',
          'Estruturas de dados',
          'Análise de algoritmos',
        ],
      ),
      KnowledgeChapter(
        'Sistemas computacionais',
        'Organização do hardware e dos sistemas que executam programas.',
        [
          'Arquitetura de computadores',
          'Sistemas operacionais',
          'Redes de computadores',
        ],
      ),
      KnowledgeChapter(
        'Engenharia de software e dados',
        'Construção de sistemas confiáveis e gerenciamento de informação.',
        ['Engenharia de software', 'Banco de dados', 'Inteligência artificial'],
      ),
    ],
  ),
  GuildBook(
    guildId: 'quimica',
    title: 'Caderno dos Alquimistas',
    subtitle: 'A ciência das transformações da matéria',
    icon: Icons.biotech,
    chapters: [
      KnowledgeChapter(
        'Fundamentos da matéria',
        'Estrutura, propriedades e transformações químicas.',
        ['Estrutura atômica', 'Ligações químicas', 'Estequiometria'],
      ),
      KnowledgeChapter(
        'Ramos da Química',
        'Modelos e métodos para estudar substâncias e reações.',
        ['Química orgânica', 'Química inorgânica', 'Físico-química'],
      ),
      KnowledgeChapter(
        'Análise e ambiente',
        'Técnicas de identificação e estudo químico do ambiente.',
        ['Química analítica', 'Métodos instrumentais', 'Química ambiental'],
      ),
    ],
  ),
  GuildBook(
    guildId: 'letras',
    title: 'Antologia das Línguas e Letras',
    subtitle: 'Palavras, narrativas e culturas',
    icon: Icons.menu_book,
    chapters: [
      KnowledgeChapter(
        'Estudos da linguagem',
        'Estruturas, usos e funcionamento das línguas.',
        ['Linguística', 'Fonética e fonologia', 'Morfossintaxe'],
      ),
      KnowledgeChapter(
        'Literatura',
        'Leitura e interpretação de obras e movimentos literários.',
        [
          'Teoria literária',
          'Literatura brasileira',
          'Literaturas de língua portuguesa',
        ],
      ),
      KnowledgeChapter(
        'Língua e ensino',
        'Práticas de leitura, escrita, tradução e ensino.',
        ['Produção textual', 'Linguística aplicada', 'Didática de línguas'],
      ),
    ],
  ),
  GuildBook(
    guildId: 'biologia',
    title: 'Atlas da Vida e da Natureza',
    subtitle: 'Os mistérios dos seres vivos',
    icon: Icons.eco,
    chapters: [
      KnowledgeChapter(
        'Organização da vida',
        'Estruturas e processos que caracterizam os seres vivos.',
        ['Biologia celular', 'Genética', 'Evolução'],
      ),
      KnowledgeChapter(
        'Diversidade biológica',
        'Diversidade, classificação e relações entre organismos.',
        ['Zoologia', 'Botânica', 'Microbiologia'],
      ),
      KnowledgeChapter(
        'Ecossistemas',
        'Interações entre organismos e o ambiente.',
        ['Ecologia', 'Conservação', 'Biologia ambiental'],
      ),
    ],
  ),
  GuildBook(
    guildId: 'direito',
    title: 'Código das Leis e da Justiça',
    subtitle: 'As normas que sustentam a sociedade',
    icon: Icons.gavel,
    chapters: [
      KnowledgeChapter(
        'Fundamentos jurídicos',
        'Conceitos, fontes e interpretação do Direito.',
        [
          'Introdução ao Direito',
          'Filosofia e teoria do Direito',
          'Hermenêutica jurídica',
        ],
      ),
      KnowledgeChapter(
        'Direito público e privado',
        'Relações jurídicas entre pessoas, Estado e instituições.',
        ['Direito constitucional', 'Direito administrativo', 'Direito civil'],
      ),
      KnowledgeChapter(
        'Justiça e sociedade',
        'Instituições e instrumentos de resolução de conflitos.',
        ['Direito penal', 'Direito processual', 'Direitos humanos'],
      ),
    ],
  ),
  GuildBook(
    guildId: 'jornalismo',
    title: 'Anais dos Arautos da Verdade',
    subtitle: 'A arte de investigar e informar',
    icon: Icons.campaign,
    chapters: [
      KnowledgeChapter(
        'Fundamentos da comunicação',
        'Teorias e processos de produção da comunicação.',
        [
          'Teorias da comunicação',
          'Ética jornalística',
          'História da imprensa',
        ],
      ),
      KnowledgeChapter(
        'Prática jornalística',
        'Métodos de apuração, escrita e edição de notícias.',
        ['Reportagem e entrevista', 'Redação jornalística', 'Edição'],
      ),
      KnowledgeChapter(
        'Mídias e sociedade',
        'Transformações tecnológicas e impactos da informação.',
        ['Jornalismo digital', 'Fotojornalismo', 'Comunicação pública'],
      ),
    ],
  ),
  GuildBook(
    guildId: 'turismo',
    title: 'Cartografia dos Grandes Viajantes',
    subtitle: 'Territórios, culturas e hospitalidade',
    icon: Icons.travel_explore,
    chapters: [
      KnowledgeChapter(
        'Fundamentos do turismo',
        'Conceitos e organização da atividade turística.',
        ['Teoria do turismo', 'Hospitalidade', 'Planejamento turístico'],
      ),
      KnowledgeChapter(
        'Território e patrimônio',
        'Relações entre turismo, cultura, espaço e patrimônio.',
        [
          'Geografia do turismo',
          'Patrimônio cultural',
          'Turismo e meio ambiente',
        ],
      ),
      KnowledgeChapter(
        'Gestão e experiências',
        'Organização de destinos, serviços e experiências de visitação.',
        ['Gestão de destinos', 'Eventos', 'Economia do turismo'],
      ),
    ],
  ),
];

GuildBook? bookForGuild(String guildId) {
  for (final book in guildBooks) {
    if (book.guildId == guildId) return book;
  }
  return null;
}
