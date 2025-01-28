import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tech_snap/models/user.dart';
import 'package:tech_snap/providers/user_provider.dart';
import 'package:tech_snap/resources/firestore_methods.dart';
import 'package:tech_snap/utils/colors.dart';
import 'package:tech_snap/utils/utils.dart';
import 'package:tech_snap/widgets/comment_card.dart';

class CommentScreen extends StatefulWidget {
  final postId;
  const CommentScreen({super.key, required this.postId});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentController = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();

    _commentController.addListener(() {
      // Check if the TextField is empty or not
      final hasText = _commentController.text.trim().isNotEmpty;
      if (_isButtonEnabled != hasText) {
        setState(() {
          _isButtonEnabled = hasText;
        });
      }
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void postComment(String uid, String name, String profilePic) async {
    try {
      if (_commentController.text.isNotEmpty) {
        String res = await FirestoreMethods().postComment(
          widget.postId,
          _commentController.text,
          uid,
          name,
          profilePic,
          DateTime.now().toString(), // Add the missing argument
          
        );

        if (res != "success") {
          if (context.mounted) showSnackBar(res, context);
        }

        setState(() {
          _commentController.clear();
        });
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<Userprovider>(context).getUser;

    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text("Comments"),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("posts")
                  .doc(widget.postId)
                  .collection("comments")
                  .orderBy('datePublished', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No comments yet"));
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) =>
                      CommentCard(snap: snapshot.data!.docs[index]),
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
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: "Add a comment as ${user.username}",
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.send,
                    color: _isButtonEnabled ? blueColor : Colors.grey,
                  ),
                  onPressed: _isButtonEnabled
                      ? () {
                          postComment(user.uid, user.username, user.photoURL);
                        }
                      : null,
                      
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
