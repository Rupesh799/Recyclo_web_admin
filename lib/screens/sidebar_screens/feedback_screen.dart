import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FeedbackScreen extends StatefulWidget {
  // const FeedbackScreen({super.key});
  static const String routeName = '\FeedbackScreen';

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("feedback").snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            var feedbackData = snapshot.data?.docs;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "All Feedbacks",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                  Divider(
                    height: 3,
                    endIndent: 1000,
                    thickness: 3,
                  ),
                  Row(
                    children: [
                      for (var feedback in feedbackData!) FeedbackCard(feedback)
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }
}

class FeedbackCard extends StatelessWidget {
  final QueryDocumentSnapshot feedback;

  FeedbackCard(this.feedback);

  @override
  Widget build(BuildContext context) {
    Timestamp timestamp = feedback['timestamp'] as Timestamp;
    DateTime dateTime = timestamp.toDate();
    String formattedDate = "${dateTime.year}/${dateTime.month}/${dateTime.day}";

    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            // .doc(feedback['uid'])
            .get(),
        builder: (context, snapshot) {
          return Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  width: 300,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.circle_rounded),
                          Text(formattedDate)
                        ],
                      ),
                      Row(
                        children: [
                          Text(''),
                          TextButton(
                              onPressed: () {},
                              child: Text(feedback['userType'])),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(feedback['feedback'])
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }
}
