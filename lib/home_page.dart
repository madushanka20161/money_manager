import 'package:flutter/material.dart';
import 'package:money_manager_3/dto/transaction_dto.dart';
import 'package:money_manager_3/enum/index.dart';
import 'package:money_manager_3/state/app_state.dart';
import 'package:money_manager_3/widget/home/home_details.dart';
import 'package:money_manager_3/widget/home/home_summary.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final transactions = context.watch<AppState>().transactions;
    final selectedAccountId = context.watch<AppState>().selectedAccountId;
    DateTime startDate = context.watch<AppState>().startDate;
    DateTime endDate = context.watch<AppState>().endDate;
    List<TransactionDto> filterTransactions = [];

    // filter transactions based on time period
    filterTransactions = transactions.values.where((transaction) => transaction.date == startDate || transaction.date.isAfter(startDate) && transaction.date.isBefore(endDate)).toList();

    if (selectedAccountId != '') {
      filterTransactions = filterTransactions.where((transaction) => transaction.account == selectedAccountId).toList();
    }

    List<TransactionDto> income = filterTransactions.where((transaction) => transaction.type == TransactionType.income).toList();
    List<TransactionDto> expenses = filterTransactions.where((transaction) => transaction.type == TransactionType.expenses).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Money Mate'),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Drawer Header',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple], // Start and end colors
              begin: Alignment.topLeft, // Gradient starts at the top-left
              end: Alignment.bottomRight, // Gradient ends at the bottom-right
            ),
          ),
            child: Center(
              child: HomeSummary(
                income: income, 
                expenses: expenses
              ),
            ),
          ),
          Container(
            color: Colors.green,
            height: MediaQuery.of(context).size.height - 374,
            child: Center(
              child: HomeDetails(income: income, expenses: expenses),
            ),
          )
        ],
      )
    );
  }
}