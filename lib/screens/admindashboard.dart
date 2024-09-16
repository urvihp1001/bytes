import 'package:JHC_MIS/utils/colors.dart';
import 'package:JHC_MIS/widgets/glassmorphic_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Dashboard"),backgroundColor: blueColor,
      ),
      body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [gradientStartColor, gradientEndColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),child:StreamBuilder(
        stream: FirebaseFirestore.instance.collection('tasks').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return Center(child: Text('No tasks available'));
          }
          final tasks = snapshot.data!.docs;
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              DateTime taskDateTime = task['date_time'].toDate();
              bool isOverdue = DateTime.now().difference(taskDateTime).inHours > 24;
              String status = task['status'];
              bool requestTimeExtension = task['requestTimeExtension'];

              return Padding(
                
                padding: const EdgeInsets.only(bottom: 16.0),
                child: GlassmorphicContainer(
                  child: SingleChildScrollView(
                    child:Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Task ID: ${task.id}",
                          style: TextStyle(color:blueColor,fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(height: 8),
                        _buildTaskDetailRow("Building", task['building'], blueColor),
                        _buildTaskDetailRow("Floor", task['floor_number'],blueColor),
                        _buildTaskDetailRow("Room", task['room_number'],blueColor),
                        _buildTaskDetailRow("Device", task['device_id'],blueColor),
                        _buildTaskDetailRow("Issue", task['issue'],blueColor),
                        _buildTaskDetailRow(
                          "Date",
                          DateFormat('yyyy-MM-dd – kk:mm').format(taskDateTime),blueColor
                        ),
                        _buildTaskDetailRow("Status", status, isOverdue ? Colors.red : Colors.green),
                        StreamBuilder<DateTime>(
                          stream: _timerStream(),
                          builder: (context, timerSnapshot) {
                            if (!timerSnapshot.hasData) {
                              return SizedBox.shrink();
                            }
                            Duration remainingTime = taskDateTime.add(Duration(hours: 24)).difference(timerSnapshot.data!);
                            String timeRemaining = remainingTime.isNegative
                                ? "00:00:00"
                                : "${remainingTime.inHours.toString().padLeft(2, '0')}:${remainingTime.inMinutes.remainder(60).toString().padLeft(2, '0')}:${remainingTime.inSeconds.remainder(60).toString().padLeft(2, '0')}";

                            return _buildTaskDetailRow("Time Remaining", timeRemaining, isOverdue ? Colors.red : Colors.green);
                          },
                        ),
                        SizedBox(height: 16),
                        if (requestTimeExtension && status != 'completed') ...[
                          ElevatedButton(
                            onPressed: () {
                              _approveExtension(context, task.id);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            child: Text("Approve Request"),
                          ),
                        ] else if (requestTimeExtension) ...[
                          Text(
                            "Approved",
                            style: TextStyle(color: Colors.green),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                ),
              );
            },
          );
        },
      ),
      ),
      
    );
  }

  Stream<DateTime> _timerStream() async* {
    while (true) {
      yield DateTime.now();
      await Future.delayed(Duration(seconds: 1));
    }
  }

  Widget _buildTaskDetailRow(String label, String value, [Color? color]) {
    return Row(
      children: [
        Text(
          "$label: ",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: blueColor),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 14, color: color ??blueColor),
        ),
      ],
    );
  }

  void _approveExtension(BuildContext context, String taskId) {
    FirebaseFirestore.instance.collection('tasks').doc(taskId).update({
      'requestTimeExtension': false,
    }).then((_) {

      print('Extension request approved');
       FirebaseFirestore.instance.collection('notifications').add({
'task_id':taskId,
'message':'A new task is added',
'timestamp':FieldValue.serverTimestamp(),
'roles':['admin','engineer'],
      });
    }).catchError((e) {
      print('Error approving extension request: $e');
    });
  }
}
