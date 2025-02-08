import 'package:flutter/material.dart';
import 'package:money_manager_3/dto/account_trnsaction_dto.dart';
import 'package:money_manager_3/service/shared_service.dart';
import 'package:money_manager_3/state/app_state.dart';
import 'package:money_manager_3/widget/account/create_account_trnsaction.dart';
import 'package:provider/provider.dart';

class AccountTransactionView extends StatefulWidget {
  @override
  _AccountTransactionViewState createState() => _AccountTransactionViewState();
}

class _AccountTransactionViewState extends State<AccountTransactionView> {
  @override
  Widget build(BuildContext context) {
    Map<String, AccountTransactionDTO> accountTrnsactions = context.watch<AppState>().accountTrnsactions;
    List<AccountTransactionDTO> trnsactionList = accountTrnsactions.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction History'),
      ),
      body: ListView.builder(
        itemCount: trnsactionList.length,
        itemBuilder: (context, index) {
          final transaction = trnsactionList[index];

          return ListTile(
            title: Text('${transaction.fromAccount.name} -> ${transaction.toAccount.name}'),
            subtitle: Row(
              children: [
                transaction.amount == transaction.toAmount
                    ? Text(transaction.amount.toStringAsFixed(2))
                    : Text('${transaction.amount.toStringAsFixed(2)} -> ${transaction.toAmount.toStringAsFixed(2)}'),
                Text(transaction.description),
              ],
            ),
            trailing: SizedBox(
              width: 96,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CreateAccountTransaction(
                          accountTrnsaction: transaction,
                        )),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Confirm Deletion'),
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
                                  SharedService.instance.deleteAccounttrnsaction(transaction.id);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                      // Add your delete logic here
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}