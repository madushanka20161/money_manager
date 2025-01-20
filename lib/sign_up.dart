import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  @override
  void initState() {
    super.initState();
    _handleSignIn();
  }
  Future<void> _handleSignIn() async {
    try {
      GoogleSignInAccount? user = await _googleSignIn.signIn();
      print("--------------------------------------------------");
      if (user != null) {
        print('User Name: ${user.displayName}');
        print('User Email: ${user.email}');
        // You can also access other user details here
      }
      await _googleSignIn.signIn();
      // Handle successful sign-in here
    } catch (error) {
      print("++++++++++++++++++++++++++++++++++++++++++++++++++++");
      print(error);
      // Handle sign-in error here
    }
  }
  Future<void> _handleSignOut() async {
    try {
      await _googleSignIn.signOut();
      print("User signed out");
      // Handle successful sign-out here
    } catch (error) {
      print("Error signing out: $error");
      // Handle sign-out error here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _handleSignIn,
              child: Text('Sign Up with Google'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleSignOut,
              child: Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}