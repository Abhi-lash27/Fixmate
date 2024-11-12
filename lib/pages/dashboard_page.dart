import 'package:flutter/material.dart';
import 'package:fixmate/pages/device_diagnostic_page.dart'; // Import for Device Diagnostic page
import 'package:fixmate/pages/settings_page.dart'; // Import for Settings page
import 'package:fixmate/pages/help_page.dart'; // Import for Help page

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Disable back navigation
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.deepPurple.shade800,
          automaticallyImplyLeading: false, // Prevent back button from appearing
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Welcome Text
              const Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Text(
                  'Welcome to Fixmate!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
              const SizedBox(height: 20), // Space

              // Navigation Cards
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  children: [
                    _buildCard(
                      context: context,
                      title: 'Device Diagnostics',
                      icon: Icons.phone_android,
                      onTap: () {
                        _navigateToPage(context, const DeviceDiagnosticsPage());
                      },
                    ),
                    _buildCard(
                      context: context,
                      title: 'Help',
                      icon: Icons.help_outline,
                      onTap: () {
                        _navigateToPage(context, const HelpPage());
                      },
                    ),
                    _buildCard(
                      context: context,
                      title: 'Settings',
                      icon: Icons.settings,
                      onTap: () {
                        _navigateToPage(context, const SettingsPage());
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method for navigation with slide transition
  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }

  // Helper method for creating navigation cards
  Widget _buildCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.deepPurple.shade100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 5,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: Colors.deepPurple.shade800,
              ),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
