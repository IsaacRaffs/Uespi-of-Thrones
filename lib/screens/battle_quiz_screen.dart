import 'dart:async';

import 'package:flutter/material.dart';

import '../data/course_questions.dart';
import '../services/audio_service.dart';
import '../widgets/guild_crest.dart';

class _BattleColors {
  static const background = Color(0xFF211B19);
  static const stone = Color(0xFF30251F);
  static const stoneLight = Color(0xFF45352A);
  static const gold = Color(0xFFD6AD55);
  static const parchment = Color(0xFFE8D2A5);
  static const parchmentDark = Color(0xFFB99863);
  static const ink = Color(0xFF352619);
  static const red = Color(0xFF922F2F);
  static const green = Color(0xFF527D49);
}

class BattleQuizScreen extends StatefulWidget {
  final String playerGuildId;
  final String opponentGuildId;
  final String opponentName;
  final List<CourseQuestion> questions;

  const BattleQuizScreen({
    super.key,
    required this.playerGuildId,
    required this.opponentGuildId,
    required this.opponentName,
    required this.questions,
  });

  @override
  State<BattleQuizScreen> createState() => _BattleQuizScreenState();
}

class _BattleQuizScreenState extends State<BattleQuizScreen> {
  int currentQuestion = 0;
  int correctAnswers = 0;

  int? selectedOption;
  bool answered = false;
  bool? lastWasCorrect;

  Timer? countdownTimer;

  int remainingSeconds = 10;

  final List<int> questionTimes = [10, 7, 5];

  int get questionTime => questionTimes[currentQuestion];

  @override
  void initState() {
    super.initState();

    AudioService.instance.playBattleMusic();

    startCountdown();
  }

  void startCountdown() {
    countdownTimer?.cancel();

    remainingSeconds = questionTime;

    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || answered) {
        timer.cancel();
        return;
      }

