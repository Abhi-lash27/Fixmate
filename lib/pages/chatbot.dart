import 'package:flutter/material.dart';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  _ChatBotPageState createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _showOptions = true; // Show predefined options at start

  // 🔹 Bot responses
  final Map<String, String> responses = {
    "what is fixmate": "FixMate is a mobile repair guide app that helps you diagnose and fix device issues.",
    "how does fixmate work": "FixMate allows you to select your device, identify problems, and follow step-by-step repair guides.",
    "where can i find repair guides": "You can find repair guides in the Diagnostics section of FixMate.",
    "can fixmate repair my phone": "FixMate provides DIY repair guides, but you can also find nearby service centers through the app.",
    "how to use fixmate": "Simply select your device, choose a problem, and follow the suggested solutions!",
    "thankyou": "Goodbye! Have a great day and happy repairing!",
  };

  // 🔹 Options shown initially
  final List<String> options = [
    "what is fixMate",
    "how does fixMate work",
    "where can i find repair guides",
    "can fixMate repair my phone",
    "how to use fixMate",
  ];

  @override
  void initState() {
    super.initState();
    _welcomeUser();
  }

  // 🔹 Show welcome message when chatbot starts
  void _welcomeUser() {
    setState(() {
      _messages.add({"sender": "bot", "message": "Hi! Welcome to FixMate 😊. How can I assist you today?"});
    });
  }

  // 🔹 Handle user selection from predefined options
  void _handleOptionSelection(String option) {
    _sendMessage(option);
  }

  // 🔹 Process user input (typed message)
  void _sendMessage([String? input]) {
    String userMessage = (input ?? _controller.text).trim().toLowerCase();
    if (userMessage.isEmpty) return;

    setState(() {
      _messages.add({"sender": "user", "message": input ?? _controller.text});
      _showOptions = false; // Hide options after user interacts

      String botResponse = responses[userMessage] ?? "Sorry, I didn't understand that. Try selecting an option or ask something else.";
      _messages.add({"sender": "bot", "message": botResponse});
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FixMate Chatbot", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple.shade800,
        iconTheme:  const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // 🔹 Chat Messages
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message["sender"] == "user";
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.deepPurple.shade200 : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      message["message"]!,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ),

          // 🔹 Show options at start
          if (_showOptions)
            Container(
              padding: const EdgeInsets.all(10),
              color: Colors.deepPurple.shade50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Select a question:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8.0,
                    children: options.map((option) {
                      return ElevatedButton(
                        onPressed: () => _handleOptionSelection(option),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple.shade400,
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                        ),
                        child: Text(option, style: const TextStyle(fontSize: 14, color: Colors.white)),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

          // 🔹 Text Input for Custom Queries
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Ask me something...",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.deepPurple),
                  onPressed: () => _sendMessage(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
