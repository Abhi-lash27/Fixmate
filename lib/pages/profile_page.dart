import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _name = '';
  String _email = '';
  String _dob = 'Not set';
  String _phone = 'Not set';
  String? _profileImageUrl;
  bool _isLoading = true;

  // Fetch user data from Firestore
  Future<void> _fetchUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc =
            await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          setState(() {
            _name = userDoc['name'] ?? 'N/A';
            _email = userDoc['email'] ?? 'N/A';
            _dob = userDoc.data().toString().contains('dob') ? userDoc['dob'] : 'Not set';
            _phone = userDoc.data().toString().contains('phone') ? userDoc['phone'] : 'Not set';
            _profileImageUrl = userDoc.data().toString().contains('profileImageUrl')
                ? userDoc['profileImageUrl']
                : '';
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error fetching user data: ${e.toString()}")),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Log the user out
  Future<void> _logout() async {
    try {
      await _auth.signOut();
      Navigator.pushReplacementNamed(context, '/sign-in'); // Replace with your sign-in route
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error signing out: ${e.toString()}")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Fetch user data when the page loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.deepPurple.shade800,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout, // Log out the user
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading indicator while fetching data
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Profile image section
                    Center(
                      child: CircleAvatar(
                        radius: 70,
                        backgroundImage: _profileImageUrl != null && _profileImageUrl!.isNotEmpty
                            ? NetworkImage(_profileImageUrl!)
                            : const AssetImage('assets/images/defaultpic.png') as ImageProvider,
                        backgroundColor: Colors.grey[300],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // User Info Card
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 4,
                      color: Colors.deepPurple.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Name: $_name",
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Email: $_email",
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Date of Birth: $_dob",
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Phone: $_phone",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Edit Profile Button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/edit-profile'); // Navigate to edit profile page
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple.shade800,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 60),
                      ),
                      child: const Text(
                        'Edit Profile',
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
            ),
    );
  }
}
