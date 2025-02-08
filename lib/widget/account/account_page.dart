import 'package:flutter/material.dart';
import 'package:money_manager_3/dto/account_dto.dart';
import 'package:money_manager_3/state/app_state.dart';
import 'package:money_manager_3/widget/account/account_trnsaction.dart';
import 'package:money_manager_3/widget/account/create_account.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  List<String> accounts = ['Account 1', 'Account 2', 'Account 3'];

  void _seeHistory() {
    // TODO Navigate to history page
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
      MaterialPageRoute(builder: (context) => AccountTransaction()),
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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: accounts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CreateAccount(account: accountList[index],)),
                    );
                  },
                  title: Row(
                    children: [
                      Text(accountList[index].name),
                      accountList[index].isAddToTotal ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                      Text('${accountList[index].currency} : ${accountList[index].balance.toString()}')
                    ],
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _seeHistory,
                child: Text('See History'),
              ),
              ElevatedButton(
                onPressed: _createAccount,
                child: Text('+'),
              ),
              ElevatedButton(
                onPressed: _makeTransaction,
                child: Text('Make Transaction'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}