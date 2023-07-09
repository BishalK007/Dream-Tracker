import 'package:dream_tracker/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//import 'dashboard_screen.dart';
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Duration get loginTime => const Duration(milliseconds: 1000);
  // Login --> Firebase
  Future<String?> _authUser(LoginData data) {
    debugPrint('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) async {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: data.name,
          password: data.password,
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          return ('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          return ('Wrong password provided for that user.');
        }
      }
      return null;
    });
  }
  
  Future<String?> _signupUser(SignupData data) {
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  Future<String?> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) async {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: name);
      } on FirebaseAuthException catch (e) {
        return e.code;
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterLogin(
        messages: LoginMessages(
          recoverPasswordDescription:
              'We will send a password recovery link to you to this email account',
        ),
        theme: LoginTheme(
          inputTheme: const InputDecorationTheme(
            prefixIconColor: Color.fromARGB(255, 248, 132, 254),
            suffixIconColor: Color.fromARGB(255, 248, 132, 254),
          ),
          errorColor: Colors.deepPurpleAccent.shade400,
          primaryColor: const Color.fromARGB(255, 248, 132, 254),
          accentColor: const Color(0xFFE12D2D),
          buttonTheme: const LoginButtonTheme(
            backgroundColor: Color(0xFFE12D2D),
            splashColor: Color.fromARGB(255, 255, 142, 142),
          ),
        ),
        //title: 'ECORP',
        //logo: AssetImage('assets/images/ecorp-lightblue.png'),
        onLogin: _authUser,
        onSignup: _signupUser,

        onSubmitAnimationCompleted: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const HomePage(),
          ));
        },
        onRecoverPassword: _recoverPassword,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: (MediaQuery.of(context).size.height * 0.8),
            ),
            child: ElevatedButton.icon(
              onPressed: () => HomePage(),
              icon: const Image(
                image: AssetImage('assets/images/google.png'),
                height: 24.0,
              ),
              label: const Text(
                'Google',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 8.0,
                ),
                elevation: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
