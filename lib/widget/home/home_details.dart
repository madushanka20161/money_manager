import 'package:flutter/material.dart';
import 'package:money_manager_3/dto/account_dto.dart';
import 'package:money_manager_3/dto/category_dto.dart';
import 'package:money_manager_3/dto/transaction_dto.dart';
import 'package:money_manager_3/enum/index.dart';
import 'package:money_manager_3/state/app_state.dart';
import 'package:money_manager_3/widget/transaction/transaction_list.dart';
import 'package:provider/provider.dart';

class HomeDetails extends StatefulWidget {
  final List<TransactionDto> income;
  final List<TransactionDto> expenses;

  HomeDetails({
    required this.income, 
    required this.expenses,
  });

  @override
  _HomeDetailsState createState() => _HomeDetailsState();
}

class _HomeDetailsState extends State<HomeDetails> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, dynamic> transactionByCategory = {};
  double total = 0;
  TransactionType selectedTab = TransactionType.expenses;
  Function? setSelectedTransactionType;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void generateTransactionByCategory() {
    List<TransactionDto> collection = (selectedTab == TransactionType.income) ? widget.income : widget.expenses;
    transactionByCategory.clear();
    total = 0;

    for (var transaction in collection) {
      total = total + transaction.amount;

      if (transactionByCategory[transaction.category] == null) {
        transactionByCategory[transaction.category] = {
          'total': transaction.amount,
          'transaction': [transaction]
        };
      } else {
        transactionByCategory[transaction.category]['total'] = transactionByCategory[transaction.category]['total'] + transaction.amount;
        transactionByCategory[transaction.category]['transaction'].add(transaction);
      }
    }

    transactionByCategory.forEach((key, value) {
      value['percentage'] = (value['total'] / total) * 100;
    });

    transactionByCategory = Map.fromEntries(
      transactionByCategory.entries.toList()
      ..sort((a, b) => b.value['total'].compareTo(a.value['total']))
    );
  }

  void onTabChanged(int value) {
    if (value.toString() == '0') {
      selectedTab = TransactionType.expenses;
    } else {
      selectedTab = TransactionType.income;
    }

    setSelectedTransactionType!(selectedTab);
  }

  @override
  Widget build(BuildContext context) {
    generateTransactionByCategory();
    final accounts = context.watch<AppState>().accounts;
    final category = context.watch<AppState>().categories;
    setSelectedTransactionType = context.watch<AppState>().setSelectedTransactionType;

    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Expenses'),
            Tab(text: 'Income'),
          ],
          onTap: (value) {
            onTabChanged(value);
          },
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildListView(
                TransactionType.expenses.toString(), accounts, category
              ),
              _buildListView(
                TransactionType.income.toString(), accounts, category
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildListView(String type, Map<String, AccountDto> accounts, Map<String, CategoryDTO> categories) {
    final List<String> keyList = transactionByCategory.keys.toList();

    return ListView.builder(
      itemCount: keyList.length,
      itemBuilder: (context, index) {
        final data = transactionByCategory[keyList[index]];

        if (data ==  null) {
          return null;
        }

        return ListTile(
          leading: Icon(categories[keyList[index]]!.icon),
          title: Text('${data['total']} | ${categories[keyList[index]]!.name} | ${data['percentage'].toStringAsFixed(2)}%'),
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => TransactionList(
                  trnsactionType: selectedTab,
                  category: categories[keyList[index]]!,
                ),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.ease;
                  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);

                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}