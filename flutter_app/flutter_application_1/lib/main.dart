import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/welcome_page.dart';
import 'package:flutter_application_1/providers/user_provider.dart';
import 'package:flutter_application_1/utils/const.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomePage(),
    );
  }
}

void main() async{
  Gemini.init(apiKey: GEMINI_API_KEY);
  await Supabase.initialize(
    url: "https://uhdtgzffszdjaeibbyxc.supabase.co",
    anonKey:
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVoZHRnemZmc3pkamFlaWJieXhjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk4MjgxOTQsImV4cCI6MjA1NTQwNDE5NH0.dkVqXooOZPqSrOizQNCbcG9j0tKjRz1R_yWmdb3IuHY",
    
  );
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb){
    Firebase.initializeApp(options: FirebaseOptions(
      apiKey: "AIzaSyC5qpUq2tH3kEAp9JBf5-AU8mTBe27vsxw",
      authDomain: "appflutter-2fca4.firebaseapp.com",
      projectId: "appflutter-2fca4",
      storageBucket: "appflutter-2fca4.firebasestorage.app",
      messagingSenderId: "879018249076",
      appId: "1:879018249076:web:191f3fc2d5f184dbb33a21",
      measurementId: "G-VVCT96RBZV"
    ));
  }else{
    await Firebase.initializeApp();
  }
  
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        // Add other providers here if needed
      ],
      child: App(),
    ),);
}


