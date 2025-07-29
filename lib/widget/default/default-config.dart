import 'package:flutter/material.dart';
import 'package:money_manager_3/helper/config.dart';
import 'package:money_manager_3/service/shared_service.dart';
import 'package:money_manager_3/state/app_state.dart';
import 'package:money_manager_3/widget/default/default-decimal-places.dart';
import 'package:money_manager_3/widget/default/default-time-period.dart';
import 'package:provider/provider.dart';

class DefaultConfig extends StatefulWidget {
  const DefaultConfig({Key? key}) : super(key: key);

  @override
  _DefaultConfigState createState() => _DefaultConfigState();
}

class _DefaultConfigState extends State<DefaultConfig> {
  String? selectedTimePeriod;
  String? selectedDecimalPlaces;

  @override
  Widget build(BuildContext context) {
    AppState appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Customize Your Preferences'),
      ),
      body: AppConfig.backgroundWrapper(
          context,
          Column(
            children: [
              DefaultTimePeriod(
                onChanged: (String value) {
                  selectedTimePeriod = value;
                },
              ),
              rednerHorizontalLine(),
              DefaultDecimalPlaces(onChanged: (String value) {
                selectedDecimalPlaces = value;
              })
            ],
          )),
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
                  Navigator.pop(context);

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
                  Navigator.pop(context);

                  if (selectedTimePeriod != null) {
                    SharedService.instance
                        .updateDefaultTimePeriod(selectedTimePeriod!);
                  }

                  if (selectedDecimalPlaces != null) {
                    SharedService.instance
                        .updateDefaultDecimalPlaces(selectedDecimalPlaces!);
                  }

                  appState.setIsFirstLogin(false);
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

  Widget rednerHorizontalLine() {
    return Container(
      margin: EdgeInsets.only(right: 10, left: 10),
      child: Divider(
        color: Colors.grey,
        thickness: 1,
      ),
    );
  }
}
