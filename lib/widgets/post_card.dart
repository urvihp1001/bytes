import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tech_snap/models/user.dart' as model;
import 'package:tech_snap/providers/user_provider.dart';
import 'package:tech_snap/resources/firestore_methods.dart';
import 'package:tech_snap/screens/comment_screen.dart';
import 'package:tech_snap/utils/colors.dart';
import 'package:tech_snap/widgets/like_animation.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({super.key, required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        // Unlike the post
        await FirebaseFirestore.instance.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        // Like the post
        await FirebaseFirestore.instance.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print("Error updating likes: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
     final model.User user = Provider.of<Userprovider>(context).getUser;
String uid=user.uid;
    return StreamBuilder<DocumentSnapshot>(stream: FirebaseFirestore.instance.collection('posts').doc(widget.snap['postId']).snapshots(),
     builder: (context,snapshot){
      if(!snapshot.hasData)
      {
        return CircularProgressIndicator();
      }
     var snap=snapshot.data!.data() as Map<String,dynamic>;
  

        return Container(
          color: mobileBackgroundColor,
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              // Header Section
              Container(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16).copyWith(right: 0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(snap['profImage']),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snap['username'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            child: ListView(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shrinkWrap: true,
                              children: ['Delete']
                                  .map(
                                    (e) => InkWell(
                                      onTap: ()async {
                                        FirestoreMethods().deletePost(widget.snap['postId']);
                                        Navigator.of(context).pop();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                        child: Text(e),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        );
                      },
                      icon: Icon(Icons.more_vert),
                    ),
                  ],
                ),
              ),
              // Image Section
              GestureDetector(
                onDoubleTap: () async {
                  await likePost(snap['postId'], uid, snap['likes']);
                  setState(() {
                    isLikeAnimating = true;
                  });
                },
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.network(
                            snap['postURL'],
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                          AnimatedOpacity(
                            opacity: isLikeAnimating ? 1 : 0,
                            duration: Duration(milliseconds: 400),
                            onEnd: () {
                              setState(() {
                                isLikeAnimating = false;
                              });
                            },
                            child: LikeAnimation(
                              isAnimating: isLikeAnimating,
                              child: Icon(
                                Icons.favorite,
                                color: Colors.white,
                                size: 120,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          
              // Action Buttons
              Row(
                children: [
                  LikeAnimation(
                    smallLike: true,
                    isAnimating: snap['likes'].contains(uid),
                    child: IconButton(
                      onPressed: () async {
                        await likePost(snap['postId'], uid, snap['likes']);
                      },
                      icon: snap['likes'].contains(uid)
                          ? Icon(Icons.favorite, color: Colors.red)
                          : Icon(Icons.favorite_border),
                    ),
                  ),
                  IconButton(
                    onPressed: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CommentsScreen())),
                    icon: Icon(Icons.comment_outlined, color: Colors.white),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        icon: Icon(Icons.bookmark),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
              ),
              // Description and Comments Section
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DefaultTextStyle(
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                      child: Text(
                        '${snap['likes'].length} likes',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(top: 8),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(color: primaryColor),
                          children: [
                            TextSpan(
                              text: snap['username'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: " ${snap['caption']}",
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          "View all 200 comments",
                          style: TextStyle(fontSize: 16, color: secondaryColor),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        DateFormat.yMMMd().format(snap['datePublished'].toDate()),
                        style: TextStyle(fontSize: 16, color: secondaryColor),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
