import 'package:cloud_firestore/cloud_firestore.dart';

class Post{
   final String username;
  final String uid;//every user's uid
  final String category;
  final String caption;
  final String postURL;
   final String postId;
  final String url;
  final likes;
  final DateTime datePublished;
  final String profImage;
  const Post(
    {required this.url,
    required this.username,
    required this.caption,
    required this.datePublished,
    required this.profImage,
    required this.postURL,
    required this.postId,
    required this.category,
    required this.likes,
    required this.uid,}
  );
  // convert user object required to JSON object (for storing in doc)-- serialisation
  Map<String,dynamic> toJson()=>{
    "username":username,
    "uid":uid,
    "postId":postId,
    "profImage":profImage,
    "postURL":postURL,
    "caption":caption,
    "category":category,
    "likes":likes,
    "datePublished":datePublished,
    "url":url,
  };
  static Post fromSnap(DocumentSnapshot snap)
  {
    var snapshot=snap.data() as Map<String,dynamic>;
    return Post(
      url: snapshot['url'],
      username: snapshot['username'],
      uid:snapshot['uid'],
      profImage: snapshot['profImage'],
      postURL: snapshot['postURL'],
      postId: snapshot['postId'],
      caption: snapshot['caption'],
      category: snapshot['category'],
      likes: snapshot['likes'],
      datePublished: snapshot['datePublished']
    );//deserialisation
  }
}