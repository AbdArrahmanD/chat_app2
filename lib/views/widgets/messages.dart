import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('timeStamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        final docs = snapshot.data!.docs;

        return ListView.builder(
          reverse: true,
          itemCount: docs.length,
          itemBuilder: (context, index) {
            return Text(
              docs[index]['text'],
              style: const TextStyle(fontSize: 35),
            );
          },
        );
      },
    );
  }
}
