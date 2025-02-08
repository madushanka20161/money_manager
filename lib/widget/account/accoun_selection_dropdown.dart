import 'package:flutter/material.dart';
import 'package:money_manager_3/dto/account_dto.dart';
import 'package:money_manager_3/state/app_state.dart';
import 'package:provider/provider.dart';

class AccountSelectionDropdown extends StatefulWidget {
  final Function(String)? onAccountSelect;
  final List<String>? excludedAccountsId;
  final bool? isError;

  const AccountSelectionDropdown({
    super.key, 
    this.onAccountSelect,
    this.excludedAccountsId,
    this.isError,
  });

  @override
  _AccountSelectionDropdownState createState() => _AccountSelectionDropdownState();
}

class _AccountSelectionDropdownState extends State<AccountSelectionDropdown> {
  String? _selectedAccount;

  @override
  Widget build(BuildContext context) {
    final accounts = context.watch<AppState>().accounts;
    List<AccountDto> accountList = accounts.values.toList();
    accountList = accountList.where((account) {
      return widget.excludedAccountsId == null || !widget.excludedAccountsId!.contains(account.id);
    }).toList();
    // TODO [need to add create account option]
    
    return DropdownButton<String>(
      underline: widget.isError == true
          ? Container(
              height: 2,
              color: Colors.red,
            )
          : null,
      hint: Text('Select Account'),
      value: _selectedAccount == '' ? null : _selectedAccount,
      items: accountList.map((AccountDto account) {
        return DropdownMenuItem<String>(
          value: account.id,
          child: Text(account.name.toString()),
        );
      }).toList(),
      onChanged: (String? newValue) {
        _selectedAccount = newValue;

        if (widget.onAccountSelect != null) {
          widget.onAccountSelect?.call(newValue!);
        }
      },
    );
  }
}