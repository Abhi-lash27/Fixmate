import 'package:flutter/material.dart';

class CommunityForumPage extends StatefulWidget {
  const CommunityForumPage({super.key});

  @override
  _CommunityForumPageState createState() => _CommunityForumPageState();
}

class _CommunityForumPageState extends State<CommunityForumPage> {
  final TextEditingController _postController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Sample list of discussions. You would replace this with data fetched from a database.
  List<String> discussions = [
    "How do I improve my phone's battery life?",
    "Is there a way to repair a broken screen myself?",
    "Best apps for optimizing device performance?"
  ];

  // Method to add a new post
  void _addPost() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        discussions.add(_postController.text.trim());
      });
      _postController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your post has been added!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Forum'),
        backgroundColor: Colors.deepPurple.shade800,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Forum Title
            const Text(
              'Welcome to the Community Forum!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Display list of discussions
            Expanded(
              child: ListView.builder(
                itemCount: discussions.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      title: Text(discussions[index]),
                      onTap: () {
                        // Open a new page or a modal for discussion details or replies
                      },
                    ),
                  );
                },
              ),
            ),

            // Post a new discussion section
            const SizedBox(height: 20),
            const Text(
              'Post a new discussion:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),

            // Form to post a new discussion
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _postController,
                    decoration: InputDecoration(
                      labelText: 'Your Discussion',
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a discussion topic';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Submit Button
                  ElevatedButton(
                    onPressed: _addPost,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple.shade800,
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 80),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Post Discussion',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
