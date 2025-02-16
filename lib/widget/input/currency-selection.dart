import 'package:flutter/material.dart';
import 'package:money_manager_3/helper/config.dart';
import 'package:money_manager_3/helper/index.dart';
import 'package:money_manager_3/popup-helper.dart';

class CurrencySelection extends StatefulWidget {
  final double? width;
  final double? height;
  final Function? onCurrencyChange;
  final String? selectedCurrency;
  
  const CurrencySelection({
    super.key,
    this.width,
    this.height,
    this.onCurrencyChange,
    this.selectedCurrency,
  });
  
  @override
  _CreateCurrencySelection createState() => _CreateCurrencySelection();
}

class _CreateCurrencySelection extends State<CurrencySelection> {
  String _selectedCurrency = defaultCurrency;

  @override
  void initState() {
    super.initState();

    if (widget.selectedCurrency != null) {
      _selectedCurrency = widget.selectedCurrency!;
    }
  }
  
  Widget _buildOption(BuildContext context, String currency) {
    return SimpleDialogOption(
      onPressed: () {
        setState(() {
          _selectedCurrency = currency;
        });

        if (widget.onCurrencyChange != null) {
          widget.onCurrencyChange?.call(currency);
        }

        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          currency,
          style: TextStyle(backgroundColor: _selectedCurrency == currency ? Colors.red : Colors.white),
        ),
      ),
    );
  }

  Widget _showPopup(BuildContext context) {
    return Column(
      children: [
        ...currencyList.map((String currency) => _buildOption(context, currency))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      builder: (FormFieldState<String> state) {
        return Container(
          padding: EdgeInsets.only(top: AppConfig.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: () {
                  PopupHelper.showPopup(context, [_showPopup(context)]);
                }, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConfig.buttonSelectedColor,
                  padding: EdgeInsets.all(AppConfig.padding),
                  textStyle: TextStyle(fontSize: AppConfig.fontSize,),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConfig.borderRadius),
                  ),
                  fixedSize: Size(MediaQuery.of(context).size.width, 60)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_selectedCurrency, style: TextStyle(color: AppConfig.fontColor),),
                    Icon(Icons.arrow_drop_down, size: AppConfig.iconSize, color: AppConfig.fontColor,),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}