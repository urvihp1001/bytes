import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:tech_snap/providers/user_provider.dart';
import 'package:tech_snap/responsive/mobile_screen_layout.dart';
import 'package:tech_snap/responsive/responsive_layout_screen.dart';
import 'package:tech_snap/responsive/web_screen_layout.dart';
import 'package:tech_snap/utils/colors.dart';
import 'package:tech_snap/models/user.dart' as model;

class TopicSelectionScreen extends StatefulWidget {
  const TopicSelectionScreen({Key? key}) : super(key: key);

  @override
  State<TopicSelectionScreen> createState() => _TopicSelectionScreenState();
}

class _TopicSelectionScreenState extends State<TopicSelectionScreen> {
  final List<String> topics = [
    "AI",
    "Blockchain",
    "Cloud Computing",
    "Cybersecurity",
    "Data Science",
    "Programming",
    "Web Development",
    "Mobile Apps",
    "UI/UX Design",
    "Networking",
  ];

  final Set<String> selectedTopics = {};

  void saveSelectedTopics() async {
    try {
      final model.User? user =
          Provider.of<Userprovider>(context, listen: false).getUser;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("User not found")),
        );
        return;
      }

      String uid = user.uid;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'subscriptions': selectedTopics.toList()});

      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const ResponsiveLayout(
          webScreenLayout: WebScreenLayout(),
          mobileScreenLayout: mobileScreenLayout(),
        ),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving topics: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose Topics"),
        backgroundColor: blueColor,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: topics.length,
        itemBuilder: (context, index) {
          String topic = topics[index];
          bool isSelected = selectedTopics.contains(topic);

          return GestureDetector(
            onTap: () {
              setState(() {
                if (isSelected) {
                  selectedTopics.remove(topic);
                } else {
                  selectedTopics.add(topic);
                }
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: isSelected ? blueColor : Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? blueColor : Colors.grey[400]!,
                  width: 2,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                topic,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: saveSelectedTopics,
        label: Text("Save"),
        icon: Icon(Icons.save),
        backgroundColor: blueColor,
      ),
    );
  }
}
