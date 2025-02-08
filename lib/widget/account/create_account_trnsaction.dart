import 'package:flutter/material.dart';
import 'package:money_manager_3/dto/account_dto.dart';
import 'package:money_manager_3/helper/index.dart';
import 'package:money_manager_3/service/shared_service.dart';
import 'package:money_manager_3/state/app_state.dart';
import 'package:money_manager_3/widget/account/accoun_selection_dropdown.dart';
import 'package:provider/provider.dart';

class CreateAccountTransaction extends StatefulWidget {
  @override
  _CreateAccountTransactionState createState() => _CreateAccountTransactionState();
}

class _CreateAccountTransactionState extends State<CreateAccountTransaction> {
  final _formKey = GlobalKey<FormState>();
  String _fromAccountId = '';
  String _toAccountId = '';
  double _amount = 0.0;
  double _toAmount = 0.0;
  DateTime _date = DateTime.now();
  String? _description;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _toAmountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool isFromAccountError = false;
  bool isToAccountError = false;
  Map<String, AccountDto> accounts = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    accounts = context.watch<AppState>().accounts;

    return Scaffold(
      appBar: AppBar(
        title: Text('Trnsfer money'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              renderAccountSelection(),
              renderAmountInput(),
              renderDatepicker(),
              renderDescriptionInput(),
              renderSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget renderAccountSelection() {
    return Row(
      children: [
        Column(
          children: [
            Text('FromAccount'),
            AccountSelectionDropdown(
              onAccountSelect: _onFromAccountChange,
              excludedAccountsId: [_toAccountId],
              isError: isFromAccountError,
            ),
          ],
        ),
        Column(
          children: [
            Text('To Account'),
            AccountSelectionDropdown(
              onAccountSelect: _onToAccountChange,
              excludedAccountsId: [_fromAccountId],
              isError: isToAccountError,
            ),
          ],
        ),
      ],
    );
  }

  Widget renderAmountInput() {
    String? fromCurrency = accounts[_fromAccountId]?.currency;
    String? toCurrency = accounts[_toAccountId]?.currency;
    bool isDiferenceCurrency =
        (_fromAccountId.isNotEmpty && _toAccountId.isNotEmpty) &&
            fromCurrency != toCurrency;
    String? fromHintText = _fromAccountId.isNotEmpty
        ? accounts[_fromAccountId]?.currency
        : 'Amount';
    String? toHintText =
        _toAccountId.isNotEmpty ? accounts[_toAccountId]?.currency : 'Amount';
    double? multiplication =
        (currencyMap[toCurrency] ?? 1) / (currencyMap[fromCurrency] ?? 1);

    return Column(
      children: [
        FormField<String>(
          validator: (value) {
            if (value == null ||
                value.isEmpty ||
                double.tryParse(value) == null) {
              return 'Please enter a valid amount';
            }

            return null;
          },
          initialValue: _amountController.text,
          builder: (FormFieldState<String> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _amountController,
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    hintText: fromHintText,
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      _amount = double.tryParse(value) ?? 0;
                      _toAmountController.text =
                          (_amount * multiplication).toString();
                      _toAmount = _amount * multiplication;
                      state.didChange(value);
                      state.validate();
                    });
                  },
                ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      state.errorText!,
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
              ],
            );
          },
        ),
        if (isDiferenceCurrency) Text('='),
        if (isDiferenceCurrency)
          FormField<String>(
            validator: (value) {
              // print('1111-----, ${value}');
              if (value == null ||
                  value.isEmpty ||
                  double.tryParse(value) == null) {
                return 'Please enter a valid amount';
              }
              return null;
            },
            initialValue: _toAmountController.text,
            builder: (FormFieldState<String> state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _toAmountController,
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      hintText: toHintText,
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _toAmount = double.tryParse(value) ?? 0;
                        state.didChange(value);
                        state.validate();
                      });
                    },
                  ),
                  if (state.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text(
                        state.errorText!,
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                ],
              );
            },
          ),
      ],
    );
  }

  Widget renderDatepicker() {
    return FormField<DateTime>(
      // validator: (value) {
      //   if (_date) {
      //     return 'Please select a date';
      //   }
      //   return null;
      // },
      builder: (FormFieldState<DateTime> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: ${_date.year}-${_date.month}-${_date.day}'),
            ElevatedButton(
              onPressed: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (selectedDate != null) {
                  setState(() {
                    _date = selectedDate;
                    state.didChange(_date);
                    state.reset(); // Clear the error message
                  });
                }
              },
              child: Icon(Icons.calendar_today),
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  state.errorText!,
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget renderDescriptionInput() {
    return FormField<String>(
      validator: (value) {
        return null;
      },
      initialValue: _descriptionController.text,
      builder: (FormFieldState<String> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              // keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _description = value;
                  state.didChange(value);
                  state.validate();
                });
              },
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  state.errorText!,
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget renderSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        _validateAccounts();
        if (_formKey.currentState!.validate() && _validateAccounts()) {
          SharedService.instance.createAccounttrnsaction(_fromAccountId,
              _toAccountId, _amount, _toAmount, _date, _description);
          Navigator.pop(context);
        }
      },
      child: Text('Trnsfer'),
    );
  }

  _onFromAccountChange(String id) {
    setState(() {
      _fromAccountId = id;
      isFromAccountError = false;
    });
  }

  _onToAccountChange(String id) {
    setState(() {
      _toAccountId = id;
      isToAccountError = false;
    });
  }

  bool _validateAccounts() {
    if (_fromAccountId.isEmpty) {
      setState(() {
        isFromAccountError = true;
      });
    }

    if (_toAccountId.isEmpty) {
      setState(() {
        isToAccountError = true;
      });
    }

    return true;
  }
}