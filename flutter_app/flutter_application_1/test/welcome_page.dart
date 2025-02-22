import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/login_or_register_service.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Image.asset(
              'assets/globe.png', // Replace with your image path
              height: 200,
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                'Welcome!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 99, 41, 108),
                ),
              ),
            ),
            Text(
              "Let's Explore",
              style: TextStyle(
                fontSize: 18,
                color: Colors.blueGrey,
              ),
            ),
            Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent[100],
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginOrRegisterPage()),
                );
              },
              child: Text(
                'Get Started',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}


