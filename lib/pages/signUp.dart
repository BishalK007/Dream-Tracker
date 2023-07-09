import 'package:dream_tracker/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Duration get loginTime => const Duration(milliseconds: 1000);
  Future<UserCredential> _signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    UserCredential user =
        await FirebaseAuth.instance.signInWithCredential(credential);
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ));
    // Once signed in, return the UserCredential
    if (user.additionalUserInfo!.isNewUser) {
      // await addUser();
    }
    // await updateUser();
    return user;
  }

  Future<String?> _authUser(LoginData data) async {
    debugPrint('Name: ${data.name}, Password: ${data.password}');
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: data.name,
        password: data.password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      }
    }
    //if the email is verified successfully then only user can sign in
    IdTokenResult tokenResult =
        await FirebaseAuth.instance.currentUser!.getIdTokenResult();
    bool emailVerified = tokenResult.claims!['email_verified'];
    print(emailVerified);
    if (!emailVerified) {
      return 'Please verify your email first';
    }
    // update the current data of the user in every login
    // await updateUser();
    return null;
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

  Future<String?> _signupUser(SignupData data) {
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) async {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: data.name!,
          password: data.password!,
        );

        if (userCredential.user != null) {
          //created the user database
          // await addUser();
          // User is created, but email is not yet verified
          // Send a verification email to the user
          await userCredential.user!.sendEmailVerification();

          // Return a message to inform the user that they need to verify their email
          return 'Verification email has been sent. Please check your inbox.';
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          return 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          return 'The account already exists for that email.';
        }
      } catch (e) {
        print(e);
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.purple.shade400,
      body: FlutterLogin(
        messages: LoginMessages(
          recoverPasswordDescription:
              'We will send a password recovery link to you to this email account',
        ),
        theme: LoginTheme(
          inputTheme: InputDecorationTheme(
            prefixIconColor: Colors.deepPurpleAccent.shade400,
            suffixIconColor: Colors.deepPurpleAccent.shade400,
          ),
          errorColor: Colors.deepPurpleAccent.shade400,
          primaryColor: myPrimarySwatch,
          accentColor: const Color(0xFFE12D2D),
          buttonTheme: const LoginButtonTheme(
            backgroundColor: Color(0xFFE12D2D),
            splashColor: Color.fromARGB(255, 255, 142, 142),
          ),
        ),
        onLogin: _authUser,
        onSignup: _signupUser,
        onRecoverPassword: _recoverPassword,
        onSubmitAnimationCompleted: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const HomePage();
              },
            ),
          );
        },
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: (MediaQuery.of(context).size.height * 0.8),
            ),
            child: ElevatedButton.icon(
              onPressed: () => _signInWithGoogle(),
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
