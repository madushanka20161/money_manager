import 'package:flutter/material.dart';
import 'package:money_manager_3/custom_painter.dart';
import 'package:money_manager_3/dto/transaction_dto.dart';
import 'package:money_manager_3/helper/config.dart';
import 'package:money_manager_3/helper/index.dart';
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
      body: Stack(
        children: [
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
            painter: DiagonalPainter(),
          ),
          Card(
            color: Colors.transparent,
            margin: EdgeInsets.all(AppConfig.padding),
            child: Padding(
              padding: EdgeInsets.all(AppConfig.padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Account Name: ${capitalizeFirstLetter(transaction.account.name)}', style: TextStyle(fontSize: AppConfig.fontSize, fontWeight: FontWeight.bold, color: AppConfig.fontColor,)),
                  Text('${transaction.account.currency}: ${transaction.amount.toStringAsFixed(2)}', style: AppConfig.fontStyle),
                  Text(transaction.date.toLocal().toString().split(' ')[0], style: AppConfig.fontStyle),
                  Text('Category: ${transaction.category.name}', style: AppConfig.fontStyle),
                  Text('Description: ${transaction.description}', style: AppConfig.fontStyle),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, size: AppConfig.iconSizeSmall, color: AppConfig.iconColor,),
                        onPressed: () {
                          editTransaction(context);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, size: AppConfig.iconSizeSmall, color: AppConfig.iconColor,),
                        onPressed: () {
                          deleteTransaction(context);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.copy, size: AppConfig.iconSizeSmall, color: AppConfig.iconColor,),
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
        ],
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