import 'package:flutter/material.dart';
import 'package:money_manager_3/custom_painter.dart';
import 'package:money_manager_3/dto/transaction_dto.dart';
import 'package:money_manager_3/enum/index.dart';
import 'package:money_manager_3/helper/filter.dart';
import 'package:money_manager_3/state/app_state.dart';
import 'package:money_manager_3/widget/account/account_page.dart';
// import 'package:money_manager_3/widget/chart/line_chart.dart';
import 'package:money_manager_3/widget/home/home_details.dart';
import 'package:money_manager_3/widget/home/home_summary.dart';
import 'package:money_manager_3/widget/transaction/create_transaction.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TransactionType selectedTab = TransactionType.expenses;

  @override
  Widget build(BuildContext context) {
    List<List<TransactionDto>> filteredTransactions = filterTrnsaction(context.watch<AppState>(), null);
    List<TransactionDto> income = filteredTransactions[0];
    List<TransactionDto> expenses = filteredTransactions[1];

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
              leading: Icon(Icons.account_balance),
              title: Text('Accounts'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AccountPage(),
                  ),
                );
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
      body: Stack(
        children: [
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
            painter: DiagonalPainter(),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: HomeSummary(income: income, expenses: expenses),
                ),
                Container(
                  constraints: BoxConstraints(
                    minHeight: 60,  // Minimum width
                    maxHeight: 200,  // Maximum width
                  ),
                  height: double.infinity,
                  color: Colors.transparent,
                  child: Center(
                    child: HomeDetails(
                      income: income,
                      expenses: expenses,
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  child: Center(
                    child: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CreateTransaction(transactionType: selectedTab),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}