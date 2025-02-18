import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_manager_3/custom_painter.dart';
// import 'package:money_manager_3/dto/account_dto.dart';
import 'package:money_manager_3/dto/category_dto.dart';
import 'package:money_manager_3/dto/transaction_dto.dart';
import 'package:money_manager_3/enum/index.dart';
import 'package:money_manager_3/helper/config.dart';
import 'package:money_manager_3/helper/filter.dart';
import 'package:money_manager_3/helper/index.dart';
import 'package:money_manager_3/state/app_state.dart';
import 'package:money_manager_3/widget/transaction/create_transaction.dart';
// import 'package:money_manager_3/widget/transaction/transaction_search_delegate.dart';
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
    // final Map<String, AccountDto> accounts = context.watch<AppState>().accounts;
    List<List<TransactionDto>> filterTrnsactions = filterTrnsaction(context.watch<AppState>(), widget.category);
    transactions = widget.trnsactionType == TransactionType.income ? filterTrnsactions[0] : filterTrnsactions[1];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: AppConfig.padding),
              child: Icon(widget.category.icon),
            ),
            Text(capitalizeFirstLetter(widget.category.name))
          ],
        ),
        // TODO: [V2] enable in version 2
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.search),
        //     onPressed: () {
        //       setState(() {
        //         showSearch(
        //           context: context,
        //           delegate: TransactionSearchDelegate(transactions, accounts, download),
        //         );
        //       });
        //     },
        //   ),
        //   IconButton(
        //     icon: Icon(Icons.download),
        //     onPressed: () {
        //       download(transactions);
        //     },
        //   ),
        // ],
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
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    SizedBox(height: AppConfig.padding,),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        backgroundColor: widget.category.iconColor.withOpacity(0.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppConfig.borderRadius),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TransactionView(transaction: transactions[index]),
                          ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.all(AppConfig.padding),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  capitalizeFirstLetter(transactions[index].account.name), 
                                  style: AppConfig.fontStyle,
                                ),
                                Text(
                                  transactions[index].description.isNotEmpty ? transactions[index].description : '--', 
                                  style: TextStyle(
                                    fontSize: AppConfig.fontSize * 0.9, 
                                    color: AppConfig.fontColor.withOpacity(0.5)
                                  )
                                )
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('${transactions[index].account.currency} ${transactions[index].amount.toString()}', style: AppConfig.fontStyle,),
                                Text(DateFormat('yyyy-MM-dd').format(transactions[index].date), style: AppConfig.fontStyle,)
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppConfig.buttonSelectedColor,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => CreateTransaction(
            transactionType: widget.trnsactionType,
            category: widget.category,
          )));
        },
        child: Icon(Icons.add, size: AppConfig.iconSize, color: AppConfig.iconColor,),
      ),
    );
  }

  void download(List<TransactionDto>? list) {
    // TODO [implement download options]
  }
}