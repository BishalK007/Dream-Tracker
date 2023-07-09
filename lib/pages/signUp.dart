import 'package:dream_tracker/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'dashboard_screen.dart';

// const users = const {
//   'dribbble@gmail.com': '12345',
//   'hunter@gmail.com': 'hunter',
// };

class LoginScreen extends StatelessWidget {
  Duration get loginTime => const Duration(milliseconds: 1000);

  Future<String?> _authUser(LoginData data) {
    debugPrint('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) async {
      try {
        final credential =
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

  Future<String> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) {
      // if (!users.containsKey(name)) {
      //   return 'User not exists';
      // }
      return "null";
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      //title: 'ECORP',
      //logo: AssetImage('assets/images/ecorp-lightblue.png'),
      onLogin: _authUser,
      onSignup: _signupUser,
      loginProviders: <LoginProvider>[
        LoginProvider(
          icon: FontAwesomeIcons.google,
          label: 'Google',
          callback: () async {
            debugPrint('start google sign in');
            await Future.delayed(loginTime);
            debugPrint('stop google sign in');
            return null;
          },
        ),
      ],
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const HomePage(),
        ));
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}
