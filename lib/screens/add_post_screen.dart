// ignore_for_file: prefer_const_constructors

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tech_snap/providers/user_provider.dart';
import 'package:tech_snap/resources/firestore_methods.dart';
import 'package:tech_snap/utils/colors.dart';
import 'package:tech_snap/utils/utils.dart';

import '../models/user.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  String res = "";
  String? _selectedCat;
  bool _isImgPosted = false;
  bool _isLoading = false;
  final TextEditingController _captionController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();

  void clearImage() {
    setState(() {
      _urlController.clear();
      _captionController.clear();
      _selectedCat = null;
      _file = null;
      _isImgPosted = false;
    });
  }

  void postImage(String uid, String username, String profImage) async {
    try {
      setState(() {
        _isLoading = true;
      });
      res = await FirestoreMethods().uploadPost(
        _captionController.text,
        _selectedCat ?? '',
        uid,
        _file!,
        username,
        profImage,
        _urlController.text,
      );
      if (res == "success") {
        showSnackBar("Posted!", context);
        clearImage();
      } else {
        showSnackBar(res, context);
      }
    } catch (e) {
      res = e.toString();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text("Create a Post"),
            children: [
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text("Take a Photo"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List? file = await pickImage(
                    ImageSource.camera,
                  );
                  setState(() {
                    _file = file;
                    _isImgPosted = true;
                  });
                },
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text("Choose a Photo from gallery"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List? file = await pickImage(
                    ImageSource.gallery,
                  );
                  setState(() {
                    _file = file;
                    _isImgPosted = true;
                  });
                },
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text("Cancel"),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
    _captionController.dispose();
    _urlController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<Userprovider>(context).getUser;
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            clearImage();
          },
        ),
        title: Text("New Post"),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () => postImage(user.uid, user.username, user.photoURL),
            child: const Text(
              "Post",
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _isLoading
                  ? LinearProgressIndicator()
                  : Padding(
                      padding: EdgeInsets.only(top: 0),
                    ),
              Divider(),
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      user.photoURL,
                    ),
                    radius: 48,
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _captionController,
                      decoration: InputDecoration(
                        hintText: "Write a caption",
                        hintStyle: TextStyle(color: mobileBackgroundColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0),
                      ),
                      maxLines: 3,
                      style: TextStyle(color: mobileBackgroundColor),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              InkWell(
                child: Container(
                  width: MediaQuery.of(context).size.width * 1.07,
                  height: MediaQuery.of(context).size.width * 1.07,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.blueGrey[300],
                    image: _file != null
                        ? DecorationImage(
                            image: MemoryImage(_file!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: Center(
                    child: _isImgPosted
                        ? Container()
                        : IconButton(
                            icon: Icon(
                              Icons.upload,
                              size: 50,
                              color: mobileBackgroundColor,
                            ),
                            onPressed: () => _selectImage(context),
                          ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _urlController,
                decoration: InputDecoration(
                  hintText: "Enter URL of related article",
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                ),
                style: TextStyle(color: mobileBackgroundColor),
              ),
              SizedBox(height: 16),
            
DropdownButtonFormField<String>(
  items: [
    DropdownMenuItem(
      child: Text(
        "Work Post",
        style: TextStyle(color: Colors.green[600]),
      ),
      value: "Work Post",
    ),
    DropdownMenuItem(
      child: Text(
        "Google Product Update",
        style: TextStyle(color: Colors.green[600]),
      ),
      value: "Google",
    ),
    DropdownMenuItem(
      child: Text(
        "AI",
        style: TextStyle(color: Colors.green[600]),
      ),
      value: "AI",
    ),
    DropdownMenuItem(
      child: Text(
        "Cybersecurity",
        style: TextStyle(color: Colors.green[600]),
      ),
      value: "Cybersecurity",
    ),
    DropdownMenuItem(
      child: Text(
        "Blockchain",
        style: TextStyle(color: Colors.green[600]),
      ),
      value: "Blockchain",
    ),
    DropdownMenuItem(
      child: Text(
        "Web Development",
        style: TextStyle(color: Colors.green[600]),
      ),
      value: "Web Development",
    ),
    DropdownMenuItem(
      child: Text(
        "Data Science",
        style: TextStyle(color: Colors.green[600]),
      ),
      value: "Data Science",
    ),
    DropdownMenuItem(
      child: Text(
        "Tech Reviews",
        style: TextStyle(color: Colors.green[600]),
      ),
      value: "Tech Reviews",
    ),
    DropdownMenuItem(
      child: Text(
        "Programming Languages",
        style: TextStyle(color: Colors.green[600]),
      ),
      value: "Programming Languages",
    ),
    DropdownMenuItem(
      child: Text(
        "Startup News",
        style: TextStyle(color: Colors.green[600]),
      ),
      value: "Startup News",
    ),
  ],


                value: _selectedCat,
                onChanged: (value) {
                  setState(() {
                    _selectedCat = value;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
