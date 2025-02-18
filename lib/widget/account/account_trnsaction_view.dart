import 'package:flutter/material.dart';
import 'package:money_manager_3/custom_painter.dart';
import 'package:money_manager_3/dto/account_trnsaction_dto.dart';
import 'package:money_manager_3/helper/config.dart';
import 'package:money_manager_3/helper/index.dart';
import 'package:money_manager_3/service/shared_service.dart';
import 'package:money_manager_3/state/app_state.dart';
import 'package:money_manager_3/widget/account/create_account_transaction.dart';
import 'package:provider/provider.dart';

class AccountTransactionView extends StatefulWidget {
  @override
  _AccountTransactionViewState createState() => _AccountTransactionViewState();
}

class _AccountTransactionViewState extends State<AccountTransactionView> {

  void deletTrnsaction(AccountTransactionDTO transaction) {
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
  }

  @override
  Widget build(BuildContext context) {
    Map<String, AccountTransactionDTO> accountTrnsactions = context.watch<AppState>().accountTrnsactions;
    List<AccountTransactionDTO> trnsactionList = accountTrnsactions.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction History'),
      ),
      body: Stack(
        children: [
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
            painter: DiagonalPainter(),
          ),
          Padding(
            padding: EdgeInsets.all(AppConfig.padding),
            child: ListView.builder(
              itemCount: trnsactionList.length,
              itemBuilder: (context, index) {
                final transaction = trnsactionList[index];

                return Column(
                  children: [
                    SizedBox(height: AppConfig.padding,),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: AppConfig.borderRadiusAll,
                        color: Colors.white.withOpacity(0.1),
                      ),
                      padding: EdgeInsets.all(AppConfig.padding),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(capitalizeFirstLetter(transaction.fromAccount.name), style: AppConfig.fontStyle,),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: AppConfig.padding),
                                      child: Icon(Icons.arrow_forward, size: AppConfig.iconSize * 0.5, color: AppConfig.iconColor,),
                                    ),
                                    Text(capitalizeFirstLetter(transaction.toAccount.name), style: AppConfig.fontStyle,)
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('${transaction.fromAccount.currency}: ${formatNumber(transaction.amount)}', style: AppConfig.fontStyle,),
                                    if (transaction.amount != transaction.toAmount) ...[
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: AppConfig.padding),
                                        child: Icon(Icons.arrow_forward, size: AppConfig.iconSize * 0.5, color: AppConfig.iconColor,),
                                      ),
                                      Text('${transaction.toAccount.currency}: ${formatNumber(transaction.toAmount)}', style: AppConfig.fontStyle,),
                                    ]
                                  ],
                                ),
                                Text(capitalizeFirstLetter(transaction.description), style: TextStyle(color: AppConfig.fontColor.withOpacity(0.6), fontSize: AppConfig.fontSize * 0.8),),
                                Text(formatDate(transaction.date), style: TextStyle(color: AppConfig.fontColor.withOpacity(0.6), fontSize: AppConfig.fontSize * 0.8),),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, size: AppConfig.iconSize * 0.7, color: AppConfig.iconColor,),
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
                                icon: Icon(Icons.delete, size: AppConfig.iconSize * 0.7, color: AppConfig.iconColor,),
                                onPressed: () {
                                  deletTrnsaction(transaction);
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}