import 'package:flutter/material.dart';
import 'package:money_manager_3/helper/config.dart';
import 'package:money_manager_3/home_page.dart';
import 'package:money_manager_3/service/auth_service.dart';
import 'package:money_manager_3/service/database_service.dart';
import 'package:money_manager_3/service/shared_service.dart';
import 'package:money_manager_3/sign_up.dart';
import 'package:money_manager_3/state/app_state.dart';
import 'package:money_manager_3/state/user_state.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  // debugPaintSizeEnabled = true;
  await DatabaseService.instance.init();

  runApp(
    MultiProvider(
      providers: [
      ChangeNotifierProvider(create: (context) => AppState()),
        ChangeNotifierProvider(create: (context) => UserState()),
      ],
      child: MyApp(),
    ),
  );

  WidgetsBinding.instance.addPostFrameCallback((_) async {
    final appState = Provider.of<AppState>(navigatorKey.currentContext!, listen: false);
    final userState = Provider.of<UserState>(navigatorKey.currentContext!, listen: false);
    SharedService.instance.init(appState);

    try {
      await AuthService.instance.init(appState, userState);
      await AuthService.instance.checkAuth();
    } catch (e) {
      showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) => AlertDialog(
          title: Text("Something went wrong"),
          content: Text(e.toString().replaceFirst('Exception: ', '')),
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
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Money Mate',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: AppConfig.appTitleColor,
          foregroundColor: AppConfig.fontColor,
        )
      ),
      home: LandingScreen()
    );
  }
}

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AppState>().isLoading;
    final isSignIn = context.watch<AppState>().isSignIn;
    
    return isLoading
      ? Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      )
      : isSignIn
        ? HomePage()
        : SignUpPage();
  }
}