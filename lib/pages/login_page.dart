import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:thewall/components/button.dart';
import 'package:thewall/components/text_fields.dart';

class LoginPage extends StatefulWidget {
  Function()? onTap;
  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Text Editing Controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Sign In User
  void signIn() async {
    // show loading bar
    showDialog(
        context: context,
        builder: (context) => Center(
              child: CircularProgressIndicator(),
            ));
    // Check is the password is atleast 6 characters
    if (passwordController.text.length < 6) {
      Navigator.pop(context);
      // Display error message
      displayMessage("Password Cannot be less than 6 Characters");
      return;
    }
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      // Pop the loading bar
      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // pop the loading befor displaying message
      Navigator.pop(context);
      displayMessage(e.code);
    }
  }

  // Display an dialog message
  void displayMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Icon(
                  Icons.lock,
                  size: 100,
                ),
                SizedBox(
                  height: 40,
                ),
                // Welcome Back Message
                Text(
                  "Welcome Back, You've been Missed!",
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                // Email Text Field
                MyTextField(
                    controller: emailController,
                    hintText: 'Enter Email',
                    obsecure: false),
                SizedBox(
                  height: 25,
                ),
                // Password Text Field
                MyTextField(
                    controller: passwordController,
                    hintText: 'Enter Password',
                    obsecure: true),

                SizedBox(
                  height: 20,
                ),
                // Sign in button
                MyButton(
                  text: 'Sign In',
                  onTap: () => signIn(),
                ),
                SizedBox(
                  height: 20,
                ),
                //Go to register page
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Not A Member?",
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Register Now",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
