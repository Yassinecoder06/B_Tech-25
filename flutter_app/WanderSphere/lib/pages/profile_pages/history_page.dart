import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage ({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text( "History",style: TextStyle(color: Colors.white,fontSize: 22)),
        backgroundColor: Colors.black.withOpacity(0.928), // Adjust the app bar color if needed
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      body: Container(
        color: Colors.black.withOpacity(1), // Background color of the page
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 200.0),
              child: Center(
                child: 
              // Image in the center
              Image.asset(
                'assets/icons/Screenshot 2025-01-24 140858.png', // Replace with your image asset path
                width: 200,
                height: 150,
              ),),
            ),
            const SizedBox(height: 16),
            // "No content" text
            const Text(
              "No content",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const Spacer(),
            // Footer text
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Text(
                "Display only 12 months of purchase history",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}