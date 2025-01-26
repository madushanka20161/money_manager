import 'package:flutter/material.dart';
import 'package:money_manager_3/dto/account_dto.dart';
import 'package:money_manager_3/dto/category_dto.dart';
import 'package:money_manager_3/dto/transaction_dto.dart';
import 'package:money_manager_3/enum/index.dart';
import 'package:money_manager_3/state/app_state.dart';
import 'package:provider/provider.dart';

class HomeDetails extends StatefulWidget {
  final List<TransactionDto> income;
  final List<TransactionDto> expenses;
  final Function onTabChanged;

  HomeDetails({
    required this.income, 
    required this.expenses,
    required this.onTabChanged
  });

  @override
  _HomeDetailsState createState() => _HomeDetailsState();
}

class _HomeDetailsState extends State<HomeDetails> with SingleTickerProviderStateMixin {
  late TabController _tabController;

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

  @override
  Widget build(BuildContext context) {
    final accounts = context.watch<AppState>().accounts;
    final category = context.watch<AppState>().categories;

    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Expenses'),
            Tab(text: 'Income'),
          ],
          onTap: (value) {
            if (value.toString() == '0') {
              widget.onTabChanged(TransactionType.expenses.displayName);
            } else {
              widget.onTabChanged(TransactionType.income.displayName);
            }
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
    List<TransactionDto> data = type == TransactionType.income.toString() ? widget.income : widget.expenses;

    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(categories[data[index].category]!.icon), // this need to be updated based on category
          title: Text('${data[index].amount} | ${accounts[data[index].account]?.name}'),
          subtitle: Text(data[index].description),
        );
      },
    );
  }
}