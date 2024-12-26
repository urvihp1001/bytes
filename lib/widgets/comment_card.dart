import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CommentCard extends StatefulWidget {
  const CommentCard({super.key});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Row(
          children: [
            CircleAvatar(
              backgroundImage:NetworkImage("https://unsplash.com/photos/gray-and-black-laptop-computer-on-surface-Im7lZjxeLhg") ,
              radius: 18,
            ),
            Expanded(
              child:Padding(padding: EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(text: TextSpan(
                    children: [
                      TextSpan(
                        text: "username", style: TextStyle(fontWeight: FontWeight.bold),

                      ),
                      
                      TextSpan(text:"Some comment user wrote")
                    ]
                  )
                  ),
                  Padding(padding: EdgeInsets.only(top:4),
                  child: Text("26/12/2024",
                  style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400),
                  ),
                  
                  )
                ],
              ),
              )
            ),
            
            ]
            ),
            
    );
  }
}