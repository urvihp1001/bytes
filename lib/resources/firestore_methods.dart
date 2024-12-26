import 'dart:typed_data';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tech_snap/models/post.dart';
import 'package:tech_snap/resources/storage_methods.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  
  //upload post
  Future<String> uploadPost (
    String caption, String category, String uid, Uint8List file, String username, String profImage,
  )
  async {
    String res="";
    try{
      String postId=const Uuid().v1();
      String postURL= await Storage().uploadImageToSource('posts', file,true);
     Post post= Post(username: username, caption: caption, datePublished: DateTime.now(), profImage: profImage, postURL: postURL,
     postId: postId,
      category: category, likes: [], uid: uid);
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res="success";

    
    }catch(e)
    {
      res=e.toString();
    }
     return res;
  }
  Future <void> likePost(String postId, String uid, List likes) async
  {
try{
  if(likes.contains(uid))
  {
    _firestore.collection('posts').doc(postId).update(
      {
        'likes':FieldValue.arrayRemove([uid]),
      }
    );
  }
}catch(e)
{
  print(e.toString(),);
}
  }
  Future<void> deletePost(String postId) async{
    try{
await _firestore.collection('posts').doc(postId).delete();
    }catch(err)
    {
      print(err.toString());
    }
  }
}