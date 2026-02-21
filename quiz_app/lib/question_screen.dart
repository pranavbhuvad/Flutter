import 'package:flutter/material.dart';

class QuestionScreen extends StatelessWidget {
  final Map<String, dynamic> questionData;
  final int questionIndex;
  final int totalQuestions;
  final int selectedAnswerIndex;
  final Color? Function(int) getButtonColor;
  final Function(int) onAnswerSelected;

  const QuestionScreen({
    super.key,
    required this.questionData,
    required this.questionIndex,
    required this.totalQuestions,
    required this.selectedAnswerIndex,
    required this.getButtonColor,
    required this.onAnswerSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Question ${questionIndex + 1} / $totalQuestions",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 30),

          Text(
            questionData["question"],
            style: const TextStyle(fontSize: 22),
          ),

          const SizedBox(height: 30),

          ...List.generate(
            questionData["options"].length,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: getButtonColor(index),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: selectedAnswerIndex == -1
                    ? () => onAnswerSelected(index)
                    : null,
                child: Text(
                  "${String.fromCharCode(65 + index)}. ${questionData["options"][index]}",
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