      if (remainingSeconds <= 1) {
        timer.cancel();

        setState(() {
          remainingSeconds = 0;
          answered = true;
          lastWasCorrect = false;
          selectedOption = null;
        });
      } else {
        setState(() {
          remainingSeconds--;
        });
      }
    });
  }

  void answer(int index) {
    if (answered) return;

    AudioService.instance.playClick();

    countdownTimer?.cancel();

    final question = widget.questions[currentQuestion];
    final correct = index == question.correctIndex;

    setState(() {
      selectedOption = index;
      answered = true;
      lastWasCorrect = correct;

      if (correct) {
        correctAnswers++;
      }
    });
  }

  void nextQuestion() {
    if (!answered) return;

    AudioService.instance.playClick();

    if (currentQuestion < widget.questions.length - 1) {
      setState(() {
        currentQuestion++;
        selectedOption = null;
        answered = false;
        lastWasCorrect = null;
      });

      startCountdown();
    } else {
      countdownTimer?.cancel();

      Navigator.pop(context, correctAnswers >= 2);
    }
  }

  @override
  void dispose() {
    countdownTimer?.cancel();

    AudioService.instance.playExplorationMusic();

    super.dispose();
  }

  Widget _crest({
    required String guildId,
    required String label,
    required Color fallbackColor,
  }) {
    return Column(
      children: [
        GuildCrest(
          guildId: guildId,
          size: 68,
          fallbackColor: fallbackColor,
          frameColor: _BattleColors.gold,
          backgroundColor: _BattleColors.stone,
        ),
        const SizedBox(height: 5),
        SizedBox(
          width: 100,
          child: Text(
            label.toUpperCase(),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _BattleColors.parchment,
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.7,
            ),
          ),
        ),
      ],
    );
  }

  Widget _battleHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 16),
      decoration: BoxDecoration(
        color: _BattleColors.stone,
        border: Border.all(color: _BattleColors.gold, width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          const Text(
            'CAMPO DE BATALHA',
            style: TextStyle(
              color: _BattleColors.gold,
              fontWeight: FontWeight.w900,
              fontSize: 13,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 13),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _crest(
                guildId: widget.playerGuildId,
                fallbackColor: _BattleColors.gold,
                label: 'Seu reino',
              ),
              const Column(
                children: [
                  Icon(Icons.gavel, color: _BattleColors.red, size: 34),
                  SizedBox(height: 4),
                  Text(
                    'VS',
                    style: TextStyle(
                      color: _BattleColors.gold,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              _crest(
                guildId: widget.opponentGuildId,
                fallbackColor: const Color(0xFFB94B45),
                label: widget.opponentName,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _questionProgress() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'PROGRESSO DA GUERRA',
              style: TextStyle(
                color: _BattleColors.gold,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            Text(
              'PERGUNTA ${currentQuestion + 1}/3',
              style: const TextStyle(
                color: _BattleColors.parchment,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(3, (index) {
            final completed = index < currentQuestion;
            final active = index == currentQuestion;

            return Expanded(
              child: Container(
                height: 9,
                margin: const EdgeInsets.only(right: 5),
                decoration: BoxDecoration(
                  color: completed
                      ? _BattleColors.green
                      : active
                      ? _BattleColors.gold
                      : Colors.white12,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: _BattleColors.gold.withValues(alpha: 0.4),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _timerPanel(Color timerColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: timerColor.withValues(alpha: 0.13),
        border: Border.all(color: timerColor, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.hourglass_bottom, color: timerColor, size: 28),
          const SizedBox(width: 12),
          Column(
            children: [
              Text(
                answered ? 'TURNO ENCERRADO' : 'TEMPO PARA RESPONDER',
                style: TextStyle(
                  color: timerColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 9,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                answered ? '---' : '$remainingSeconds SEGUNDOS',
                style: TextStyle(
                  color: timerColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _questionPanel(String question) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _BattleColors.parchment,
        border: Border.all(color: _BattleColors.gold, width: 3),
        borderRadius: BorderRadius.circular(9),
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.menu_book, color: _BattleColors.ink, size: 29),
          const SizedBox(height: 9),
          const Text(
            'DESAFIO DO CONHECIMENTO',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _BattleColors.parchmentDark,
              fontWeight: FontWeight.w900,
              fontSize: 10,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            question,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _BattleColors.ink,
              fontSize: 18,
              fontWeight: FontWeight.w900,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _answerOption(int index, String option) {
    final isSelected = selectedOption == index;

    Color background = _BattleColors.stone;
    Color border = const Color(0xFF705638);
    Color foreground = _BattleColors.parchment;
    IconData? trailingIcon;

    if (answered && isSelected) {
      if (lastWasCorrect == true) {
        background = _BattleColors.green;
        border = const Color(0xFF8BC47C);
        trailingIcon = Icons.check_circle;
      } else {
        background = _BattleColors.red;
        border = const Color(0xFFD77B72);
        trailingIcon = Icons.cancel;
      }
    } else if (!answered && isSelected) {
      background = _BattleColors.stoneLight;
      border = _BattleColors.gold;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: answered ? null : () => answer(index),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: border, width: 1.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Container(
                  width: 31,
                  height: 31,
                  decoration: BoxDecoration(
                    color: _BattleColors.parchment,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text(
                      String.fromCharCode(65 + index),
                      style: const TextStyle(
                        color: _BattleColors.ink,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    option,
                    style: TextStyle(
                      color: foreground,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                ),
                if (trailingIcon != null)
                  Icon(trailingIcon, color: Colors.white, size: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _answerFeedback() {
    final correct = lastWasCorrect == true;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: correct
            ? _BattleColors.green.withValues(alpha: 0.2)
            : _BattleColors.red.withValues(alpha: 0.2),
        border: Border.all(
          color: correct ? _BattleColors.green : _BattleColors.red,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            correct ? Icons.check_circle : Icons.warning,
            color: correct ? const Color(0xFF8BC47C) : const Color(0xFFD77B72),
            size: 25,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              correct
                  ? 'Resposta correta! Suas tropas avançam.'
                  : remainingSeconds == 0
                  ? 'Tempo esgotado! Você não pontuou.'
                  : 'Resposta incorreta! A resposta correta não será revelada.',
              style: const TextStyle(
                color: _BattleColors.parchment,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _scorePanel() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: _BattleColors.stone,
        border: Border.all(color: _BattleColors.gold.withValues(alpha: 0.6)),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'ACERTOS CONFIRMADOS',
            style: TextStyle(
              color: _BattleColors.parchment,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.7,
            ),
          ),
          Row(
            children: List.generate(3, (index) {
              return Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Icon(
                  Icons.shield,
                  size: 20,
                  color: index < correctAnswers
                      ? _BattleColors.gold
                      : Colors.white24,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.questions[currentQuestion];

    final timerColor = remainingSeconds <= 3
        ? const Color(0xFFD94B42)
        : remainingSeconds <= 5
        ? const Color(0xFFE5A33D)
        : _BattleColors.green;

    return Scaffold(
      backgroundColor: _BattleColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: _BattleColors.stone,
        foregroundColor: _BattleColors.parchment,
        elevation: 4,
        title: const Row(
          children: [
            const Icon(Icons.gavel, color: _BattleColors.gold, size: 23),
            SizedBox(width: 10),
            Text(
              'CONFRONTO ENTRE GUILDAS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _battleHeader(),

                    const SizedBox(height: 20),

                    _questionProgress(),

                    const SizedBox(height: 17),

                    _timerPanel(timerColor),

                    const SizedBox(height: 20),

                    _questionPanel(question.question),

                    const SizedBox(height: 17),

                    const Text(
                      'ESCOLHA SUA RESPOSTA',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _BattleColors.gold,
                        fontWeight: FontWeight.w900,
                        fontSize: 11,
                        letterSpacing: 1.5,
                      ),
                    ),

                    const SizedBox(height: 12),

                    ...List.generate(
                      question.options.length,
                      (index) => _answerOption(index, question.options[index]),
                    ),

                    if (answered) ...[
                      const SizedBox(height: 5),
                      _answerFeedback(),
                    ],

                    const SizedBox(height: 15),

                    _scorePanel(),
                  ],
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.fromLTRB(15, 11, 15, 14),
              decoration: const BoxDecoration(
                color: _BattleColors.stone,
                border: Border(
                  top: BorderSide(color: _BattleColors.gold, width: 1.5),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: answered
                        ? _BattleColors.gold
                        : Colors.grey.shade800,
                    foregroundColor: _BattleColors.ink,
                    disabledBackgroundColor: Colors.grey.shade800,
                    disabledForegroundColor: Colors.white38,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                      side: const BorderSide(
                        color: _BattleColors.parchmentDark,
                        width: 1.5,
                      ),
                    ),
                  ),
                  onPressed: answered ? nextQuestion : null,
                  icon: Icon(
                    currentQuestion == 2 ? Icons.flag : Icons.arrow_forward,
                  ),
                  label: Text(
                    currentQuestion == 2
                        ? 'ENCERRAR CONFRONTO'
                        : 'PRÓXIMO DESAFIO',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                      fontSize: 12,
                    ),
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
