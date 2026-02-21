import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int total;
  final VoidCallback onReset;

  const ResultScreen({
    super.key,
    required this.score,
    required this.total,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Congratulations 🎉",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            "Score: $score / $total",
            style: const TextStyle(fontSize: 22),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: onReset,
            child: const Text("Restart Quiz"),
          ),
        ],
      ),
    );
  }
}
