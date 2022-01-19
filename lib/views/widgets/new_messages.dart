import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final TextEditingController controller = TextEditingController();
  String enteredText = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: const InputDecoration(labelText: 'Send a message...'),
              controller: controller,
              onChanged: (val) {
                setState(() {
                  enteredText = val;
                });
              },
            ),
          ),
          IconButton(
              onPressed: enteredText.trim().isNotEmpty ? sendMessage : null,
              icon: const Icon(Icons.send))
        ],
      ),
    );
  }

  void sendMessage() async {
    FocusScope.of(context).unfocus();
    await FirebaseFirestore.instance.collection('chat').add({
      'text': enteredText,
      'timeStamp': Timestamp.now(),
    });
    setState(() {
      enteredText = '';
    });
    controller.clear();
  }
}
