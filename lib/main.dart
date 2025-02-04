import 'package:flutter/material.dart';
// import 'package:money_manager_3/enum/index.dart';
// import 'package:flutter/rendering.dart';
import 'package:money_manager_3/home_page.dart';
import 'package:money_manager_3/service/auth_service.dart';
import 'package:money_manager_3/service/database_service.dart';
import 'package:money_manager_3/service/shared_service.dart';
import 'package:money_manager_3/state/app_state.dart';
import 'package:money_manager_3/state/user_state.dart';
// import 'package:money_manager_3/widget/category/create_category.dart';
// import 'package:money_manager_3/widget/transaction/create_transaction.dart';
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

  WidgetsBinding.instance.addPostFrameCallback((_) {
    final appState = Provider.of<AppState>(navigatorKey.currentContext!, listen: false);
    final userState = Provider.of<UserState>(navigatorKey.currentContext!, listen: false);
    SharedService.instance.init(appState);
    AuthService.instance.init(appState, userState);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LandingScreen()
      // home: CreateTransaction(transactionType: TransactionType.expenses,)
      // home: CreateCategory()
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
    
    return isLoading ? 
      Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        )
      : 
      HomePage();
  }
}