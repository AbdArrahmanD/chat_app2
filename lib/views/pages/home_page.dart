import 'package:chat_app2/views/widgets/messages.dart';
import 'package:chat_app2/views/widgets/new_messages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Test App',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          DropdownButton(
            underline: Container(),
            icon: const Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
            items: [
              DropdownMenuItem<String>(
                child: Row(
                  children: const [
                    Icon(
                      Icons.logout,
                      color: Colors.black,
                    ),
                    SizedBox(width: 10),
                    Text('Logout'),
                  ],
                ),
                value: 'Logout',
              ),
            ],
            onChanged: (val) async {
              if (val == 'Logout') await FirebaseAuth.instance.signOut();
            },
          )
        ],
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: const [
          Expanded(child: Messages()),
          NewMessage(),
        ],
      ),
    );
  }
}
