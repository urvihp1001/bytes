import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tech_snap/screens/add_post_screen.dart';
import 'package:tech_snap/screens/chatbot_screen.dart';
import 'package:tech_snap/screens/feed_screen.dart';
import 'package:tech_snap/screens/profile_screen.dart';
import 'package:tech_snap/screens/search_screen.dart';

const webScreenSize=600;
final homeScreenItems=[
          FeedScreen(),
          SearchScreen(),
        AddPostScreen(),
          ChatScreen(),
          ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid,)

];