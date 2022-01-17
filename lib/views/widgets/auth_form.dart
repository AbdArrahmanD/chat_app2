import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  bool isLoading = false;
  final auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String userName = '';
  bool isLogin = true;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  key: const ValueKey('email'),
                  validator: (val) {
                    if (val!.isEmpty || !val.contains('@')) {
                      return 'please Enter a vaild Email';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (val) => setState(() {
                    email = val!;
                  }),
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      labelText: 'email address',
                      labelStyle: TextStyle(fontSize: 20)),
                ),
                if (!isLogin)
                  TextFormField(
                    key: const ValueKey('username'),
                    validator: (val) {
                      if (val!.isEmpty || val.length < 4) {
                        return 'user name must be more than 4 characters';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (val) => setState(() {
                      userName = val!;
                    }),
                    decoration: const InputDecoration(
                        labelText: 'user name',
                        labelStyle: TextStyle(fontSize: 20)),
                  ),
                TextFormField(
                  key: const ValueKey('password'),
                  validator: (val) {
                    if (val!.isEmpty || val.length < 6) {
                      return 'password must be more than 6 characters';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (val) => setState(() {
                    password = val!;
                  }),
                  obscureText: true,
                  decoration: const InputDecoration(
                      labelText: 'password',
                      labelStyle: TextStyle(fontSize: 20)),
                ),
                const SizedBox(height: 17),
                if (isLoading) const CircularProgressIndicator(),
                if (!isLoading)
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.pink),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ))),
                    onPressed: submit,
                    child: Text(
                      isLogin ? 'Login' : 'Sign Up',
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                if (!isLoading)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isLogin = !isLogin;
                      });
                    },
                    child: Text(
                      isLogin
                          ? 'Create new account'
                          : 'I already have an account',
                      style: const TextStyle(color: Colors.pink),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void submit() {
    FocusScope.of(context).unfocus();
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
      print('email : $email');
      print('password : $password');
      if (!isLogin) print('user name : $userName');
      submitAuth(
        email: email,
        password: password,
        username: userName,
        isLogIn: isLogin,
        context: context,
      );
    }
  }

  void submitAuth({
    required String email,
    required String password,
    required String username,
    required bool isLogIn,
    required BuildContext context,
  }) async {
    try {
      setState(() {
        isLoading = true;
      });
      UserCredential userCredential;
      if (isLogin) {
        userCredential = await auth.signInWithEmailAndPassword(
          email: email.trim(),
          password: password.trim(),
        );
        print('LogIn UserCredential : $userCredential');
      } else {
        userCredential = await auth.createUserWithEmailAndPassword(
          email: email.trim(),
          password: password.trim(),
        );
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'username': username,
          'password': password,
        });
        print('SignUp UserCredential : $userCredential');
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      String messege = 'An error Occurred';
      if (e.code == 'weak-password') {
        messege = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        messege = 'The account already exists for that email.';
      } else if (e.code == 'user-not-found') {
        messege = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        messege = 'Wrong password provided for that user.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(messege),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }
}
