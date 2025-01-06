import 'package:cloud_firestore/cloud_firestore.dart';
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
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const DeviceFormPage(),
    const HelpPage(),
    const SettingsPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> brands = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBrands();
  }

  // Fetch brands data from Firestore
  Future<void> _fetchBrands() async {
    try {
      var querySnapshot = await _firestore.collection('brands').get();
      setState(() {
        brands = querySnapshot.docs.map((doc) {
          return {
            'name': doc['name'],
            'models': doc['models'],
          };
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple.shade800,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Banner with Search Option
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Find your Device',
                              prefixIcon: Icon(Icons.search, color: Colors.deepPurple.shade800),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Features Section
                  const Text(
                    'Brands',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                  ),
                  const SizedBox(height: 10),
                  // Brands List
                  Expanded(
                    child: ListView.builder(
                      itemCount: brands.length,
                      itemBuilder: (context, brandIndex) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: ExpansionTile(
                            title: Text(brands[brandIndex]['name']),
                            children: (brands[brandIndex]['models'] as List).map<Widget>((model) {
                              return ExpansionTile(
                                title: Text(model['name']),
                                children: (model['repairGuides'] as List).map<Widget>((guide) {
                                  return ExpansionTile(
                                    title: Text(guide['issue']),
                                    children: (guide['steps'] as List).map<Widget>((step) {
                                      return ListTile(
                                        title: Text(step['description']),
                                        subtitle: step['photo'] != null ? Image.network(step['photo']) : null,
                                        trailing: step['video'] != null ? const Icon(Icons.video_library) : null,
                                      );
                                    }).toList(),
                                  );
                                }).toList(),
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
