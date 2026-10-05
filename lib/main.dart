import 'package:flutter/material.dart';
import 'package:money_manager_3/exception/api-exception.dart';
import 'package:money_manager_3/helper/config.dart';
import 'package:money_manager_3/home_page.dart';
import 'package:money_manager_3/service/ads_service.dart';
import 'package:money_manager_3/service/auth_service.dart';
import 'package:money_manager_3/service/database_service.dart';
import 'package:money_manager_3/service/network_service.dart';
import 'package:money_manager_3/service/notification_service.dart';
import 'package:money_manager_3/service/shared_service.dart';
import 'package:money_manager_3/sign_up.dart';
import 'package:money_manager_3/state/app_state.dart';
import 'package:money_manager_3/state/user_state.dart';
import 'package:money_manager_3/widget/default/default-currency.dart';
import 'package:money_manager_3/widget/loading/loading.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart' as ads;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  // debugPaintSizeEnabled = true;
  await DatabaseService.instance.init();
  await NotificationService.instance.init();

  // nsures all the core bindings and services (like platform channels,
  // rendering, and asynchronous tasks) are initialized before you run
  // your app or execute any native plugin code.
  WidgetsFlutterBinding.ensureInitialized();

  ads.MobileAds.instance.initialize();

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
    setupApp();
  });
}

Future<void> setupApp() async {
  final appState =
      Provider.of<AppState>(navigatorKey.currentContext!, listen: false);
  final userState =
      Provider.of<UserState>(navigatorKey.currentContext!, listen: false);
  SharedService.instance.init(appState, userState);
  NetworkService.instance.init(userState);
  AdsService.instance.init(userState, appState);

  try {
    await AuthService.instance.init(appState, userState);
    await AuthService.instance.checkAuth();
    
    if (userState.user != null) {
      await AuthService.instance.onAuthSuccess();
    }
  } on ApiException catch (error) {
    NetworkService.instance.sendErrorLogs(error.message);
    appState.setSignupErrorMessage(error.message);
    appState.setIsLoading(false);
  } catch (error) {
    NetworkService.instance.sendErrorLogs(error.toString());
    await AuthService.instance.onAuthSuccess();
  }
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
            )),
        home: LandingScreen());
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
    final isFirstLogin = context.watch<AppState>().isFirstLogin;

    return isLoading
        ? Loading()
        : isSignIn
            ? isFirstLogin
                ? DefaultCurrency()
                : HomePage()
            : SignUpPage();
  }
}
