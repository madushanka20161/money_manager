import 'package:flutter/material.dart';
import 'package:money_manager_3/dto/account_dto.dart';
import 'package:money_manager_3/dto/transaction_dto.dart';

class TransactionSearchDelegate extends SearchDelegate<TransactionDto> {
  final List<TransactionDto> transactions;
  final Map<String, AccountDto> accounts;
  final Function download;
  List<TransactionDto> results = [];

  TransactionSearchDelegate(this.transactions, this.accounts, this.download);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
      IconButton(
        icon: Icon(Icons.download),
        onPressed: () {
          download(results);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context,
            transactions[0]); // Pass a default or empty TransactionDto object
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListView(
      children: results
          .map<ListTile>((transaction) => ListTile(
                title: Text(
                    '${transaction.description} | ${transaction.amount} | ${accounts[transaction.account.id]!.name}'),
              ))
          .toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    filterTransaction();

    return ListView(
      children: results
          .map<ListTile>((transaction) => ListTile(
                title:
                    Text('${transaction.description} | ${transaction.amount}'),
              ))
          .toList(),
    );
  }

  void filterTransaction() {
    results = transactions
        .where((transaction) =>
            transaction.description.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
