import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tech_snap/resources/auth_methods.dart';
import 'package:tech_snap/resources/firestore_methods.dart';
import 'package:tech_snap/screens/login_screen.dart';
import 'package:tech_snap/utils/colors.dart';
import 'package:tech_snap/utils/utils.dart';
import 'package:tech_snap/widgets/follow_btn.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;

  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int followers = 0;
  int following = 0;
  int postLength = 0;
  bool isFollowing = false;
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    try {
      var snap = await FirebaseFirestore.instance.collection('users').doc(widget.uid).get();
      //get post length
      var postSnap = await FirebaseFirestore.instance.collection('posts').where('uid', isEqualTo: widget.uid).get();
postLength = postSnap.docs.length;
      userData = snap.data()!;
      followers= userData['followers'].length;
      following= userData['following'].length;
      isFollowing = snap.data()!['followers'].contains(FirebaseAuth.instance.currentUser!.uid);

      setState(() {});
      
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text(userData['username'] ?? 'Profile'),
        centerTitle: false,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(userData['photoURL'] ?? ''),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              buildStatColumn(postLength, 'Posts'),
                              buildStatColumn(followers, 'Followers'),
                              buildStatColumn(following, 'Following'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FirebaseAuth.instance.currentUser!.uid==widget.uid?FollowButton(
                                backgroundColor:mobileBackgroundColor ,
                                 textColor: primaryColor,
                                  text: 'Sign Out',
                                   borderColor: Colors.grey,
                                    onPressed: () async {
                                      await AuthMethods().signOut();
                                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const LoginScreen()));
                                    
                                    }):isFollowing?FollowButton(
                                      text: 'Unfollow',
                                      backgroundColor: Colors.white,
                                      textColor: Colors.black,
                                      borderColor: Colors.grey,
                                      onPressed: () async {
                                        await FirestoreMethods().followUser(FirebaseAuth.instance.currentUser!.uid, userData['uid']);
                                        setState(() {
                                          isFollowing = false;
                                          followers--;
                                        });
                                      }
                                    ):
                                    FollowButton(
                                      text: 'Follow',
                                      backgroundColor: Colors.white,
                                      textColor: Colors.black,
                                      borderColor: Colors.grey,
                                      onPressed: () async {
                                        await FirestoreMethods().followUser(FirebaseAuth.instance.currentUser!.uid, userData['uid']);
                                        setState(() {
                                          isFollowing = true;
                                          followers++;
                                        });
                                      },
                                    ),
                            ],

                          ),
                          const SizedBox(height: 10
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    userData['username'] ??'username',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    userData['bio'] ??'bio',
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          FutureBuilder(future: FirebaseFirestore.instance.collection('posts').where('uid', isEqualTo: widget.uid).get(), 
          builder:(context, snapshot)
          {
            if(snapshot.connectionState==ConnectionState.waiting)
            {
              return const Center(child: CircularProgressIndicator(),);
            }
            return GridView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 5, mainAxisSpacing: 1.5, childAspectRatio: 1),

              itemBuilder: (context, index)
              {
               DocumentSnapshot snap= (snapshot.data! as dynamic).docs[index];
              return SizedBox(
                height: 100,
                width: 100,
                child: Image.network(snap['postURL'], fit: BoxFit.cover,),
              );
              });
          }
          ),
    
        ],
      ),
    );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(num.toString(), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(label,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.grey)),
        ),
      ],
    );
  }
}
