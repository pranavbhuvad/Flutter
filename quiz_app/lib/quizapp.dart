import 'package:flutter/material.dart';
import 'package:quiz_app/question_screen.dart';
import 'package:quiz_app/result_screen.dart';

class Quizapp extends StatefulWidget {
  const Quizapp({super.key});

  @override
  State<Quizapp> createState() => _QuizappState();
}

class _QuizappState extends State<Quizapp> {
  final List<Map<String, dynamic>> allQuestions = [
    {
      "question": "Who is the founder of Microsoft?",
      "options": ["Steve Jobs", "Jeff Bezos", "Bill Gates", "Elon Musk"],
      "answerIndex": 2,
    },
    {
      "question": "Who is the founder of Apple?",
      "options": ["Steve Jobs", "Jeff Bezos", "Bill Gates", "Elon Musk"],
      "answerIndex": 0,
    },
    {
      "question": "Who is the founder of Amazon?",
      "options": ["Steve Jobs", "Jeff Bezos", "Bill Gates", "Elon Musk"],
      "answerIndex": 1,
    },
  ];

  int questionIndex = 0;
  int selectedAnswerIndex = -1;
  int correctAnswers = 0;
  bool showResult = false;

  Color? getButtonColor(int index) {
    if (selectedAnswerIndex == -1) return null;
    if (index == allQuestions[questionIndex]["answerIndex"]) {
      return Colors.green;
    }
    if (index == selectedAnswerIndex) {
      return Colors.red;
    }
    return null;
  }

  void nextQuestion() {
    if (selectedAnswerIndex == -1) return;

    if (selectedAnswerIndex ==
        allQuestions[questionIndex]["answerIndex"]) {
      correctAnswers++;
    }

    if (questionIndex == allQuestions.length - 1) {
      setState(() => showResult = true);
    } else {
      setState(() {
        questionIndex++;
        selectedAnswerIndex = -1;
      });
    }
  }

  void resetQuiz() {
    setState(() {
      questionIndex = 0;
      selectedAnswerIndex = -1;
      correctAnswers = 0;
      showResult = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "QuizApp",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: showResult
          ? ResultScreen(
              score: correctAnswers,
              total: allQuestions.length,
              onReset: resetQuiz,
            )
          : QuestionScreen(
              questionData: allQuestions[questionIndex],
              questionIndex: questionIndex,
              totalQuestions: allQuestions.length,
              selectedAnswerIndex: selectedAnswerIndex,
              getButtonColor: getButtonColor,
              onAnswerSelected: (index) {
                if (selectedAnswerIndex == -1) {
                  setState(() => selectedAnswerIndex = index);
                }
              },
            ),
      floatingActionButton: showResult
          ? null
          : FloatingActionButton(
              onPressed: nextQuestion,
              child: const Icon(Icons.arrow_forward),
            ),
    );
  }
}
