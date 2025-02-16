import 'package:flutter/material.dart';
import 'package:money_manager_3/custom_painter.dart';
import 'package:money_manager_3/dto/account_dto.dart';
import 'package:money_manager_3/helper/config.dart';
import 'package:money_manager_3/helper/index.dart';
import 'package:money_manager_3/service/shared_service.dart';
import 'package:money_manager_3/widget/common/color_selection.dart';
import 'package:money_manager_3/widget/input/currency-selection.dart';
import 'package:money_manager_3/widget/input/text-input.dart';

class CreateAccount extends StatefulWidget {
  final AccountDto? account;

  const CreateAccount({
    super.key, 
    this.account
  });
  
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _formKey = GlobalKey<FormState>();
  String _accountName = '';
  double _balance = 0.0;
  String _selectedCurrency = 'USD';
  bool _isAddToTotal = true;
  Color _selectedIconColor = defaultColur;
  IconData _selectedIcon = defaultAccountIcon;
  TextEditingController _balanceController = TextEditingController(text: '0');
  TextEditingController _nameController = TextEditingController();
  List<IconData> iconList = accountIconMap.values.toList();
  bool isNewAccount = true;

  @override
  void initState() {
    super.initState();

    if (widget.account != null) {
      isNewAccount = false;
      _accountName = widget.account!.name;
      _nameController = TextEditingController(text: widget.account!.name);
      _balance = widget.account!.balance;
      _balanceController = TextEditingController(text: widget.account!.balance.toString());
      _selectedCurrency = widget.account!.currency;
      _isAddToTotal = widget.account!.isAddToTotal;
      _selectedIconColor = widget.account!.iconColor;
      _selectedIcon = widget.account!.icon;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Account'),
      ),
      body: Stack(
        children: [
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
            painter: DiagonalPainter(),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(AppConfig.paddingXLarge),
                child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    renderCreateAccounticon(),
                    renderAccountName(),
                    renderBalance(),
                    renderCurrency(),
                    renderAddToTotal(),
                    renderIconSelection(),
                    renderColorSelection(),
                    renderSubmitButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget renderCreateAccounticon() {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: AppConfig.borderRadiusAll,
          color: _selectedIconColor.withOpacity(0.8),
        ),
        padding: EdgeInsets.all(AppConfig.padding),
        width: 80,
        height: 80,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(bottom: AppConfig.paddingSmall),
              child: Icon(
                _selectedIcon,
                color: AppConfig.iconColor,
                size: AppConfig.iconSize,
              ),
            ),
            Text(
              _accountName.isEmpty ? 'Name' : _accountName,
              style: TextStyle(
                color: AppConfig.fontColor, 
                fontSize: AppConfig.fontSize * 0.8
              ),
              overflow: TextOverflow.fade,
              softWrap: false,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget renderAccountName() {
    return TextInput(
      inputController: _nameController,
      label: 'Account Name',
      onChange: (value) {
        setState(() {
          _accountName = value;
        });
      },
    );
  }

  Widget renderBalance() {
    return TextInput(
      inputController: _balanceController,
      label: 'Balance',
      onChange: (value) {
        _balance = double.tryParse(value!) ?? 0;
      },
      inputType: TextInputType.number,
      validator: (value) {
        final n = num.tryParse(value!);
        if (n == null) {
          return 'Please enter a valid number';
        }
        return null;
      },
    );
  }

  Widget renderCurrency() {  
    return CurrencySelection(
      width: MediaQuery.of(context).size.width,
      height: 80,
      selectedCurrency: _selectedCurrency,
      onCurrencyChange: (value) {
        setState(() {
          _selectedCurrency = value!;
        });
      },
    );
  }

  Widget renderAddToTotal() {
    return SwitchListTile(
      title: Text('Add to Total', style: AppConfig.fontStyle,),
      contentPadding: EdgeInsets.only(
        left: AppConfig.padding, 
        right: 0, 
        top: AppConfig.padding
      ),
      value: _isAddToTotal,
      onChanged: (bool value) {
        setState(() {
          _isAddToTotal = value;
        });
      },
      activeColor: AppConfig.activeColor,
      // activeTrackColor: Colors.grey.shade300,
      // inactiveThumbColor: Colors.red,
      // inactiveTrackColor: Colors.grey.shade300,
    );
  }

  Widget renderIconSelection() {
    return Container(
      padding: EdgeInsets.only(top: AppConfig.padding),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(
              bottom: AppConfig.paddingSmall, 
              left: AppConfig.padding
            ),
            child: Text('Select Icon', style: AppConfig.fontStyle,),
          ),
          Center(
            child: Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              children: [
                for (IconData icon in iconList)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(60, 70),
                    backgroundColor: _selectedIcon == icon ? AppConfig.buttonSelectedColor : Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConfig.borderRadius),
                    ),
                    padding: EdgeInsets.zero
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedIcon = icon;
                    });
                  },
                  child: Icon(
                    icon, color: AppConfig.fontColor, 
                    size: AppConfig.iconSize
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget renderColorSelection() {
    return ColorSelection(
      onColorSelected: onColorSelected,
      selectedColor: _selectedIconColor,
    );
  }

  Widget renderSubmitButton() {
    return Container(
      padding: EdgeInsets.only(top: AppConfig.padding),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          fixedSize: Size(200, 50),
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            String? id = isNewAccount ? null : widget.account!.id;
            SharedService.instance.createAccount(_accountName, _balance, _selectedCurrency, _isAddToTotal, _selectedIconColor, _selectedIcon, id);
            Navigator.pop(context);
          }
        },
        child: Text(
          isNewAccount ? 'Create Account' : 'Update Account', 
          style: AppConfig.fontStyle,
        ),
      ),
    );
  }

  void onColorSelected(Color color) {
    setState(() {
      _selectedIconColor = color;
    });
  }
}