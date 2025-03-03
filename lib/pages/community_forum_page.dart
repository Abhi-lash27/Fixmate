import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommunityForumPage extends StatefulWidget {
  const CommunityForumPage({super.key});

  @override
  _CommunityForumPageState createState() => _CommunityForumPageState();
}

class _CommunityForumPageState extends State<CommunityForumPage> {
  final TextEditingController _postController = TextEditingController();
  final TextEditingController _replyController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _realName = "Anonymous";
  bool _isLoadingName = true;

  final Map<String, bool> _replyVisibility = {};

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  // Fetch the user's name from Firestore
  Future<void> _fetchUserName() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists && userDoc['name'] != null) {
          setState(() {
            _realName = userDoc['name'];
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error fetching user name: ${e.toString()}")),
        );
      } finally {
        setState(() {
          _isLoadingName = false;
        });
      }
    } else {
      setState(() {
        _isLoadingName = false;
      });
    }
  }

  // Add a new post to Firestore
  void _addPost() async {
    if (_formKey.currentState!.validate()) {
      String postContent = _postController.text.trim();
      User? user = _auth.currentUser;

      await _firestore.collection('discussions').add({
        'topic': postContent,
        'timestamp': FieldValue.serverTimestamp(),
        'username': _realName,
        'userId': user?.uid, // Save the current user's UID
        'likes': 0,
        'dislikes': 0,
        'likesBy': [],  // Track which users liked
        'dislikesBy': [], // Track which users disliked
      });

      _postController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your post has been added!')),
      );
    }
  }

  // Update like/dislike counts, making sure a user can only like or dislike once
  void _updateLikes(String postId, bool isLike) async {
    User? user = _auth.currentUser;
    if (user == null) return;

    DocumentReference postRef = _firestore.collection('discussions').doc(postId);

    await _firestore.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(postRef);

      if (!snapshot.exists) {
        throw Exception("Post does not exist!");
      }

      Map<String, dynamic> postData = snapshot.data() as Map<String, dynamic>;
      List<dynamic> likesBy = postData['likesBy'] ?? [];
      List<dynamic> dislikesBy = postData['dislikesBy'] ?? [];

      if (isLike && !likesBy.contains(user.uid)) {
        // User likes the post
        if (dislikesBy.contains(user.uid)) {
          dislikesBy.remove(user.uid); // Remove dislike if it exists
        }
        likesBy.add(user.uid);
      } else if (!isLike && !dislikesBy.contains(user.uid)) {
        // User dislikes the post
        if (likesBy.contains(user.uid)) {
          likesBy.remove(user.uid); // Remove like if it exists
        }
        dislikesBy.add(user.uid);
      }

      transaction.update(postRef, {
        'likes': likesBy.length,
        'dislikes': dislikesBy.length,
        'likesBy': likesBy,
        'dislikesBy': dislikesBy,
      });
    });
  }

  // Add a reply to a post
  void _addReply(String postId) async {
    if (_replyController.text.trim().isNotEmpty) {
      String replyContent = _replyController.text.trim();
      User? user = _auth.currentUser;

      try {
        await _firestore.collection('discussions').doc(postId).collection('replies').add({
          'reply': replyContent,
          'timestamp': FieldValue.serverTimestamp(),
          'username': _realName,
          'userId': user?.uid,
        });

        _replyController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reply added!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error adding reply: ${e.toString()}")),
        );
      }
    }
  }

  // Toggle visibility of replies
  void _toggleRepliesVisibility(String postId) {
    setState(() {
      _replyVisibility[postId] = !(_replyVisibility[postId] ?? false);
    });
  }

  // Delete a post
  Future<void> _deletePost(String postId) async {
    try {
      await _firestore.collection('discussions').doc(postId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post deleted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting post: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Forum', style: TextStyle(
            color: Colors.white,)),
        backgroundColor: Colors.deepPurple.shade800,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: _isLoadingName
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          const Text(
                            'Start a Discussion',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Form(
                            key: _formKey,
                            child: TextFormField(
                              controller: _postController,
                              decoration: const InputDecoration(
                                labelText: 'Your Discussion',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) =>
                                  value!.isEmpty ? 'Please enter a discussion' : null,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: _addPost,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple.shade800,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text('Post Discussion',style: TextStyle(color: Colors.white),),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _firestore
                          .collection('discussions')
                          .orderBy('timestamp', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(child: Text('No discussions available.'));
                        }

                        User? currentUser = _auth.currentUser;

                        return ListView(
                          children: snapshot.data!.docs.map((doc) {
                            final data = doc.data() as Map<String, dynamic>;
                            String postId = doc.id;

                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              elevation: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data['topic'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      'Posted by: ${data['username']}',
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.thumb_up),
                                              onPressed: () => _updateLikes(postId, true),
                                              color: Colors.green,
                                            ),
                                            Text(data['likes'].toString()),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.thumb_down),
                                              onPressed: () => _updateLikes(postId, false),
                                              color: Colors.red,
                                            ),
                                            Text(data['dislikes'].toString()),
                                          ],
                                        ),
                                        if (data['userId'] == currentUser?.uid)
                                          IconButton(
                                            icon: const Icon(Icons.delete),
                                            onPressed: () => _deletePost(postId),
                                            color: Colors.red,
                                          ),
                                      ],
                                    ),
                                    const Divider(),
                                    TextField(
                                      controller: _replyController,
                                      decoration: const InputDecoration(
                                        labelText: 'Write a reply...',
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => _addReply(postId),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.deepPurple.shade800,
                                      ),
                                      child: const Text('Reply', style: TextStyle(color: Colors.white),),
                                    ),
                                    if (_replyVisibility[postId] ?? false)
                                      StreamBuilder<QuerySnapshot>(
                                        stream: _firestore
                                            .collection('discussions')
                                            .doc(postId)
                                            .collection('replies')
                                            .orderBy('timestamp', descending: true)
                                            .snapshots(),
                                        builder: (context, replySnapshot) {
                                          if (replySnapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(child: CircularProgressIndicator());
                                          }
                                          if (!replySnapshot.hasData ||
                                              replySnapshot.data!.docs.isEmpty) {
                                            return const Center(child: Text('No replies yet.'));
                                          }

                                          return Column(
                                            children: replySnapshot.data!.docs.map((replyDoc) {
                                              final replyData = replyDoc.data() as Map<String, dynamic>;
                                              return ListTile(
                                                title: Text(replyData['reply']),
                                                subtitle: Text('By: ${replyData['username']}'),
                                              );
                                            }).toList(),
                                          );
                                        },
                                      ),
                                    TextButton(
                                      onPressed: () => _toggleRepliesVisibility(postId),
                                      child: Text(
                                          _replyVisibility[postId] ?? false ? 'Hide replies' : 'Show replies'),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
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
