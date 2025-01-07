import 'package:fixmate/pages/community_forum_page.dart';
import 'package:fixmate/pages/faq_page.dart';
import 'package:fixmate/pages/feedback_page.dart';
import 'package:fixmate/pages/service_center_page.dart';
import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Help & Support',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple.shade800, // App bar background color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // FAQ Section
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Frequently Asked Questions',
                  style: TextStyle(fontSize: 18)),
              subtitle: const Text('Find answers to common questions'),
              trailing: const Icon(Icons.question_answer),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FaqPage()),
                );
              },
            ),
            const Divider(),

            // Community Forum Section
            ListTile(
              contentPadding: EdgeInsets.zero,
              title:
                  const Text('Community Forum', style: TextStyle(fontSize: 18)),
              subtitle: const Text('Join discussions and ask questions'),
              trailing: const Icon(Icons.forum),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CommunityForumPage()),
                );
              },
            ),
            const Divider(),

            // Troubleshooting Section
            ListTile(
              contentPadding: EdgeInsets.zero,
              title:
                  const Text('Service Centers', style: TextStyle(fontSize: 18)),
              subtitle: const Text('Find your nearby service centers'),
              trailing: const Icon(Icons.build),
              onTap: () {
                // Navigate to service center page (to be implemented)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ServiceCenterPage()),
                );
              },
            ),
            const Divider(),

            // Feedback Section
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Feedback', style: TextStyle(fontSize: 18)),
              subtitle: const Text('Let us know your thoughts and suggestions'),
              trailing: const Icon(Icons.feedback),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FeedbackPage()),
                );
              },
            ),
            const Divider(),
          ],
        ),
      ),
      // Chatbot button at the bottom right
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple.shade800,
        child: const Icon(
          Icons.chat,
          color: Colors.white,
        ),
        onPressed: () {
          // Navigate to chatbot page or open chatbot (to be implemented)
        },
      ),
    );
  }
}
