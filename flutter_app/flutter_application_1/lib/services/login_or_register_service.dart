import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/main_pages/login_page.dart';
import 'package:flutter_application_1/pages/main_pages/register_page.dart';

class LoginOrRegisterService extends StatefulWidget {
  const LoginOrRegisterService({super.key});

  @override
  State<LoginOrRegisterService> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterService> {

  // initially show login page
  bool showLoginPage = true;

  // toggle between login and register page
  void togglePages(){
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage){
      return LoginPage(
        onTap: togglePages,
      );
    }else{
      return RegisterPage(
        onTap: togglePages,
      );
    }
  }
}