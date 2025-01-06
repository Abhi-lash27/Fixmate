import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  String? _profileImageUrl;
  File? _profileImage;
  bool _isLoading = true;
  bool _isUpdating = false;

  // Fetch user data from Firestore
  Future<void> _fetchUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          _nameController.text = userDoc['name'] ?? 'No Name';
          _emailController.text = userDoc['email'] ?? 'No Email';
          _phoneController.text = userDoc['phone'] ?? '';
          _dobController.text = userDoc['dob'] ?? '';
          setState(() {
            _profileImageUrl = userDoc['profileImageUrl'];
          });
        } else {
          // Handle case where the user document doesn't exist
          await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
            'name': user.displayName ?? 'No Name',
            'email': user.email ?? 'No Email',
            'phone': '',
            'dob': '',
            'profileImageUrl': '',
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error fetching data: ${e.toString()}")),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Update user data in Firestore
  Future<void> _updateProfile() async {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _isUpdating = true;
      });
      try {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'name': _nameController.text.trim(),
          'phone': _phoneController.text.trim(),
          'dob': _dobController.text.trim(),
          'profileImageUrl': _profileImageUrl ?? '',
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully!")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error updating profile: ${e.toString()}")),
        );
      } finally {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }

  // Pick profile image from gallery
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
      await _uploadProfileImageToFirebase(image);
    }
  }

  // Upload profile image to Firebase Storage
  Future<void> _uploadProfileImageToFirebase(XFile image) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Uploading image, please wait...")),
      );
      String fileName = 'profile_pics/${_auth.currentUser!.uid}_${DateTime.now().millisecondsSinceEpoch}.png';
      UploadTask uploadTask = FirebaseStorage.instance.ref(fileName).putFile(File(image.path));
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        _profileImageUrl = downloadUrl;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Image uploaded successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error uploading image: ${e.toString()}")),
      );
    }
  }

  // Handle sign out logic
  Future<void> _signOut() async {
    try {
      await _auth.signOut();
      Navigator.pushReplacementNamed(context, '/sign-in');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error signing out: ${e.toString()}")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : (_profileImageUrl != null && _profileImageUrl!.isNotEmpty
                                ? NetworkImage(_profileImageUrl!)
                                : const AssetImage('assets/images/defaultpic.png') as ImageProvider),
                        backgroundColor: Colors.grey[300],
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                      enabled: false,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Mobile Number',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _dobController,
                      decoration: const InputDecoration(
                        labelText: 'Date of Birth',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _isUpdating
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _updateProfile,
                            child: const Text('Update Profile'),
                          ),
                  ],
                ),
              ),
            ),
    );
  }
}
