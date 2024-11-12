import 'package:fixmate/pages/changepassword_page.dart';
import 'package:fixmate/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:fixmate/pages/login_page.dart'; // Navigate to Login page after sign out

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white), // White color for the app bar text
        ),
        backgroundColor: Colors.deepPurple.shade800, // App bar background color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Profile Section
            ListTile(
  contentPadding: EdgeInsets.zero,
  title: const Text('Profile', style: TextStyle(fontSize: 18)),
  subtitle: const Text('Edit your profile details'),
  trailing: const Icon(Icons.edit),
  onTap: () {
    // Navigate to ProfilePage
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfilePage()),
    );
  },
),

            const Divider(),

            // Theme Section
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Theme', style: TextStyle(fontSize: 18)),
              subtitle: const Text('Change app theme'),
              trailing: const Icon(Icons.brightness_6),
              onTap: () {
                // Add theme change functionality (to be implemented)
              },
            ),
            const Divider(),

            // Notification Settings Section
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Notifications', style: TextStyle(fontSize: 18)),
              subtitle: const Text('Manage your notifications'),
              trailing: const Icon(Icons.notifications),
              onTap: () {
                // Add notification settings functionality (to be implemented)
              },
            ),
            const Divider(),
            // Change Password Section
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Change Password', style: TextStyle(fontSize: 18)),
              subtitle: const Text('Update your password'),
              trailing: const Icon(Icons.lock),
              onTap: () {
                // Navigate to ChangePasswordPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChangePasswordPage()),
                );
              },
            ),
            const Divider(),

            // Sign Out Button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  // Handle sign out logic
                  _signOut(context); // Call sign-out method
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple.shade800,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Sign Out',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to handle sign-out logic (navigate to login page)
  void _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut(); // Sign out the user
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignInPage()), // Navigate to SignInPage
      );
    } catch (e) {
      // Handle error (optional)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error signing out. Please try again.')),
      );
    }
  }
}