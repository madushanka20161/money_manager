import 'package:flutter/material.dart';
import 'package:money_manager_3/dto/account_dto.dart';
import 'package:money_manager_3/dto/transaction_dto.dart';
import 'package:money_manager_3/helper/index.dart';
import 'package:money_manager_3/service/userstate_service.dart';
import 'package:money_manager_3/state/app_state.dart';
import 'package:money_manager_3/state/user_state.dart';
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
  final appState = AppState();
  String? defaultTimePeriod = UserStateService.instance.defaultTimePeriod;
  List<String> periods = ['day', 'week', 'month', 'year', 'custom'];
  List<bool> isSelectedToggleButton = [false, false, false, false, false];
  
  @override
  void initState() {
    super.initState();
    isSelectedToggleButton[periods.indexOf(defaultTimePeriod!)] = true;
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final userState = context.watch<UserState>();
    final accounts = context.watch<AppState>().accounts;
    final String selectedAccountId = context.watch<AppState>().selectedAccountId;

    final List<AccountDto> accountList = accounts.values.toList();
    accountList.insert(0, AccountDto(id: '0', name: 'All Accounts'));
    // TODO [need to add create account option]
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

    Future<void> _showDateTimePicker() async {
      late DateTime startDate;
      late DateTime endDate;

      // TODOD: [V2] Implement check box for select all dates
      await showDateRangePicker(
        context: context,
        firstDate: DateTime(2000),
        lastDate: DateTime.now(),
        builder: (BuildContext context, Widget? child) {
          return Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.6,
              child: child,
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
          await _showDateTimePicker();
          break;
      }

      userState.setDefaultTimePeriod(period);
    }

    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Total Balance", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                SizedBox(height: 20),
                DropdownButton<String>(
                  hint: Text('All Accounts'),
                  value: selectedAccountId == '' ? null : selectedAccountId,
                  items: accountList.map((AccountDto account) {
                    return DropdownMenuItem<String>(
                      value: account.id,
                      child: Text(account.name.toString()),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      if (value.toString() == '0') {
                        appState.setSelectedAccountId('');
                      } else {
                        appState.setSelectedAccountId(value.toString());
                      }
                    });
                  },
                ),
              ],
            ),
            Text(
              '$defaultCurrency ${totalBalance.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.arrow_upward),
                Text('$defaultCurrency. $totalIncome'),
                SizedBox(width: 20),
                Icon(Icons.arrow_downward),
                Text('$defaultCurrency. $totalExpenses'),
              ],
            ),
            
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
              ],
            ),
            ToggleButtons(
              isSelected: isSelectedToggleButton,
              onPressed: (int index) {
                onDataPeriodChanged(periods[index]);
                isSelectedToggleButton.fillRange(0, isSelectedToggleButton.length, false);
                isSelectedToggleButton[index] = !isSelectedToggleButton[index];
              },
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text('Day'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text('Week'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text('Month'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text('Year'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text('Custom'),
                ),
              ],  
            ),
            CurrentTimePeriod(),
          ],
        ),
      );
  }
}