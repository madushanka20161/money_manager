import 'package:flutter/material.dart';
import 'package:money_manager_3/home_page.dart';
import 'package:money_manager_3/service/auth_service.dart';
import 'package:money_manager_3/service/database_service.dart';
import 'package:money_manager_3/state/app_state.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  await DatabaseService.instance.init();

  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MyApp(),
    ),
  );

  WidgetsBinding.instance.addPostFrameCallback((_) {
    final appState = Provider.of<AppState>(navigatorKey.currentContext!, listen: false);
    AuthService.instance.init(appState);
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
      home: HomePage()
    );
  }
}