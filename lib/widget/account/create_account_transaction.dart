import 'package:flutter/material.dart';
import 'package:money_manager_3/custom_painter.dart';
import 'package:money_manager_3/dto/account_dto.dart';
import 'package:money_manager_3/dto/account_trnsaction_dto.dart';
import 'package:money_manager_3/helper/config.dart';
import 'package:money_manager_3/helper/index.dart';
import 'package:money_manager_3/service/shared_service.dart';
import 'package:money_manager_3/state/app_state.dart';
import 'package:money_manager_3/widget/account/accoun_selection_dropdown.dart';
import 'package:money_manager_3/widget/input/date-input.dart';
import 'package:money_manager_3/widget/input/text-input.dart';
import 'package:provider/provider.dart';

class CreateAccountTransaction extends StatefulWidget {
  final AccountTransactionDTO? accountTrnsaction;

  const CreateAccountTransaction({
    this.accountTrnsaction
  });

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
  TextEditingController _amountController = TextEditingController();
  TextEditingController _toAmountController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  bool isFromAccountError = false;
  bool isToAccountError = false;
  Map<String, AccountDto> accounts = {};
  bool isNew = true;
  bool isSubmitClick = false;

  TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.accountTrnsaction != null) {
      isNew = false;
      _fromAccountId = widget.accountTrnsaction!.fromAccount.id;
      _toAccountId = widget.accountTrnsaction!.toAccount.id;
      _amount = widget.accountTrnsaction!.amount;
      _toAmount = widget.accountTrnsaction!.toAmount;
      _date = widget.accountTrnsaction!.date;
      _description = widget.accountTrnsaction!.description;
      _amountController = TextEditingController(text: widget.accountTrnsaction!.amount.toString());
      _toAmountController = TextEditingController(text: widget.accountTrnsaction!.toAmount.toString());
      _descriptionController = TextEditingController(text: widget.accountTrnsaction!.description);
    }
  }

  @override
  Widget build(BuildContext context) {
    accounts = context.watch<AppState>().accounts;

    return Scaffold(
      appBar: AppBar(
        title: Text('Transfer money'),
      ),
      body: Stack(
        children: [
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
            painter: DiagonalPainter(),
          ),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(AppConfig.paddingXLarge),
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
          )
        ],
      ),
    );
  }

  Widget renderAccountSelection() {
    return LayoutBuilder(builder: (context, constraints) {
      double dropdownWidth = (constraints.maxWidth / 2) - AppConfig.paddingSmall;

      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(right: AppConfig.paddingSmall),
            child: FormField<String>(
              validator: (value) {
                if (_fromAccountId.isEmpty) {
                  return 'Please select an account';
                }
                return null;
              },
              builder: (FormFieldState<String> state) {
                return Container(
                  padding: EdgeInsets.only(top: 10),
                  child: AccountSelectionDropdown(
                    isError: state.hasError,
                    errorMessage: state.errorText,
                    mode: 2,
                    width: dropdownWidth,
                    excludedAccountsId: [_toAccountId],
                    onAccountSelect: (String id) {
                      setState(() {
                        _fromAccountId = id;
                        isFromAccountError = false;
                      });

                      state.didChange(id);
                      state.reset();
                    },
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: AppConfig.paddingSmall),
            child: FormField<String>(
              validator: (value) {
                if (_fromAccountId.isEmpty) {
                  return 'Please select an account';
                }
                return null;
              },
              builder: (FormFieldState<String> state) {
                return Container(
                  padding: EdgeInsets.only(top: 10),
                  child: AccountSelectionDropdown(
                    isError: state.hasError,
                    errorMessage: state.errorText,
                    mode: 2,
                    width: dropdownWidth,
                    excludedAccountsId: [_fromAccountId],
                    onAccountSelect: (String id) {
                      setState(() {
                        _toAccountId = id;
                        isFromAccountError = false;
                      });

                      state.didChange(id);
                      state.reset();
                    },
                  ),
                );
              },
            ),
          )
        ],
      );
    });
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

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: TextInput(
            inputController: _amountController,
            label: 'Amount',
            hintText: fromHintText,
            onChange: (value) {
              setState(() {
                _amount = double.tryParse(value) ?? 0;
                _toAmountController.text =
                    (_amount * multiplication).toString();
                _toAmount = _amount * multiplication;
              });
            },
            inputType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty || double.tryParse(value) == null || double.tryParse(value)! <= 0) {
                return 'Please enter a valid amount';
              }
              return null;
            },
          ),
        ),
        if (isDiferenceCurrency)
        Expanded(
          flex: 1,
          child: Container(
            // [TODO] - this is tempory solution need to find proper one to make widget center
            height: 65,
            padding: EdgeInsets.only(top: AppConfig.padding),
            child: Center(
              child: Text('=', style: AppConfig.fontStyle,),
            ),
          ),
        ),
        if (isDiferenceCurrency)
        Expanded(
          flex: 4,
          child: TextInput(
            inputController: _toAmountController,
            label: 'Amount',
            hintText: toHintText,
            onChange: (value) {
              setState(() {
                _toAmount = double.tryParse(value) ?? 0;
              });
            },
            inputType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty || double.tryParse(value) == null || double.tryParse(value)! <= 0) {
                return 'Please enter a valid amount';
              }

              return null;
            },
            forceValidate: isSubmitClick,
          ),
        ),
      ],
    );
  }

  Widget renderDatepicker() {
    return DateInput(
      dateController: _dateController,
      onChange: (DateTime value) {
        setState(() {
          _date = value;
        });
      },
    );
  }

  Widget renderDescriptionInput() {
    return TextInput(
      inputController: _descriptionController,
      label: 'Description',
      onChange: (value) {
        setState(() {
          _description = value;
        });
      },
      validator: (value) {
        return null;
      },
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
          setState(() {
            isSubmitClick = true;
          });
          _validateAccounts();
          
          if (_formKey.currentState!.validate() && _validateAccounts()) {
            String? id = isNew ? null : widget.accountTrnsaction!.id;
            SharedService.instance.createAccounttrnsaction(_fromAccountId,
                _toAccountId, _amount, _toAmount, _date, _description, id);
            Navigator.pop(context);
          }
        },
        child: Text(
          isNew ? 'Transfer' : 'update', 
          style: AppConfig.fontStyle,
        ),
      ),
    );
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