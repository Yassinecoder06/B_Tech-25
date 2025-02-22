import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/main_screen.dart';
import 'package:flutter_application_1/services/login_or_register_service.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          //user logged in 
          if (snapshot.hasData){
            return MainScreen();
          }
          //user not logged in
          else{
            return LoginOrRegisterPage();
          }
        },
        )
    );
  }
  
}

