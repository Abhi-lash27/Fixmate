import 'package:flutter/material.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Frequently Asked Questions'),
        backgroundColor: Colors.deepPurple.shade800,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          FaqTile(
            question: "What is Fixmate?",
            answer: "Fixmate is an app designed to help users diagnose mobile device issues and get repair suggestions using machine learning.",
          ),
          FaqTile(
            question: "How do I use Fixmate?",
            answer: "Simply sign in, select your device, and run a diagnostic test to get a repairability score and suggestions.",
          ),
          FaqTile(
            question: "Can I use Fixmate for any device?",
            answer: "Currently, Fixmate supports a variety of popular mobile devices. More models will be added in future updates.",
          ),
          FaqTile(
            question: "Is Fixmate free to use?",
            answer: "Yes, Fixmate offers free basic diagnostics. Premium features may be added in future versions.",
          ),
          FaqTile(
            question: "How can I contact support?",
            answer: "You can contact support through the 'Help' section in the app or email support@fixmate.com.",
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
