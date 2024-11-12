import 'package:flutter/material.dart';
import 'add_guide_page.dart'; // Add Guide page
import 'providenotification_page.dart'; // Provide Notification page
import 'settings_page.dart'; // Settings page
import 'profile_page.dart'; // Profile page

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.deepPurple.shade800,
      ),
      drawer: Drawer(
        backgroundColor: Colors.deepPurple.shade100,
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: Text(
                'Admin Dashboard',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add Guide'),
              onTap: () {
                // Navigate to Add Guide page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddGuidePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Provide Notification'),
              onTap: () {
                // Navigate to Provide Notification page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProvideNotificationPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                // Navigate to Settings page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Profile'),
              onTap: () {
                // Navigate to Profile page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Icon(
                Icons.dashboard,
                size: 100,
                color: Colors.deepPurple,
              ),
              const SizedBox(height: 20),
              const Text(
                'Welcome to the Admin Dashboard!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text(
                'Use the side navigation to manage guides, provide notifications, adjust settings, and view your profile.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
