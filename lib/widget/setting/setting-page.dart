import 'package:flutter/material.dart';
import 'package:money_manager_3/helper/config.dart';
import 'package:money_manager_3/home_page.dart';
import 'package:money_manager_3/service/shared_service.dart';
import 'package:money_manager_3/service/userstate_service.dart';
import 'package:money_manager_3/widget/default/default-decimal-places.dart';
import 'package:money_manager_3/widget/default/default-number-format.dart';
import 'package:money_manager_3/widget/default/default-time-period.dart';
import 'package:money_manager_3/widget/input/currency_selection.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  // previos values
  String timePeriod = UserStateService.instance.defaultTimePeriod!;
  int decimalPlace = UserStateService.instance.defaultDecimalPlace!;
  String numberFormat = UserStateService.instance.defaultNumberSeperationStyle!;
  String currency = UserStateService.instance.defaultCurrency!;
  // new values
  String? selectedTimePeriod;
  int? selectedDecimalPlaces;
  String? selectedNumberFormat;
  String? selectedCurrency;

  bool canPop() {
    if (selectedCurrency != null &&
        currency.toUpperCase() != selectedCurrency!.toUpperCase()) {
      return false;
    }

    if (selectedTimePeriod != null && timePeriod != selectedTimePeriod) {
      return false;
    }

    if (selectedDecimalPlaces != null &&
        decimalPlace != selectedDecimalPlaces) {
      return false;
    }

    if (selectedNumberFormat != null && numberFormat != selectedNumberFormat) {
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop(), // disable default back behavior
      onPopInvoked: (didPop) async {
        if (!didPop) {
          final shouldPop = await _showConfirmDialog(context);
          if (shouldPop) {
            Navigator.of(context).pop(); // Manually pop the screen
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: AppConfig.backgroundWrapper(
          context,
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: AppConfig.padding),
                  child: Text(
                    'Default Currency',
                    style: AppConfig.fontStyle
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppConfig.padding),
                  child: CurrencySelection(
                    onCurrencyChange: (String currency) {
                      setState(() {
                        selectedCurrency = currency;
                      });
                    },
                    selectedCurrency: currency,
                  ),
                ),
                rednerHorizontalLine(),
                DefaultTimePeriod(
                  onChanged: (String value) {
                    setState(() {
                      selectedTimePeriod = value;
                    });
                  },
                ),
                rednerHorizontalLine(),
                DefaultDecimalPlaces(onChanged: (String value) {
                  setState(() {
                    selectedDecimalPlaces = int.parse(value);
                  });
                }),
                rednerHorizontalLine(),
                DefaultNumberFormat(
                  onChanged: (String value) {
                    setState(() {
                      selectedNumberFormat = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            color: Color.fromARGB(255, 18, 73, 128), // Transparent background
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 16),
                ElevatedButton(
                  style: AppConfig.elevatedButtonStyle,
                  child: Text(
                    'Save',
                    style: AppConfig.fontStyle,
                  ),
                  onPressed: () {
                    setState(() {
                      if (selectedCurrency != null) {
                        currency = selectedCurrency!;
                        SharedService.instance
                            .updateDefaultCurrency(selectedCurrency!);
                      }

                      if (selectedDecimalPlaces != null) {
                        decimalPlace = selectedDecimalPlaces!;
                        SharedService.instance.updateDefaultDecimalPlaces(
                            selectedDecimalPlaces.toString());
                      }

                      if (selectedNumberFormat != null) {
                        numberFormat = selectedNumberFormat!;
                        SharedService.instance.updateDefaultNumberFormatStyle(
                            selectedNumberFormat!);
                      }

                      if (selectedTimePeriod != null) {
                        timePeriod = selectedTimePeriod!;
                        SharedService.instance
                            .updateDefaultTimePeriod(selectedTimePeriod!);
                      }
                    });

                    // Navigator.pop(context);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              HomePage()), // or your target screen
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _showConfirmDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: AppConfig.appBackgroundColor,
              title: Text(
                'Unsaved Changes',
                style: AppConfig.fontStyle
                    .copyWith(fontSize: AppConfig.alertTitleFontSize),
              ),
              content: Text(
                'You have unsaved changes. Do you want to discard them?',
                style: AppConfig.fontStyle.copyWith(fontSize: 14),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    'Cancel',
                    style: AppConfig.fontStyle,
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('Discard'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  Widget rednerHorizontalLine() {
    return Container(
      margin: const EdgeInsets.only(right: 10, left: 10),
      child: const Divider(
        color: Colors.grey,
        thickness: 1,
      ),
    );
  }
}
