import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tech_snap/utils/colors.dart';
import 'package:tech_snap/widgets/post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
     final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(backgroundColor: mobileBackgroundColor,
      centerTitle: false,
      title:SvgPicture.asset('assets/bytes.svg',
      color: Colors.blueGrey[50],
      height: 32,
      ),
      
      ),
    body:  StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index)=>Container(
            
            child: PostCard(
 snap: snapshot.data!.docs[index].data(),
            ),
          ),);
            }
    )
    );
  }  
          
           
    
  }
