import 'dart:ui';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, String>> messages = [];
  final TextEditingController controller = TextEditingController();

  void handleUserMessage(String input) {
  // Convert input to lowercase for case-insensitive matching
  final trimmedInput = input.trim().toLowerCase();

  // Find response by checking if the input contains any keyword
  final response = responses.keys.firstWhere(
    (key) => trimmedInput.contains(key),
    orElse: () => '',
  );

  setState(() {
    messages.add({"sender": "user", "text": input});
    messages.add({
      "sender": "bot",
      "text": response != ''
          ? responses[response]!
          : "I don't know the answer to that."
    });
  });

  controller.clear();
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Glassmorphic Background
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.withOpacity(0.2),
                    Colors.purple.withOpacity(0.2),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // AppBar
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.chat, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        "Topic Bot",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                // Chat Messages
                Expanded(
                  child: ListView.builder(
                    itemCount: messages.length,
                    padding: EdgeInsets.all(10),
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isUser = message['sender'] == 'user';
                      return Align(
                        alignment:
                            isUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: isUser ? Colors.blue[700] : Colors.green[700],
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                              bottomLeft:
                                  isUser ? Radius.circular(15) : Radius.zero,
                              bottomRight:
                                  isUser ? Radius.zero : Radius.circular(15),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 5,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            message['text']!,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Input Box
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      // Attachment Icon
                    
                      SizedBox(width: 10),
                      // Text Field
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(25),
                                border:
                                    Border.all(color: Colors.white.withOpacity(0.2)),
                              ),
                              child: TextField(
                                controller: controller,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: "Type your message...",
                                  hintStyle: TextStyle(color: Colors.white70),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      // Send Button
                      GestureDetector(
                        onTap: () {
                          if (controller.text.trim().isNotEmpty) {
                            handleUserMessage(controller.text.trim());
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Colors.purple, Colors.indigo],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


// Sample Responses for Tech Chatbot

final responses = {
    "hi": "Hi",
    "hello": "Hello",
    "hey": "Hey",
    "how are you?": "I am fine, thank you",
    "who are you?": "I am a chatbot",
    "who created you?": "I was created by a developer",
    "creator": "I was created by a developer",
    "python": "Python is an interpreted, high-level, general-purpose programming language.",
    "java": "Java is a class-based, object-oriented programming language that is designed to have as few implementation dependencies as possible.",
    "javascript": "JavaScript is a high-level, interpreted programming language that conforms to the ECMAScript specification.",
    "flutter": "Flutter is an open-source UI toolkit by Google for building natively compiled applications for mobile, web, and desktop from a single codebase.",
    "ai": "Artificial Intelligence (AI) is the simulation of human intelligence in machines that are programmed to think and learn.",
    "blockchain": "Blockchain is a distributed ledger technology that allows secure and transparent recording of transactions.",
    "html": "HTML (HyperText Markup Language) is the standard language for creating webpages and web applications.",
    "css": "CSS (Cascading Style Sheets) is used for designing the layout and appearance of webpages.",
    "react": "React is a JavaScript library for building user interfaces, maintained by Facebook.",
    "django": "Django is a high-level Python web framework that encourages rapid development and clean, pragmatic design.",
    "sql": "SQL (Structured Query Language) is a domain-specific language for managing and querying data in relational databases.",
    "machine learning": "Machine Learning is a subset of AI focused on building systems that learn and improve from experience.",
    "cloud computing": "Cloud Computing is the delivery of computing services like servers, storage, databases, networking, and more over the internet.",
    "big data": "Big Data refers to large and complex datasets that are difficult to process using traditional methods.",
    "kotlin": "Kotlin is a modern, concise, and safe programming language often used for Android app development.",
    "docker": "Docker is a platform for developing, shipping, and running applications in isolated containers.",
    "kubernetes": "Kubernetes is an open-source system for automating deployment, scaling, and management of containerized applications.",

};
}