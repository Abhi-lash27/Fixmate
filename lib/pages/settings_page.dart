import 'package:fixmate/pages/editprofile_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fixmate/pages/login_page.dart'; // Navigate to Login page after account deletion
import 'package:fixmate/pages/changepassword_page.dart';

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
                  MaterialPageRoute(builder: (context) => const EditProfilePage()),
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

            // Delete Account Button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  // Handle delete account logic
                  _deleteAccount(context); // Call delete account method
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade800, // Red for account deletion
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Delete Account',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to handle delete account logic
  void _deleteAccount(BuildContext context) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      // Confirm deletion with the user
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete Account'),
            content: const Text('Are you sure you want to delete your account? This action is irreversible.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  // Reauthenticate the user before account deletion
                  try {
                    await _reauthenticateUser(context);
                    
                    // Delete Firestore document associated with the user
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .delete();

                    // Delete the user from Firebase Authentication
                    await user.delete();

                    // Navigate to SignInPage and remove all previous routes
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const SignInPage()),
                      (route) => false, // Clear all previous routes
                    );
                  } catch (e) {
                    // Handle error (e.g., reauthentication failed or deletion error)
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Error deleting account. Please try again.')),
                    );
                    Navigator.of(context).pop(); // Close the dialog
                  }
                },
                child: const Text('Delete'),
              ),
            ],
          );
        },
      );
    }
  }

  // Reauthenticate user before deleting the account
  Future<void> _reauthenticateUser(BuildContext context) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      // Ask for email and password to reauthenticate
      TextEditingController emailController = TextEditingController();
      TextEditingController passwordController = TextEditingController();

      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Reauthenticate'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    // Reauthenticate the user
                    AuthCredential credential = EmailAuthProvider.credential(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                    );
                    await user.reauthenticateWithCredential(credential);

                    // Close the dialog
                    Navigator.of(context).pop();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Reauthentication failed. Please try again.')),
                    );
                  }
                },
                child: const Text('Authenticate'),
              ),
            ],
          );
        },
      );
    }
  }
}
