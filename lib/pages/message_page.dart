import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MessagePage extends StatefulWidget {
  final String receiverUserId;

  const MessagePage({super.key, required this.receiverUserId});

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _messageController = TextEditingController();
  late String _currentUserId;

  @override
  void initState() {
    super.initState();
    _currentUserId = _auth.currentUser!.uid;
  }

  void _sendMessage() async {
    String message = _messageController.text.trim();
    if (message.isNotEmpty) {
      try {
        await _firestore.collection('messages').add({
          'senderId': _currentUserId,
          'receiverId': widget.receiverUserId,
          'message': message,
          'timestamp': FieldValue.serverTimestamp(),
        });
        _messageController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error sending message: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('messages')
                  .where('senderId', isEqualTo: _currentUserId)
                  .where('receiverId', isEqualTo: widget.receiverUserId)
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No messages yet.'));
                }

                return ListView(
                  reverse: true,
                  children: snapshot.data!.docs.map((doc) {
                    var message = doc.data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(message['message']),
                      subtitle: Text('From: ${message['senderId']}'),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
