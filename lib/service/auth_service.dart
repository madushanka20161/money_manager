import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  AuthService._privateConstructor();

  static final AuthService instance = AuthService._privateConstructor();
  late GoogleSignIn _googleSignIn;

  Future<void> init() async {
    _googleSignIn = GoogleSignIn();
    signIn();
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      print("User signed out");
      // TODO: Need to clear storage
    } catch (error) {
      print("Error signing out: $error");
    }
  }

  Future<void> signIn() async {
    GoogleSignInAccount? user = await _googleSignIn.signIn();

    if (user != null) {
      print('111111111111111111111111111111111111111111');
      print(user);
      // TODO: Need to save user data to storage
      // TODO: Need to send api request
    } else {
      print('222222222222222222222222222222222222222222');
    }
  }

  Future<void> checkAuth() async {
    // Check auth logic here
  }
}