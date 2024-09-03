import 'package:flutter/material.dart';
import 'package:thewall/pages/login_page.dart';
import 'package:thewall/pages/register_page.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  // Initially display the login page
  bool showLogin = true;

  // toggle between login and register page
  void togglePages() {
    setState(() {
      showLogin = !showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLogin) {
      return LoginPage(
        onTap: () => togglePages(),
      );
    } else {
      return RegisterPage(
        onTap: () => togglePages(),
      );
    }
  }
}
