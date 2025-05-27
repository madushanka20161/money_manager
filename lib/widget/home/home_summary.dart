import 'package:flutter/material.dart';
import 'package:money_manager_3/dto/account_dto.dart';
import 'package:money_manager_3/dto/transaction_dto.dart';
import 'package:money_manager_3/helper/config.dart';
import 'package:money_manager_3/helper/index.dart';
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
  String? defaultTimePeriod = UserStateService.instance.defaultTimePeriod;
  List<String> periods = ['day', 'week', 'month', 'year', 'custom'];
  List<bool> isSelectedToggleButton = [false, false, false, false, false];
  
  @override
  void initState() {
    super.initState();
    isSelectedToggleButton[periods.indexOf(defaultTimePeriod!)] = true;
  }

  void _onAccountChange(String id) {
    setState(() {
      appState.setSelectedAccountId(id.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    appState = context.watch<AppState>();
    final userState = context.watch<UserState>();
    final accounts = context.watch<AppState>().accounts;
    final String selectedAccountId = context.watch<AppState>().selectedAccountId;

    final List<AccountDto> accountList = accounts.values.toList();
    accountList.insert(0, AccountDto(id: '0', name: 'All Accounts'));
    double totalBalance;

    if (selectedAccountId == '') {
      totalBalance = accounts.values
        .where((account) => account.isAddToTotal == true)
        .fold(0.0, (double sum, account) => sum + account.balance);
    } else {
      totalBalance = accounts[selectedAccountId]?.balance ?? 0.0;
    }

    double totalIncome = widget.income.fold(0.0, (double sum, transaction) => sum + transaction.amount);
    double totalExpenses = widget.expenses.fold(0.0, (double sum, transaction) => sum + transaction.amount);

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
      late DateTime startDate;
      late DateTime endDate;

      switch (period) {
        case 'day':
        case 'week':
        case 'month':
        case 'year':
          final dateRange = getDateRange(period, null);
          startDate = dateRange[0];
          endDate = dateRange[1];
          appState.setDateRange(startDate, endDate);
          break;
        default:
          await showDateTimePicker();
          break;
      }

      userState.setDefaultTimePeriod(period);
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
                Text("Total Balance", style: TextStyle(fontSize: AppConfig.fontSize, color: AppConfig.fontColor),),
                AccountSelectionDropdown(
                  onAccountSelect: _onAccountChange,
                  isCreateAccountOptionEnable: true,
                ),
              ],
            ),
            Row(
              children: [
                Text('$defaultCurrency ${totalBalance.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: AppConfig.headerFontSize, fontWeight: FontWeight.bold, color: AppConfig.fontColor),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                    Icon(Icons.arrow_upward, color: Colors.green, size: AppConfig.iconSize,),
                    SizedBox(width: 10,),
                    Text('$defaultCurrency. $totalIncome', style: TextStyle(color: AppConfig.fontColor, fontSize: AppConfig.fontSize),),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.arrow_downward, color: Colors.red, size: AppConfig.iconSize,),
                    SizedBox(width: 10,),
                    Text('$defaultCurrency. $totalExpenses', style: TextStyle(color: AppConfig.fontColor, fontSize: AppConfig.fontSize),),
                  ],
                ),
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
                  child: Text('Day', style: TextStyle(color: AppConfig.fontColor, fontSize: AppConfig.fontSize),),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text('Week', style: TextStyle(color: AppConfig.fontColor, fontSize: AppConfig.fontSize),),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text('Month', style: TextStyle(color: AppConfig.fontColor, fontSize: AppConfig.fontSize),),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text('Year', style: TextStyle(color: AppConfig.fontColor, fontSize: AppConfig.fontSize),),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text('Custom', style: TextStyle(color: AppConfig.fontColor, fontSize: AppConfig.fontSize),),
                ),
              ],  
            ),
            CurrentTimePeriod(),
          ],
        ),
      ),
    );
  }
}