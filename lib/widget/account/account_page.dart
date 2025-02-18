import 'package:flutter/material.dart';
import 'package:money_manager_3/custom_painter.dart';
import 'package:money_manager_3/dto/account_dto.dart';
import 'package:money_manager_3/helper/config.dart';
import 'package:money_manager_3/helper/index.dart';
import 'package:money_manager_3/state/app_state.dart';
import 'package:money_manager_3/widget/account/create_account_transaction.dart';
import 'package:money_manager_3/widget/account/account_trnsaction_view.dart';
import 'package:money_manager_3/widget/account/create_account.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  void _seeHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AccountTransactionView()),
    );
  }

  void _createAccount() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateAccount()),
    );
  }

  void _makeTransaction() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateAccountTransaction()),
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<String, AccountDto> accounts = context.watch<AppState>().accounts;
    List<AccountDto> accountList = accounts.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Accounts'),
      ),
      body: Stack(
        children: [
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
            painter: DiagonalPainter(),
          ),
          Padding(
            padding: EdgeInsets.all(AppConfig.padding),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: accountList.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          SizedBox(height: AppConfig.padding,),
                          ElevatedButton(
                            style: AppConfig.elevatedButtonStyle,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => CreateAccount(account: accountList[index],)),
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.all(AppConfig.padding),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(right: AppConfig.padding),
                                        child: Icon(
                                          accountList[index].icon, 
                                          size: AppConfig.iconSize, 
                                          color: accountList[index].iconColor,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            capitalizeFirstLetter(accountList[index].name), 
                                            style: AppConfig.fontStyle,
                                          ),
                                          Text(
                                            '${accountList[index].currency} : ${formatNumber(accountList[index].balance)}', 
                                            style: TextStyle(
                                              fontSize: AppConfig.fontSize * 0.8, 
                                              color: AppConfig.fontColor
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Icon(
                                        accountList[index].isAddToTotal ? Icons.visibility : Icons.visibility_off,
                                        color: AppConfig.iconColor,
                                        size: AppConfig.iconSize * 0.7,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: AppConfig.elevatedButtonStyle,
                      onPressed: _seeHistory,
                      child: Padding(
                        padding: EdgeInsets.all(AppConfig.padding),
                        child: Icon(Icons.history, size: AppConfig.iconSize, color: AppConfig.iconColor,),
                      ),
                    ),
                    ElevatedButton(
                      style: AppConfig.elevatedButtonStyle,
                      onPressed: _createAccount,
                      child: Padding(
                        padding: EdgeInsets.all(AppConfig.padding),
                        child: Icon(Icons.add, size: AppConfig.iconSize, color: AppConfig.iconColor,),
                      ),
                    ),
                    ElevatedButton(
                      style: AppConfig.elevatedButtonStyle,
                      onPressed: _makeTransaction,
                      child: Padding(
                        padding: EdgeInsets.all(AppConfig.padding),
                        child: Icon(Icons.swap_horiz, size: AppConfig.iconSize, color: AppConfig.iconColor,),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}