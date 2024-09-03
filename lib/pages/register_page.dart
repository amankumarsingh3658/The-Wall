import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thewall/components/button.dart';
import 'package:thewall/components/text_fields.dart';

class RegisterPage extends StatefulWidget {
  Function()? onTap;
  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Sign Uo user
  void signUp() async {
    showDialog(
        context: context,
        builder: (context) => Center(
              child: CircularProgressIndicator(),
            ));

    // make sure passwords match
    if (passwordController.text != confirmPasswordController.text) {
      Navigator.pop(context);
      // Display error message
      displayMessage("Password and confirm password dont match");
      return;
    }
    // check if the pass word is atleast 6 characters
    if (passwordController.text.length < 6) {
      Navigator.pop(context);
      // Display error message
      displayMessage("Password Cannot be less than 6 Characters");
      return;
    }
    try {
      // We are creating the user here
      // To Get the User Data Later
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);
      // After getting the user we need to store the user data in the collection
      FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email)
          .set({
        "username": emailController.text.split('@')[0],
        "bio": ""

        // We can create more fields as we want
      });
      // Pop loading circle if We Register
      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // pop loading cirle
      Navigator.pop(context);
      displayMessage(e.code);
    }
  }

  // Display snackbar
  void displayMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  // Text Editing Controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

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
                  "Lets Create an Account for You",
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
                  height: 15,
                ),
                // Password Text Field
                MyTextField(
                  controller: passwordController,
                  hintText: 'Enter Password',
                  obsecure: true,
                ),

                SizedBox(
                  height: 15,
                ),

                // Confirm Password
                MyTextField(
                    controller: confirmPasswordController,
                    hintText: 'Confirm Password',
                    obsecure: true),

                SizedBox(
                  height: 20,
                ),

                // Sign in button
                MyButton(text: 'Sign Up', onTap: () => signUp()),
                SizedBox(
                  height: 20,
                ),
                //Go to register page
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already Have an Accoun?",
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
                        "Login Now",
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
