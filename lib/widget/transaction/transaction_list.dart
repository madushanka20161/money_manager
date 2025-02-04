import 'package:flutter/material.dart';
import 'package:money_manager_3/dto/account_dto.dart';
import 'package:money_manager_3/dto/category_dto.dart';
import 'package:money_manager_3/dto/transaction_dto.dart';
import 'package:money_manager_3/enum/index.dart';
import 'package:money_manager_3/helper/filter.dart';
import 'package:money_manager_3/state/app_state.dart';
import 'package:money_manager_3/widget/transaction/create_transaction.dart';
import 'package:money_manager_3/widget/transaction/transaction_search_delegate.dart';
import 'package:money_manager_3/widget/transaction/transaction_view.dart';
import 'package:provider/provider.dart';

class TransactionList extends StatefulWidget {
  final CategoryDTO category;
  final TransactionType trnsactionType;

  TransactionList({
    required this.category,
    required this.trnsactionType,
  });

  @override
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  late List<TransactionDto> transactions;

  @override
  Widget build(BuildContext context) {
    final Map<String, AccountDto> accounts = context.watch<AppState>().accounts;
    List<List<TransactionDto>> filterTrnsactions = filterTrnsaction(context.watch<AppState>(), widget.category);
    transactions = widget.trnsactionType == TransactionType.income ? filterTrnsactions[0] : filterTrnsactions[1];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {
                showSearch(
                  context: context,
                  delegate: TransactionSearchDelegate(transactions, accounts, download),
                );
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () {
              download(transactions);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TransactionView(transaction: transactions[index]),
                ),
              );
            },
            title: Text('${transactions[index].description} | ${transactions[index].amount} | ${accounts[transactions[index].account.id]!.name}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => CreateTransaction(
            transactionType: widget.trnsactionType,
            category: widget.category,
          )));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void download(List<TransactionDto>? list) {
    // TODO [implement download options]
    print('1112222222   download click, ${list!.length}');
  }
}