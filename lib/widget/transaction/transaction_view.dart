import 'package:flutter/material.dart';
import 'package:money_manager_3/dto/transaction_dto.dart';
import 'package:money_manager_3/service/shared_service.dart';
import 'package:money_manager_3/widget/transaction/create_transaction.dart';

class TransactionView extends StatelessWidget {
  final TransactionDto transaction;

  const TransactionView({
    required this.transaction
  });
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction View'),
      ),
      body: Card(
        margin: EdgeInsets.all(10.0),
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Account: ${transaction.account.name}', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
              Text('Amount: ${transaction.amount.toStringAsFixed(2)}', style: TextStyle(fontSize: 16.0)),
              Text('Date: ${transaction.date.toLocal().toString().split(' ')[0]}', style: TextStyle(fontSize: 16.0)),
              Text('Category: ${transaction.category.name}', style: TextStyle(fontSize: 16.0)),
              Text('Description: ${transaction.description}', style: TextStyle(fontSize: 16.0)),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      editTransaction(context);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      deleteTransaction(context);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.copy),
                    onPressed: () {
                      copyTransaction(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      )
    );
  }

  void editTransaction(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateTransaction(
          transaction: transaction,
          isTrnsactionEdit: true,
        )
      )
    );
  }

  void copyTransaction(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateTransaction(
          transaction: transaction,
          isTrnsactionCopy: true,
        )
      )
    );
  }

  void deleteTransaction(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this transaction?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                SharedService.instance.deleteTransaction(transaction);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}