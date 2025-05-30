import 'package:flutter/material.dart';
import 'package:money_manager_3/dto/account_dto.dart';
import 'package:money_manager_3/helper/config.dart';
import 'package:money_manager_3/helper/index.dart';
import 'package:money_manager_3/state/app_state.dart';
import 'package:money_manager_3/widget/account/create_account.dart';
import 'package:provider/provider.dart';

class AccountSelectionDropdown extends StatefulWidget {
  final Function(String)? onAccountSelect;
  final List<String>? excludedAccountsId;
  final bool? isError;
  final String? errorMessage;
  final String? selectedAccountId;
  final double? width;
  final bool? isCreateAccountOptionEnable;
  /*
    values for mode 1, 2
    defaulr value is 1
    1 - for account selection with `all account` options
    2 - for account selection without `all account` options 
  */
  final int? mode;

  const AccountSelectionDropdown({
    super.key, 
    this.onAccountSelect,
    this.excludedAccountsId,
    this.isError,
    this.errorMessage,
    this.selectedAccountId,
    this.mode,
    this.width,
    this.isCreateAccountOptionEnable,
  });

  @override
  _AccountSelectionDropdownState createState() => _AccountSelectionDropdownState();
}

class _AccountSelectionDropdownState extends State<AccountSelectionDropdown> {
  String? _selectedAccount;
  int? _mode;
  Map<String, AccountDto> accounts = {};
  List<AccountDto> accountList = [];
  Color backgroundColor = AppConfig.popupBKColor;
  bool? isCreateAccountOptionEnable;

  @override
  void initState() {
    super.initState();

    // if (widget.selectedAccountId != null) {
    //   print('111-----------------');
    //   print(widget.selectedAccountId);
    //   print(accountList);
    //   _selectedAccount = widget.selectedAccountId;
    // }

    _mode = widget.mode ?? 1;
    isCreateAccountOptionEnable = widget.isCreateAccountOptionEnable ?? false;
    _selectedAccount = 'All Account';
  }

  void _showPopup(BuildContext context) async {
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          backgroundColor: backgroundColor,
          children: [
            if (_mode == 1) _buildAllAccountOption(context),
            ...accountList.map((AccountDto account) => _buildDialogOption(context, account)),
            if (isCreateAccountOptionEnable! && accountList.isEmpty) createAccountButton(),
          ],
        );
      },
    );
  }

  Widget createAccountButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: EdgeInsets.all(AppConfig.padding),
        textStyle: TextStyle(fontSize: AppConfig.fontSize,),
        elevation: 0,
        minimumSize: Size(double.infinity, 50),
      ),
      child: Row(children: [
        Icon(Icons.add, size: AppConfig.iconSize * .6, color: AppConfig.fontColor,),
        Text('Create Account', style: AppConfig.fontStyle),
      ],),
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CreateAccount()),
        );

        // TODO [V2 - need to update account list insted of closin popup]
        Navigator.pop(context);
      }
    );
  }

  Widget _buildAllAccountOption(BuildContext context) {
    return SimpleDialogOption(
      onPressed: () {
        setState(() {
          _selectedAccount = 'All Account';
        });

        if (widget.onAccountSelect != null) {
          widget.onAccountSelect?.call('');
        }

        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Row(
          children: [
            Padding(
                padding: EdgeInsets.only(right: AppConfig.padding),
                child: Icon(
                  'All Account' == _selectedAccount
                      ? Icons.circle
                      : Icons.circle_outlined,
                  color: AppConfig.fontColor,
                  size: 15,
                ),
              ),
            Text("All Account", style: AppConfig.fontStyle)
          ],
        )
        // child: Text("All Account", style: AppConfig.fontStyle),
      ),
    );
  }

  Widget _buildDialogOption(BuildContext context, AccountDto account) {
    return SimpleDialogOption(
      onPressed: () {
        setState(() {
          _selectedAccount = capitalizeFirstLetter(account.name);
        });

        if (widget.onAccountSelect != null) {
          widget.onAccountSelect?.call(account.id);
        }

        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Row(
          children: [
            Padding(
                padding: EdgeInsets.only(right: AppConfig.padding),
                child: Icon(
                  capitalizeFirstLetter(account.name) == capitalizeFirstLetter(_selectedAccount ?? '')
                      ? Icons.circle
                      : Icons.circle_outlined,
                  color: AppConfig.fontColor,
                  size: 15,
                ),
              ),
            Text(capitalizeFirstLetter(account.name), style: AppConfig.fontStyle),
          ],
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    accounts = context.watch<AppState>().accounts;
    accountList = accounts.values.toList();
    accountList = accountList.where((account) {
      return widget.excludedAccountsId == null || !widget.excludedAccountsId!.contains(account.id);
    }).toList();

    if (widget.selectedAccountId != null) {
      _selectedAccount = accountList.firstWhere((account) {
        return widget.selectedAccountId == account.id;
      }).name;
    }

    if (_mode == 1) {
      return SizedBox(
        width: 150,
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                _showPopup(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(34, 255, 255, 255),
                padding: EdgeInsets.all(AppConfig.padding),
                textStyle: TextStyle(fontSize: AppConfig.fontSize,),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConfig.borderRadius),
                ),
                minimumSize: Size(double.infinity, 50),
              ),
              child: Row(
                children: [
                  Icon(Icons.arrow_drop_down, size: AppConfig.iconSize, color: AppConfig.fontColor,),
                  Expanded(
                    child: Text(
                      capitalizeFirstLetter(_selectedAccount ?? "All Account"), 
                      style: TextStyle(color: AppConfig.fontColor),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      maxLines: 1,
                    ),
                  ),
                ],
              )
            ),
          ],
        ),
      );
    } else {
      return SizedBox(
        width: widget.width ?? MediaQuery.of(context).size.width,
          child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                _showPopup(context);
              }, 
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedAccount != null ? AppConfig.buttonSelectedColor : Colors.transparent,
                padding: EdgeInsets.all(AppConfig.padding),
                textStyle: TextStyle(fontSize: AppConfig.fontSize,),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConfig.borderRadius),
                ),
                minimumSize: Size(double.infinity, 50),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      capitalizeFirstLetter(_selectedAccount ?? "Select Account"), 
                      style: TextStyle(color: AppConfig.fontColor),
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      maxLines: 1,
                    ), 
                  ),
                  Expanded(
                    flex: 1,
                    child: Icon(
                      Icons.arrow_drop_down, 
                      size: AppConfig.iconSize, 
                      color: AppConfig.fontColor,
                    ),
                  ),
                ],
              ),
            ),
            widget.isError == true ?
            Container(
              width: widget.width ?? MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(top: AppConfig.paddingSmall),
              child: Text(
                widget.errorMessage ?? 'Please Select an Account',
                style: TextStyle(color: AppConfig.errorFontColor, fontSize: AppConfig.errorFontSize),
              ),
            )
            :
            Container(),
          ],
        ),
      );
    }
  }
}