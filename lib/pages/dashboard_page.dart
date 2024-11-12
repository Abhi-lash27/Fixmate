import 'package:flutter/material.dart';
import 'package:fixmate/pages/device_diagnostic_page.dart';
import 'package:fixmate/pages/help_page.dart';
import 'package:fixmate/pages/settings_page.dart';
import 'package:fixmate/pages/profile_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Index to track the current selected tab
  int _selectedIndex = 0;

  // List of pages for the bottom navigation bar options
  final List<Widget> _pages = [
    const HomePage(), // Home page content
    const DeviceDiagnosticsPage(),
    const HelpPage(),
    const SettingsPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // The currently selected index
        onTap: _onItemTapped, // Handle the tab change
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.phone_android),
            label: 'Device Diagnostics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help_outline),
            label: 'Help',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.deepPurple.shade800,
        unselectedItemColor: Colors.deepPurple.shade400,
        backgroundColor: Colors.white,
      ),
    );
  }

  // Method to handle tab item selection
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected tab index
    });
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple.shade800,
      ),
      body: const Center(
        child: Text(
          'Welcome to Fixmate!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
      ),
    );
  }
}
