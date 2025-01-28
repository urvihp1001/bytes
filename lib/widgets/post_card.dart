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
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';
//take launchurl from job
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
 _launchURL(String uri) async {
   final Uri url = Uri.parse(uri);
   if (!await launchUrl(url)) {
     print("could not launch");
        throw Exception('Could not launch $url');
       
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
                  ]
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
                    onPressed: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CommentScreen(postId: snap['postId']))),
                    icon: Icon(Icons.comment_outlined, color: Colors.white),
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
                     if (snap.containsKey('tldr') && snap['tldr'].isNotEmpty)
                      Container(
                        margin: EdgeInsets.only(top: 8),
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          "tl;dr: ${snap['tldr']}",
                          style: TextStyle(fontSize: 16, color: secondaryColor),
                        ),
                      ),
                    // URL Clickable Area
                  if (snap.containsKey('url') && snap['url'].isNotEmpty)
  GestureDetector(
    onTap: () {
      final url = snap['url'];
      if (url is String && Uri.tryParse(url)?.hasAbsolutePath == true) {
        _launchURL(url);
      } else {
        print("Invalid URL format: $url");
      }
    },
                    child: Container(
                  margin: EdgeInsets.only(top: 8),
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    "Learn more",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              
            ),

                    InkWell(
                      onTap:  ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CommentScreen(postId: snap['postId'])),),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          "View all comments",
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