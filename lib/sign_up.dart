import 'package:flutter/material.dart';
import 'package:money_manager_3/helper/config.dart';
import 'package:money_manager_3/service/auth_service.dart';
import 'package:money_manager_3/service/network_service.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  Future<void> _handleSignIn(BuildContext context) async {
    try {
      await AuthService.instance.signIn();
    } catch (e) {
      bool isNetworkConnect = await checkNetworkConnection();
      var message = isNetworkConnect ? 'Something went wrong. Please try again.' : 'Oops! Something went wrong. Check your internet connection and try again.';
      
      showErrorMessage(context, message);
    }
  }

  // Future<void> _handleSignOut() async {
  //   AuthService.instance.signOut();
  // }

  void showErrorMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Something went wrong"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Report"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double appHeight = MediaQuery.of(context).size.height;
    double appWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: AppConfig.fontColor,
        backgroundColor:  AppConfig.appBackgroundColor,
        title: Text('Welcome'),
        centerTitle: true,
      ),
      body: Container(
        height: appHeight,
        width: appWidth,
        color: AppConfig.appBackgroundColor,
        child: Stack(
          children: [
            Padding(
                padding: EdgeInsets.only(
                  top: 125
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/app-icon.png',
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    icon: Image.asset(
                      'assets/images/google.png', // Add your Google logo here
                      height: 24,
                      width: 24,
                    ),
                    onPressed: () => _handleSignIn(context),
                    label: Text('Sign in with Google'),
                  ),
                  // SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}