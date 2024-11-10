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
              title: const Text('Frequently Asked Questions', style: TextStyle(fontSize: 18)),
              subtitle: const Text('Find answers to common questions'),
              trailing: const Icon(Icons.question_answer),
              onTap: () {
                // Navigate to FAQ page (to be implemented)
              },
            ),
            const Divider(),

            // Contact Support Section
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Contact Support', style: TextStyle(fontSize: 18)),
              subtitle: const Text('Get in touch with us for further help'),
              trailing: const Icon(Icons.email),
              onTap: () {
                // Navigate to contact form or email support (to be implemented)
              },
            ),
            const Divider(),

            // Community Forum Section
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Community Forum', style: TextStyle(fontSize: 18)),
              subtitle: const Text('Join discussions and ask questions'),
              trailing: const Icon(Icons.forum),
              onTap: () {
                // Navigate to community forum (to be implemented)
              },
            ),
            const Divider(),

            // Troubleshooting Section
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Troubleshooting', style: TextStyle(fontSize: 18)),
              subtitle: const Text('Fix common issues with your device'),
              trailing: const Icon(Icons.build),
              onTap: () {
                // Navigate to troubleshooting page (to be implemented)
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
                // Navigate to feedback form (to be implemented)
              },
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
