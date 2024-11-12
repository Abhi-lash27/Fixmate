import 'package:flutter/material.dart';

class ProvideNotificationPage extends StatelessWidget {
  const ProvideNotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Provide Notification')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Notification Title'),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Notification Message'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Logic to send notification
              },
              child: const Text('Send Notification'),
            ),
          ],
        ),
      ),
    );
  }
}
