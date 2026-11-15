class CourseQuestion {
  final String id;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String hint;

  const CourseQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.hint,
  });
}

final Map<String, List<CourseQuestion>> courseQuestions = {
  'psicologia': [
    CourseQuestion(
      id: 'psi_1',
      question: 'Quem é considerado o fundador da psicanálise?',
      options: ['Carl Jung', 'Sigmund Freud', 'Skinner', 'Piaget'],
      correctIndex: 1,
      hint: 'Foi um médico austríaco que desenvolveu a teoria do inconsciente.',
    ),
    CourseQuestion(
      id: 'psi_2',
      question: 'Qual processo está relacionado à aquisição de informações?',
      options: ['Memória', 'Reflexo', 'Instinto', 'Equilíbrio'],
      correctIndex: 0,
      hint: 'É a capacidade de armazenar e recuperar experiências.',
    ),
    CourseQuestion(
      id: 'psi_3',
      question: 'Qual abordagem enfatiza a autorrealização humana?',
      options: ['Behaviorismo', 'Humanismo', 'Estruturalismo', 'Reflexologia'],
      correctIndex: 1,
      hint: 'Essa abordagem valoriza o potencial e o desenvolvimento pessoal.',
    ),
  ],

  'engenharia_civil': [
    CourseQuestion(
      id: 'civil_1',
      question: 'Qual material é amplamente utilizado em estruturas de concreto armado?',
      options: ['Madeira', 'Aço', 'Vidro', 'PVC'],
      correctIndex: 1,
      hint: 'É o material responsável principalmente por resistir aos esforços de tração.',
    ),
    CourseQuestion(
      id: 'civil_2',
      question: 'Qual grandeza representa a força por unidade de área?',
      options: ['Velocidade', 'Pressão', 'Potência', 'Temperatura'],
      correctIndex: 1,
      hint: 'Sua unidade no SI é o Pascal.',
    ),
    CourseQuestion(
      id: 'civil_3',
      question: 'Qual ensaio avalia a consistência do concreto fresco?',
      options: [
        'Slump test',
        'Ensaio Charpy',
        'Ensaio de dureza',
        'Ensaio de tração do aço',
      ],
      correctIndex: 0,
      hint:
          'É conhecido no Brasil como ensaio de abatimento do tronco de cone.',
    ),
  ],

  'engenharia_eletrica': [
    CourseQuestion(
      id: 'eletrica_1',
      question: 'Qual é a unidade de corrente elétrica?',
      options: ['Volt', 'Ohm', 'Ampere', 'Watt'],
      correctIndex: 2,
      hint: 'Seu símbolo é A.',
    ),
    CourseQuestion(
      id: 'eletrica_2',
      question: 'Qual lei relaciona tensão, corrente e resistência?',
      options: ['Lei de Newton', 'Lei de Ohm', 'Lei de Hooke', 'Lei de Snell'],
      correctIndex: 1,
      hint: 'A relação pode ser escrita como V = R × I.',
    ),
    CourseQuestion(
      id: 'eletrica_3',
      question: 'Qual componente armazena energia em um campo elétrico?',
      options: ['Resistor', 'Capacitor', 'Diodo', 'Fusível'],
      correctIndex: 1,
      hint: 'Sua capacitância é medida em Farads.',
    ),
  ],

  'zootecnia': [
    CourseQuestion(
      id: 'zoo_1',
      question: 'Qual nutriente é fundamental para a formação e reparação dos tecidos?',
      options: ['Proteína', 'Água', 'Fibra', 'Vitamina C'],
      correctIndex: 0,
      hint: 'É formado por cadeias de aminoácidos.',
    ),
    CourseQuestion(
      id: 'zoo_2',
      question: 'Qual é o principal objetivo do melhoramento genético animal?',
      options: [
        'Reduzir a alimentação',
        'Selecionar características desejáveis',
        'Eliminar a reprodução',
        'Diminuir a diversidade ambiental',
      ],
      correctIndex: 1,
      hint: 'Envolve seleção de indivíduos com características hereditárias de interesse.',
    ),
    CourseQuestion(
      id: 'zoo_3',
      question: 'Qual órgão é responsável pela maior parte da fermentação em bovinos?',
      options: ['Abomaso', 'Rúmen', 'Intestino grosso', 'Fígado'],
      correctIndex: 1,
      hint: 'É a maior câmara do estômago dos ruminantes.',
    ),
  ],

  'historia': [
    CourseQuestion(
      id: 'hist_1',
      question: 'Em qual ano ocorreu a Proclamação da República no Brasil?',
      options: ['1822', '1888', '1889', '1891'],
      correctIndex: 2,
      hint: 'Aconteceu no final do século XIX, um ano depois da Abolição.',
    ),
    CourseQuestion(
      id: 'hist_2',
      question: 'Qual civilização construiu as pirâmides de Gizé?',
      options: ['Romana', 'Egípcia', 'Grega', 'Persa'],
      correctIndex: 1,
      hint: 'Essa civilização floresceu às margens do rio Nilo.',
    ),
    CourseQuestion(
      id: 'hist_3',
      question: 'Qual acontecimento marcou o início convencional da Idade Contemporânea?',
      options: [
        'Queda de Roma',
        'Revolução Francesa',
        'Reforma Protestante',
        'Primeira Guerra Mundial',
      ],
      correctIndex: 1,
      hint: 'Ocorreu em 1789.',
    ),
  ],

  'medicina': [
    CourseQuestion(
      id: 'med_1',
      question: 'Qual órgão bombeia o sangue pelo corpo?',
      options: ['Pulmão', 'Fígado', 'Coração', 'Rim'],
      correctIndex: 2,
      hint: 'É um órgão muscular do sistema circulatório.',
    ),
    CourseQuestion(
      id: 'med_2',
      question: 'Qual célula sanguínea transporta oxigênio?',
      options: ['Plaqueta', 'Hemácia', 'Leucócito', 'Neurônio'],
      correctIndex: 1,
      hint: 'É rica em hemoglobina.',
    ),
    CourseQuestion(
      id: 'med_3',
      question: 'Qual sistema é responsável pela defesa imunológica?',
      options: ['Digestório', 'Imunológico', 'Endócrino', 'Esquelético'],
      correctIndex: 1,
      hint: 'Envolve células e órgãos que reconhecem agentes invasores.',
    ),
  ],

  'fisica': [
    CourseQuestion(
      id: 'fis_1',
      question: 'Qual é a unidade de força no Sistema Internacional?',
      options: ['Joule', 'Newton', 'Watt', 'Pascal'],
      correctIndex: 1,
      hint: 'Recebe o nome de um famoso físico inglês.',
    ),
    CourseQuestion(
      id: 'fis_2',
      question: 'Qual é a velocidade aproximada da luz no vácuo?',
      options: ['300 km/s', '3.000 km/s', '300.000 km/s', '3.000.000 km/s'],
      correctIndex: 2,
      hint: 'É aproximadamente trezentos mil quilômetros por segundo.',
    ),
    CourseQuestion(
      id: 'fis_3',
      question: 'Qual princípio afirma que energia não pode ser criada nem destruída?',
      options: [
        'Conservação da energia',
        'Inércia',
        'Ação e reação',
        'Princípio de Pascal',
      ],
      correctIndex: 0,
      hint: 'A energia pode ser transformada, mas a quantidade total se conserva.',
    ),
  ],

  'educacao_fisica': [
    CourseQuestion(
      id: 'edfis_1',
      question: 'Qual capacidade física está relacionada à manutenção de esforço prolongado?',
      options: ['Flexibilidade', 'Resistência', 'Agilidade', 'Coordenação'],
      correctIndex: 1,
      hint: 'É essencial em atividades aeróbicas de longa duração.',
    ),
    CourseQuestion(
      id: 'edfis_2',
      question: 'Qual sistema fornece grande parte do ATP em atividades aeróbicas prolongadas?',
      options: ['Oxidativo', 'Fosfagênio', 'Anaeróbico alático', 'Nenhum'],
      correctIndex: 0,
      hint: 'Utiliza oxigênio para produzir energia.',
    ),
    CourseQuestion(
      id: 'edfis_3',
      question: 'Qual é a principal função do aquecimento antes do exercício?',
      options: [
        'Causar fadiga',
        'Preparar o organismo',
        'Reduzir a circulação',
        'Substituir o treinamento',
      ],
      correctIndex: 1,
      hint: 'Ajuda a preparar músculos e sistemas fisiológicos para o esforço.',
    ),
  ],

  'computacao': [
    CourseQuestion(
      id: 'comp_1',
      question: 'Qual estrutura de dados segue o princípio LIFO?',
      options: ['Fila', 'Pilha', 'Árvore', 'Grafo'],
      correctIndex: 1,
      hint: 'O último elemento inserido é o primeiro a sair.',
    ),
    CourseQuestion(
      id: 'comp_2',
      question: 'Qual algoritmo é conhecido por utilizar a estratégia dividir para conquistar?',
      options: ['Bubble Sort', 'Merge Sort', 'Linear Search', 'Counting Sort'],
      correctIndex: 1,
      hint: 'Ele divide o vetor em partes menores e depois combina as partes ordenadas.',
    ),
    CourseQuestion(
      id: 'comp_3',
      question: 'Qual é a complexidade média de busca em uma tabela hash bem dimensionada?',
      options: ['O(n²)', 'O(log n)', 'O(1)', 'O(n log n)'],
      correctIndex: 2,
      hint:
          'O acesso médio não depende linearmente da quantidade de elementos.',
    ),
  ],

  'quimica': [
    CourseQuestion(
      id: 'quim_1',
      question: 'Qual é o símbolo químico do ouro?',
      options: ['Ag', 'Au', 'Fe', 'O'],
      correctIndex: 1,
      hint: 'Seu símbolo vem do nome latino Aurum.',
    ),
    CourseQuestion(
      id: 'quim_2',
      question: 'Qual partícula possui carga elétrica negativa?',
      options: ['Próton', 'Nêutron', 'Elétron', 'Núcleo'],
      correctIndex: 2,
      hint: 'É encontrada na eletrosfera do átomo.',
    ),
    CourseQuestion(
      id: 'quim_3',
      question: 'Qual escala é utilizada para medir acidez e basicidade?',
      options: ['Richter', 'pH', 'Celsius', 'Kelvin'],
      correctIndex: 1,
      hint: 'Valores abaixo de 7 indicam caráter ácido em condições usuais.',
    ),
  ],

  'letras': [
    CourseQuestion(
      id: 'letras_1',
      question: 'Qual figura de linguagem estabelece uma comparação implícita?',
      options: ['Metáfora', 'Hipérbole', 'Ironia', 'Eufemismo'],
      correctIndex: 0,
      hint: 'É comum em expressões como "a vida é uma viagem".',
    ),
    CourseQuestion(
      id: 'letras_2',
      question: 'Qual autor escreveu Dom Casmurro?',
      options: [
        'José de Alencar',
        'Machado de Assis',
        'Graciliano Ramos',
        'Carlos Drummond de Andrade',
      ],
      correctIndex: 1,
      hint: 'É um dos principais representantes do Realismo brasileiro.',
    ),
    CourseQuestion(
      id: 'letras_3',
      question:
          'Qual classe gramatical caracteriza ou qualifica um substantivo?',
      options: ['Verbo', 'Advérbio', 'Adjetivo', 'Preposição'],
      correctIndex: 2,
      hint: 'Em "casa bonita", essa classe é representada pela palavra bonita.',
    ),
  ],

  'biologia': [
    CourseQuestion(
      id: 'bio_1',
      question:
          'Qual organela é conhecida como responsável pela produção de ATP?',
      options: ['Ribossomo', 'Mitocôndria', 'Lisossomo', 'Complexo golgiense'],
      correctIndex: 1,
      hint: 'É fundamental para a respiração celular aeróbica.',
    ),
    CourseQuestion(
      id: 'bio_2',
      question: 'Qual molécula armazena a informação genética?',
      options: ['ATP', 'DNA', 'Glicose', 'Colesterol'],
      correctIndex: 1,
      hint: 'Sua estrutura é formada por uma dupla hélice.',
    ),
    CourseQuestion(
      id: 'bio_3',
      question: 'Qual processo permite que plantas produzam matéria orgânica usando luz?',
      options: [
        'Fermentação',
        'Fotossíntese',
        'Respiração anaeróbica',
        'Osmose',
      ],
      correctIndex: 1,
      hint: 'Envolve clorofila, água e dióxido de carbono.',
    ),
  ],

  'direito': [
    CourseQuestion(
      id: 'dir_1',
      question: 'Qual documento é considerado a Constituição Federal vigente do Brasil?',
      options: [
        'Constituição de 1824',
        'Constituição de 1934',
        'Constituição de 1988',
        'Constituição de 1967',
      ],
      correctIndex: 2,
      hint: 'Foi promulgada após o período da ditadura militar.',
    ),
    CourseQuestion(
      id: 'dir_2',
      question: 'Qual poder tem como função típica elaborar leis?',
      options: ['Executivo', 'Legislativo', 'Judiciário', 'Moderador'],
      correctIndex: 1,
      hint: 'No âmbito federal, é exercido pelo Congresso Nacional.',
    ),
    CourseQuestion(
      id: 'dir_3',
      question: 'Qual princípio estabelece que ninguém será considerado culpado até o trânsito em julgado?',
      options: [
        'Legalidade',
        'Presunção de inocência',
        'Publicidade',
        'Eficiência',
      ],
      correctIndex: 1,
      hint: 'Está previsto no artigo 5º da Constituição Federal.',
    ),
  ],

  'jornalismo': [
    CourseQuestion(
      id: 'jor_1',
      question: 'Qual elemento jornalístico resume as principais informações de uma notícia?',
      options: ['Legenda', 'Lead', 'Editorial', 'Expediente'],
      correctIndex: 1,
      hint: 'Geralmente responde quem, o quê, quando, onde, como e por quê.',
    ),
    CourseQuestion(
      id: 'jor_2',
      question: 'Qual princípio exige a verificação das informações antes da publicação?',
      options: [
        'Sensacionalismo',
        'Apuração',
        'Publicidade comercial',
        'Opinião pessoal',
      ],
      correctIndex: 1,
      hint: 'Envolve checar fontes e evidências.',
    ),
    CourseQuestion(
      id: 'jor_3',
      question: 'Qual gênero jornalístico expressa uma posição institucional do veículo?',
      options: ['Editorial', 'Entrevista', 'Nota policial', 'Legenda'],
      correctIndex: 0,
      hint: 'Representa a opinião oficial de um jornal ou veículo.',
    ),
  ],

  'turismo': [
    CourseQuestion(
      id: 'tur_1',
      question: 'Qual conceito está associado à capacidade de um destino receber visitantes sem comprometer seus recursos?',
      options: [
        'Turismo predatório',
        'Capacidade de carga',
        'Turismo de massa',
        'Sazonalidade',
      ],
      correctIndex: 1,
      hint: 'Está relacionado ao limite de visitantes que um local consegue suportar.',
    ),
    CourseQuestion(
      id: 'tur_2',
      question: 'Qual organização internacional é especializada em turismo?',
      options: ['OMS', 'OMT/ONU Turismo', 'OIT', 'UNESCO'],
      correctIndex: 1,
      hint: 'É uma agência especializada das Nações Unidas para o setor turístico.',
    ),
    CourseQuestion(
      id: 'tur_3',
      question: 'Qual modalidade de turismo valoriza a natureza e a conservação ambiental?',
      options: [
        'Turismo de negócios',
        'Ecoturismo',
        'Turismo industrial',
        'Turismo de compras',
      ],
      correctIndex: 1,
      hint: 'Prioriza experiências em ambientes naturais com responsabilidade ambiental.',
    ),
  ],
};
