import 'package:flutter/material.dart';
import 'package:money_manager_3/dto/account_dto.dart';
import 'package:money_manager_3/dto/transaction_dto.dart';
import 'package:money_manager_3/enum/index.dart';
import 'package:money_manager_3/helper/config.dart';
import 'package:money_manager_3/helper/currency.dart';
import 'package:money_manager_3/helper/date-picker/date-range-picker-dialog.dart';
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

    // Returns true if the user confirmed a selection (Done or "All Time"),
    // false if they cancelled/dismissed the popup. The caller uses this to
    // decide whether 'custom' should actually be persisted as the selected
    // period - without it, cancelling would still mark Custom as selected.
    Future<bool> showDateTimePicker() async {
      final result = await showCustomDateRangePicker(
        context: context,
        firstDate: DateTime(2010),
        lastDate: DateTime.now(),
        initialStart: appState.startDate,
        initialEnd: appState.endDate,
      );

      if (result == null) return false;

      if (result.isAllTime) {
        final startDate = DateTime(2010, 1, 1, 0, 0, 0);
        final end = DateTime.now();
        final endDate = DateTime(end.year, end.month, end.day, 0, 0, 0);

        appState.setDateRange(startDate, endDate);
      } else if (result.start != null) {
        final startDate = DateTime(result.start!.year, result.start!.month, result.start!.day, 0, 0, 0);
        final end = result.end ?? result.start!;
        final endDate = DateTime(end.year, end.month, end.day, 23, 59, 59);

        appState.setDateRange(startDate, endDate);
      } else {
        return false;
      }

      return true;
    }

    Future<void> onDataPeriodChanged(String period) async {
      switch (period) {
        case 'day':
        case 'week':
        case 'month':
        case 'year':
          SharedService.instance.updateSetectedTimePeriod(period);
          break;
        default:
          final confirmed = await showDateTimePicker();

          if (confirmed) {
            SharedService.instance.updateSetectedTimePeriod(period);
          }
          break;
      }
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
                onDataPeriodChanged(periods[index]).then((_) {
                  if (mounted) setState(() {});
                });
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