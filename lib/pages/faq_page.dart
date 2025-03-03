import 'package:flutter/material.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Frequently Asked Questions',style: TextStyle(
            color: Colors.white)),
        backgroundColor: Colors.deepPurple.shade800,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          FaqTile(
            question: "What is FixMate?",
            answer: "FixMate is a mobile application that helps users diagnose device issues, provides repair suggestions using machine learning, and offers service center recommendations.",
          ),
          FaqTile(
            question: "How does FixMate determine repairability scores?",
            answer: "FixMate calculates repairability scores based on factors like problem complexity, cost, repair time, availability of parts, and device age using machine learning.",
          ),
          FaqTile(
            question: "Can I contribute solutions to FixMate?",
            answer: "Yes! The FixMate community forum allows users to discuss issues, share solutions, and contribute new repair guides.",
          ),
          FaqTile(
            question: "Does FixMate suggest nearby repair centers?",
            answer: "Yes, FixMate provides a map feature to locate and recommend trusted service centers near you.",
          ),
          FaqTile(
            question: "Is FixMate free to use?",
            answer: "Yes, FixMate offers free diagnostic tools and repair guides. Some advanced features may be introduced in future updates.",
          ),
          FaqTile(
            question: "How can I get customer support?",
            answer: "You can reach out to support through the app’s 'Help' section or email us at support@fixmate.com.",
          ),
        ],
      ),
    );
  }
}

class FaqTile extends StatelessWidget {
  final String question;
  final String answer;

  const FaqTile({super.key, required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 3.0,
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              answer,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}