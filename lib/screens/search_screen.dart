import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:tech_snap/screens/profile_screen.dart';
import 'package:tech_snap/utils/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  void onSearchChanged(String value)
  {
    setState(() {
      _searchText = value;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          onChanged: onSearchChanged,
          decoration: InputDecoration(
            hintText: 'Search',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white),
          ),
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: mobileBackgroundColor,
      ),
      body: _searchText.isNotEmpty
      ?StreamBuilder(
        
        stream:FirebaseFirestore.instance.collection('users')
        .where('username',isGreaterThanOrEqualTo: _searchText)
        .where('username',isLessThan: _searchText +'\uf8ff')
        .snapshots()
      , builder:(context,snapshot)
      {
       if(!snapshot.hasData)
       {
          return Center(child: CircularProgressIndicator(),);
       } 
       final docs=(snapshot.data as QuerySnapshot).docs;
       if(docs.isEmpty)
       {
         return Center(child: Text('No users found'),);
       }
       return ListView.builder(
         itemCount: docs.length,
         itemBuilder: (context,index)
         {
          final userDoc=docs[index].data() as Map<String,dynamic>;
          return InkWell(
            onTap: ()
            {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen(uid: userDoc['uid'],)));
            },
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(userDoc['photoURL']??'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png'),
              ),
              title: Text(userDoc['username']??'No username'),
              subtitle: Text(userDoc['email']??'No email'),
            ),
          );
          
         }
       );
      } ):FutureBuilder(future: 
      FirebaseFirestore.instance.collection('posts').get(),
      builder: (context,snapshot)
      {
        if(!snapshot.hasData)
        {
          return Center(child: CircularProgressIndicator(),);
        }
        final docs=(snapshot.data! as QuerySnapshot).docs;
       if (docs.isEmpty)
       {
         return Center(child: Text('No posts found'),);
       }
       return MasonryGridView.count(crossAxisCount: 2,
       mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        itemCount: docs.length,
        itemBuilder: (context,index)
        {
          final postDoc=docs[index].data() as Map<String,dynamic>;
          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  fit: BoxFit.contain,
                  postDoc['postURL']??'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png'),
                Padding(padding: EdgeInsets.all(8),
                child: Text(postDoc['caption']??'No caption',
                style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),
                ),
                )
            ],),
          );
        }
        );
      }
      ),
    );
  }
}