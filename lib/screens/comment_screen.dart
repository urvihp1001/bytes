import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tech_snap/responsive/mobile_screen_layout.dart';
import 'package:tech_snap/utils/colors.dart';
import 'package:tech_snap/widgets/comment_card.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({super.key});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title:const Text("Comments"),
        centerTitle: false,
      ),
      body:CommentCard(),
      bottomNavigationBar: SafeArea(child: Container(
        height:kToolbarHeight,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        padding: EdgeInsets.only(left:16,right:8),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage:NetworkImage("https://unsplash.com/photos/gray-and-black-laptop-computer-on-surface-Im7lZjxeLhg") ,
              radius: 18,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Comment as username',
                    border: InputBorder.none
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: (){},
              child:Container(
                padding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 8,
                ),
                child:Text("Post",style: TextStyle(color:blueColor),)
              )
            )
          ],
        ),
      )),
    );
  }
}