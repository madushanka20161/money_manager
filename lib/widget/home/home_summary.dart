import 'package:flutter/material.dart';
import 'package:money_manager_3/dto/account_dto.dart';
import 'package:money_manager_3/dto/transaction_dto.dart';
import 'package:money_manager_3/enum/index.dart';
import 'package:money_manager_3/helper/config.dart';
import 'package:money_manager_3/helper/currency.dart';
import 'package:money_manager_3/helper/number-format.dart';
import 'package:money_manager_3/helper/text.dart';
import 'package:money_manager_3/service/shared_service.dart';
import 'package:money_manager_3/service/userstate_service.dart';
import 'package:money_manager_3/state/app_state.dart';
import 'package:money_manager_3/state/user_state.dart';
import 'package:money_manager_3/widget/account/accoun_selection_dropdown.dart';
import 'package:money_manager_3/widget/home/current_time_period.dart';
import 'package:provider/provider.dart';

class HomeSummary extends StatefulWidget {
  final List<TransactionDto> income;
  final List<TransactionDto> expenses;

  HomeSummary({
    required this.income, 
    required this.expenses,
  });

  @override
  _HomeSummaryState createState() => _HomeSummaryState();
}

class _HomeSummaryState extends State<HomeSummary> {
  AppState appState = AppState();
  UserState userState = UserState();
  String? defaultTimePeriod = UserStateService.instance.defaultTimePeriod;
  String? selectedTimePeriod;
  List<String> periods = TimePeriod.values.map((e) => e.displayName).cast<String>().toList();
  List<bool> isSelectedToggleButton = [false, false, false, false, false];
  /* if all account select display currency = default currency, 
  if account select display currency is the currency of that account */
  String displayCurrency = UserStateService.instance.defaultCurrency!;
  
  @override
  void initState() {
    super.initState();
    setSelectedTimePeriodToggle();
  }

  @override
  Widget build(BuildContext context) {
    appState = context.watch<AppState>();
    userState = context.watch<UserState>();
    final accounts = appState.accounts;
    final String selectedAccountId = appState.selectedAccountId;
    defaultTimePeriod = userState.defaultTimePeriod;
    selectedTimePeriod = userState.selectedTimePeriod;
    setSelectedTimePeriodToggle();
    setDisplayCurrency(selectedAccountId);

    final List<AccountDto> accountList = accounts.values.toList();
    accountList.insert(0, AccountDto(id: '0', name: 'All Accounts'));
    double totalBalance;

    if (selectedAccountId == '') {
      totalBalance = accounts.values
        .where((account) => account.isAddToTotal == true)
        .fold(0.0, (double sum, account) {
          return sum + convertCurrency(account.currency, displayCurrency, account.balance);
        });
    } else {
      totalBalance = accounts[selectedAccountId]?.balance ?? 0.0;
    }

    double totalIncome = widget.income.fold(0.0, (double sum, transaction) {
      return sum +
          convertCurrency(transaction.account.currency, displayCurrency,
              transaction.amount);
    });
    double totalExpenses = widget.expenses.fold(0.0, (double sum, transaction) {
      return sum +
          convertCurrency(transaction.account.currency, displayCurrency,
              transaction.amount);
    });

    Future<void> showDateTimePicker() async {
      late DateTime startDate;
      late DateTime endDate;

      // TODO: [V2] Implement check box for select all dates
      await showDateRangePicker(
        context: context,
        firstDate: DateTime(2000),
        lastDate: DateTime.now(),
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData(
              colorScheme: ColorScheme.light(
                primary: Colors.white,
                onPrimary: Colors.black,
                surface: AppConfig.popupBKColor,
                onSurface: Colors.white,
                secondary: Colors.white.withOpacity(0.5),
              ),
              textTheme: TextTheme(
                // bodyLarge: TextStyle(color: Colors.black),
                bodyMedium: TextStyle(color: Colors.white),
              ),
            ),
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 520,
                child: child,
              ),
            ),
          );
        },
      ).then((pickedDateRange) {
        if (pickedDateRange != null) {
          startDate = DateTime(pickedDateRange.start.year, pickedDateRange.start.month, pickedDateRange.start.day, 0, 0, 0);
          endDate = DateTime(pickedDateRange.end.year, pickedDateRange.end.month, pickedDateRange.end.day, 23, 59, 59);

          appState.setDateRange(startDate, endDate);
        }
      });
    }

    Future<void> onDataPeriodChanged(String period) async {
      switch (period) {
        case 'day':
        case 'week':
        case 'month':
        case 'year':
          break;
        default:
          await showDateTimePicker();
          break;
      }

      SharedService.instance.updateSetectedTimePeriod(period);
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                flexibleEllipsisText("Total Balance"),
                AccountSelectionDropdown(
                  onAccountSelect: _onAccountChange,
                  isCreateAccountOptionEnable: true,
                ),
              ],
            ),
            Row(
              children: [
                ellipsisHeaderText('$displayCurrency ${formatNumber(totalBalance)}')
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Icon(
                        Icons.arrow_upward,
                        color: Colors.green,
                        size: AppConfig.iconSize,
                      ),
                      SizedBox(
                        width: AppConfig.paddingSmall,
                      ),
                      flexibleEllipsisText('$displayCurrency ${formatNumber(totalIncome)}')
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Icon(
                        Icons.arrow_downward,
                        color: Colors.red,
                        size: AppConfig.iconSize,
                      ),
                      SizedBox(
                        width: AppConfig.paddingSmall,
                      ),
                      flexibleEllipsisText('$displayCurrency ${formatNumber(totalExpenses)}')
                    ],
                  ),
                )
              ],
            ),   
            SizedBox(height: 5),
            ToggleButtons(
              isSelected: isSelectedToggleButton,
              fillColor: AppConfig.buttonSelectedColor,
              onPressed: (int index) {
                onDataPeriodChanged(periods[index]);
                isSelectedToggleButton.fillRange(0, isSelectedToggleButton.length, false);
                isSelectedToggleButton[index] = !isSelectedToggleButton[index];
              },
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: ellipsisText('Day'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: ellipsisText('Week'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: ellipsisText('Month'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: ellipsisText('Year'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: ellipsisText('Custom'),
                ),
              ],  
            ),
            CurrentTimePeriod(),
          ],
        ),
      ),
    );
  }

  void setSelectedTimePeriodToggle() {
    String timePeriod = selectedTimePeriod ?? defaultTimePeriod!;

    if (isSelectedToggleButton.contains(true)) {
      isSelectedToggleButton[isSelectedToggleButton.indexOf(true)] = false;
    }

    isSelectedToggleButton[periods.indexOf(timePeriod)] = true;
  }

  void setDisplayCurrency(String id) {
    displayCurrency = getDisplayCurrency(id);
  }

  void _onAccountChange(String id) {
    setDisplayCurrency(id);
    
    setState(() {
      appState.setSelectedAccountId(id.toString());
    });
  }
}