import 'package:dream_tracker/firebase_options.dart';
import 'package:dream_tracker/pages/onboarding.dart';
import 'package:dream_tracker/pages/signUp.dart';
import 'package:dream_tracker/pages/signUp.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dream_tracker/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dream Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<User?>(
        future: FirebaseAuth.instance.authStateChanges().first,
        builder: (context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading screen while waiting for Firebase Auth to initialize
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          // User is not signed in
          else {
            if (!snapshot.hasData) {
              return LoginScreen();
            }
            // User is signed in
            return const HomePage();
          }
        },
      ),
    );
  }
}
