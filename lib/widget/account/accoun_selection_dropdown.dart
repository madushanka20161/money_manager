import 'package:flutter/material.dart';
import 'package:money_manager_3/dto/account_dto.dart';
import 'package:money_manager_3/helper/config.dart';
import 'package:money_manager_3/state/app_state.dart';
import 'package:provider/provider.dart';

class AccountSelectionDropdown extends StatefulWidget {
  final Function(String)? onAccountSelect;
  final List<String>? excludedAccountsId;
  final bool? isError;
  final String? errorMessage;
  final String? selectedAccount;
  final double? width;
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
    this.selectedAccount,
    this.mode,
    this.width,
  });

  @override
  _AccountSelectionDropdownState createState() => _AccountSelectionDropdownState();
}

class _AccountSelectionDropdownState extends State<AccountSelectionDropdown> {
  String? _selectedAccount;
  int? _mode;
  Map<String, AccountDto> accounts = {};
  List<AccountDto> accountList = [];

  @override
  void initState() {
    super.initState();

    if (widget.selectedAccount != null) {
      _selectedAccount = widget.selectedAccount;
    }

    _mode = widget.mode ?? 1;
  }

  void _showPopup(BuildContext context) async {
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: [
            if (_mode == 1) _buildAllAccountOption(context),
            ...accountList.map((AccountDto account) => _buildDialogOption(context, account)),
            // TODO [need to add create account option]
          ],
        );
      },
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
        padding: const EdgeInsets.all(8.0),
        child: Text("All Account"),
      ),
    );
  }

  Widget _buildDialogOption(BuildContext context, AccountDto account) {
    return SimpleDialogOption(
      onPressed: () {
        setState(() {
          _selectedAccount = account.name;
        });

        if (widget.onAccountSelect != null) {
          widget.onAccountSelect?.call(account.id);
        }

        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(account.name),
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

    if (_mode == 1) {
      return SizedBox(
        width: 150,
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: () {
                _showPopup(context);
              }, 
              icon: Icon(Icons.arrow_drop_down, size: AppConfig.iconSize, color: AppConfig.fontColor,),
              label: Text(
                _selectedAccount ?? "All Account", 
                style: TextStyle(color: AppConfig.fontColor),
                overflow: TextOverflow.fade,
                softWrap: false,
                maxLines: 1,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(34, 255, 255, 255),
                padding: EdgeInsets.all(AppConfig.padding),
                textStyle: TextStyle(fontSize: AppConfig.fontSize,),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConfig.borderRadius),
                ),
                minimumSize: Size(double.infinity, 50),
              ),
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
                      _selectedAccount ?? "Select Account", 
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