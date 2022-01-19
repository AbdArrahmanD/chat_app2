import 'package:chat_app2/views/pages/auth_screen.dart';
import 'package:chat_app2/views/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(backgroundColor: Colors.pink),
        primarySwatch: Colors.pink,
        backgroundColor: Colors.pink,
        // scaffoldBackgroundColor: Colors.pink,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.deepPurple,
        ),
        buttonTheme: ButtonTheme.of(context).copyWith(
          buttonColor: Colors.pink,
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapShot) {
          if (snapShot.hasData) {
            return const MyHomePage();
          } else {
            return const AuthScreen();
          }
        },
      ),
    );
  }
}
