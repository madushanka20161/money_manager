import 'package:flutter/material.dart';
import 'package:money_manager_3/helper/config.dart';
import 'package:money_manager_3/service/shared_service.dart';
import 'package:money_manager_3/state/app_state.dart';
import 'package:money_manager_3/widget/input/currency_selection.dart';
import 'package:provider/provider.dart';

class DefaultCurrency extends StatefulWidget {
  const DefaultCurrency({Key? key}) : super(key: key);

  @override
  _DefaultCurrencyState createState() => _DefaultCurrencyState();
}

class _DefaultCurrencyState extends State<DefaultCurrency> {
  String? selectedCurrency;

  @override
  Widget build(BuildContext context) {
    AppState appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Choose Your Currency'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CurrencySelectionList(
                  topPadding: 0,
                  isNavigatorPopDisbale: true,
                  onCurrencyChange: (String value) {
                    selectedCurrency = value;
                  }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          color: Color.fromARGB(255, 18, 73, 128), // Transparent background
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                style: AppConfig.elevatedButtonStyle,
                onPressed: () {
                  appState.setIsFirstLogin(false);
                },
                child: Text(
                  'Skip',
                  style: AppConfig.fontStyle,
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                style: AppConfig.elevatedButtonStyle,
                onPressed: () {
                  appState.setIsFirstLogin(false);

                  if (selectedCurrency != null) {
                    SharedService.instance
                        .updateDefaultCurrency(selectedCurrency!);
                  }
                },
                child: Text(
                  'Next',
                  style: AppConfig.fontStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
