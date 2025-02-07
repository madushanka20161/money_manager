import 'package:flutter/material.dart';
import 'package:money_manager_3/helper/index.dart';
import 'package:money_manager_3/service/shared_service.dart';
import 'package:money_manager_3/widget/common/color_selection.dart';

class CreateAccount extends StatefulWidget {
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
  final TextEditingController _balanceController = TextEditingController(text: '0');
  List<IconData> iconList = accountIconMap.values.toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Account'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
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
    );
  }

  Widget renderAccountName() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Account Name'),
      onChanged: (value) {
        _accountName = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter an account name';
        }
        return null;
      },
    );
  }

  Widget renderBalance() {
    return TextFormField(
      controller: _balanceController,
      decoration: InputDecoration(labelText: 'Balance'),
      keyboardType: TextInputType.number,
      onSaved: (value) {
        _balance = double.parse(value!);
      },
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
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: 'Currency'),
      value: _selectedCurrency,
      onChanged: (String? newValue) {
        setState(() {
          _selectedCurrency = newValue!;
        });
      },
      items: currencyList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget renderAddToTotal() {
    return SwitchListTile(
      title: Text('Add to Total'),
      value: _isAddToTotal,
      onChanged: (bool value) {
        setState(() {
          _isAddToTotal = value;
        });
      },
    );
  }

  Widget renderIconSelection() {
    return Column(
      children: [
        Text('Icon Selection'),
        Wrap(
          spacing: 10.0,
          children: [
            for (IconData icon in iconList)
              IconButton(
                color: _selectedIcon == icon ? Colors.red : null,
                icon: Icon(icon),
                onPressed: () {
                  setState(() {
                    _selectedIcon = icon;
                  });
                },
              ),
          ],
        ),
      ],
    );
  }

  Widget renderColorSelection() {
    return Container(
      child: ColorSelection(
        onColorSelected: onColorSelected,
        selectedColor: _selectedIconColor,
      ),
    );
  }

  Widget renderSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          SharedService.instance.createAccount(_accountName, _balance, _selectedCurrency, _isAddToTotal, _selectedIconColor, _selectedIcon);
          Navigator.pop(context);
        }
      },
      child: Text('Create Account'),
    );
  }

  void onColorSelected(Color color) {
    _selectedIconColor = color;
  }
}