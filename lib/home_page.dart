import 'dart:math';

import 'package:flutter/material.dart';
import 'package:money_manager_3/custom_painter.dart';
import 'package:money_manager_3/dto/transaction_dto.dart';
import 'package:money_manager_3/dto/user_dto.dart';
import 'package:money_manager_3/enum/index.dart';
import 'package:money_manager_3/helper/config.dart';
import 'package:money_manager_3/helper/filter.dart';
import 'package:money_manager_3/state/app_state.dart';
import 'package:money_manager_3/state/user_state.dart';
import 'package:money_manager_3/widget/account/account_page.dart';
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
    UserDTO user = context.watch<UserState>().user!;
    List<TransactionDto> income = filteredTransactions[0];
    List<TransactionDto> expenses = filteredTransactions[1];
    selectedTab = context.watch<AppState>().selectedTransactionType;

    return Scaffold(
      appBar: AppBar(
        title: Text('Money Mate'),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: Stack(
          children: [
            CustomPaint(
              size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
              painter: DiagonalPainter(),
            ),
            Column(
              children: [
                SizedBox(
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  child: DrawerHeader(
                    decoration: BoxDecoration(
                      color: Color(0xFF242C3B),
                    ),
                    child: Text(
                      user.name,
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      ListTile(
                        leading: Icon(Icons.home, color: AppConfig.iconColor, size: AppConfig.iconSizeSmall),
                        title: Text('Home', style: AppConfig.fontStyle),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.account_balance, color: AppConfig.iconColor, size: AppConfig.iconSizeSmall),
                        title: Text('Accounts', style: AppConfig.fontStyle),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AccountPage()));
                        },
                      ),
                      // ListTile(
                      //   leading: Icon(Icons.settings, color: AppConfig.iconColor, size: AppConfig.iconSizeSmall),
                      //   title: Text('Settings', style: AppConfig.fontStyle),
                      //   onTap: () {
                      //     Navigator.pop(context);
                      //   },
                      // ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.update, color: AppConfig.iconColor, size: AppConfig.iconSizeSmall),
                      title: Text('Update', style: AppConfig.fontStyle),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.logout, color: Colors.red, size: AppConfig.iconSizeSmall),
                      title: Text('Logout', style: TextStyle(color: Colors.red, fontSize: AppConfig.fontSize)),
                      onTap: () {
                        // Handle logout
                      },
                    ),
                  ],
                ),
              ],
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
                    minHeight: 60,
                    maxHeight: max(MediaQuery.of(context).size.height - 50 - 360, 300), // (50 - height of add button, 360 - height of home)
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
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                      CreateTransaction(transactionType: selectedTab),
                  ),
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width - 40, 
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: AppConfig.buttonSelectedColor,
                ),
                height: 50,
                child: Center(
                  child: Icon(Icons.add, size: AppConfig.iconSize, color: AppConfig.iconColor,),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}