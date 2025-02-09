import 'package:flutter/material.dart';
import 'package:money_manager_3/dto/account_dto.dart';
import 'package:money_manager_3/helper/config.dart';
import 'package:money_manager_3/state/app_state.dart';
import 'package:provider/provider.dart';

class AccountSelectionDropdown extends StatefulWidget {
  final Function(String)? onAccountSelect;
  final List<String>? excludedAccountsId;
  final bool? isError;
  final String? selectedAccount;

  const AccountSelectionDropdown({
    super.key, 
    this.onAccountSelect,
    this.excludedAccountsId,
    this.isError,
    this.selectedAccount,
  });

  @override
  _AccountSelectionDropdownState createState() => _AccountSelectionDropdownState();
}

class _AccountSelectionDropdownState extends State<AccountSelectionDropdown> {
  String? _selectedAccount;
  Map<String, AccountDto> accounts = {};
  List<AccountDto> accountList = [];

  @override
  void initState() {
    super.initState();

    if (widget.selectedAccount != null) {
      _selectedAccount = widget.selectedAccount;
    }
  }

  void _showPopup(BuildContext context) async {
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: [
            _buildAllAccountOption(context),
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
    
    return SizedBox(
      width: 150,
      child: Column(
        children: [
          ElevatedButton.icon(
            onPressed: () {
              _showPopup(context);
            }, 
            icon: Icon(Icons.arrow_drop_down, size: AppConfig.iconSize, color: AppConfig.fontColor,),
            label: Text(_selectedAccount ?? "All Account", style: TextStyle(color: AppConfig.fontColor),),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(34, 255, 255, 255),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              textStyle: TextStyle(fontSize: AppConfig.fontSize,),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // ✅ Rounded corners (20)
              ),
              minimumSize: Size(double.infinity, 50),
            ),
          ),
          widget.isError == true ?
          Container(
            height: 2, // Thickness of underline
            width: 150, // Adjust width of the underline
            color: Colors.red, // Underline color
          )
          :
          Container(),
        ],
      ),
    );
  }
}