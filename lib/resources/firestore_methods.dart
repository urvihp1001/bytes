import 'dart:typed_data';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tech_snap/models/post.dart';
import 'package:tech_snap/resources/storage_methods.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  
  //upload post
  Future<String> uploadPost (
    String caption, String category, String uid, Uint8List file, String username, String profImage, String url
  )
  async {
    String res="";
    try{
      String postId=const Uuid().v1();
      String postURL= await Storage().uploadImageToSource('posts', file,true);
     Post post= Post(username: username, caption: caption, datePublished: DateTime.now(), profImage: profImage, postURL: postURL,
     postId: postId,
      category: category, likes: [], uid: uid, url: url);
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
Future<String> postComment(String postId, String text, String uid,
      String name, String profilePic, String url) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String commentId = const Uuid().v1();
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
              'url': url,
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
  Future<void> deletePost(String postId) async{
    try{
await _firestore.collection('posts').doc(postId).delete();
    }catch(err)
    {
      print(err.toString());
    }
  }
  Future<void> deleteComment(String postId, String commentId) async {
    try {
      await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .delete();
    } catch (err) {
      print(err.toString());
    }
  }
  Future<void> followUser(String uid, String otherUid) async {
    try {
  DocumentSnapshot snap=   await _firestore.collection('users').doc(uid).get();
List following=(snap.data() as Map<String,dynamic>)['following'];
if(!following.contains(otherUid)){
  await _firestore.collection('users').doc(uid).update({
    'following': FieldValue.arrayUnion([otherUid]),
  });
  await _firestore.collection('users').doc(otherUid).update({
    'followers': FieldValue.arrayUnion([uid]),
  });
}
  else{
    await _firestore.collection('users').doc(uid).update({
    'following': FieldValue.arrayRemove([otherUid]),
  });
  }

  }catch(err)
  {
    print(err.toString());
  }
  }
 
}