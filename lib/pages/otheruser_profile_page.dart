import 'package:fixmate/pages/message_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OtheruserProfilePage extends StatefulWidget {
  final String userId;

  const OtheruserProfilePage({super.key, required this.userId});

  @override
  _OtheruserProfilePageState createState() => _OtheruserProfilePageState();
}

class _OtheruserProfilePageState extends State<OtheruserProfilePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = true;
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(widget.userId).get();
      if (userDoc.exists) {
        setState(() {
          _userData = userDoc.data() as Map<String, dynamic>;
          _isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }

  void _startMessageConversation() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MessagePage(receiverUserId: widget.userId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Profile')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Username: ${_userData?['name'] ?? 'N/A'}', style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 10),
                  Text('Email: ${_userData?['email'] ?? 'N/A'}', style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 10),
                  Text('Date of Birth: ${_userData?['dob'] ?? 'N/A'}', style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _startMessageConversation,
                    child: const Text('Message'),
                  ),
                ],
              ),
            ),
    );
  }
}
