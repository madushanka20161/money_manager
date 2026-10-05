import 'package:flutter/material.dart';
import 'package:money_manager_3/helper/config.dart';
import 'package:money_manager_3/helper/index.dart';
import 'package:money_manager_3/no-data-available.dart';
import 'package:money_manager_3/service/userstate_service.dart';
import 'package:money_manager_3/widget/input/text-input.dart';

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
  _CurrencySelection createState() => _CurrencySelection();
}

class _CurrencySelection extends State<CurrencySelection> {
  String _selectedCurrency = UserStateService.instance.defaultCurrency!;

  @override
  void initState() {
    super.initState();

    if (widget.selectedCurrency != null) {
      _selectedCurrency = widget.selectedCurrency!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      builder: (FormFieldState<String> state) {
        return Container(
          padding: EdgeInsets.only(top: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      AppConfig.slideRote(CurrencySelectionList(
                    onCurrencyChange: (String value) {
                      if (widget.onCurrencyChange != null) {
                        widget.onCurrencyChange?.call(value);

                        setState(() {
                          _selectedCurrency = value;
                        });
                      }
                    },
                  )));
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppConfig.buttonSelectedColor,
                    padding: EdgeInsets.only(
                      left: AppConfig.paddingXLarge, 
                      top: AppConfig.paddingSmall, 
                      bottom: AppConfig.paddingSmall
                    ),
                    textStyle: TextStyle(
                      fontSize: AppConfig.fontSize,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppConfig.borderRadius),
                    ),
                    ),
                child: Row( 
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedCurrency,
                      style: TextStyle(color: AppConfig.fontColor),
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      size: AppConfig.iconSize,
                      color: AppConfig.fontColor,
                    ),
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

class CurrencySelectionList extends StatefulWidget {
  final Function? onCurrencyChange;
  final double? topPadding;
  final bool? isNavigatorPopDisbale;

  const CurrencySelectionList({super.key, this.onCurrencyChange, this.topPadding, this.isNavigatorPopDisbale});

  @override
  _CurrencySelectionListState createState() => _CurrencySelectionListState();
}

class _CurrencySelectionListState extends State<CurrencySelectionList> {
  late double topPadding;
  bool isNavigatorPopDisbale = false;
  String _selectedCurrency = UserStateService.instance.defaultCurrency!;
  final TextEditingController _searchCurrencyController =
      TextEditingController();
  final double currencySearchBoxHeight = 86;
  List<Map<String, String>> displayCurrencyList = currencyList;

  @override
  void initState() {
    super.initState();

    if (widget.isNavigatorPopDisbale != null) {
      isNavigatorPopDisbale = true;
    }

    if (widget.topPadding == null) {
      topPadding = 40;
    } else {
      topPadding = widget.topPadding!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppConfig.backgroundWrapper(
          context,
          SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: topPadding),
                  renderSearchBox(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: displayCurrencyList.isNotEmpty
                            ? displayCurrencyList
                                .map((Map<String, String> currencyObj) =>
                                    _buildOption(context, currencyObj))
                                .toList()
                            : [NoDataAvailable()],
                      ),
                    ),
                  ),
                ],
              ))),
    );
  }

  Widget renderSearchBox() {
    return SizedBox(
      height: currencySearchBoxHeight,
      child: Container(
        padding: EdgeInsets.only(
            left: AppConfig.padding2XLarge, right: AppConfig.padding2XLarge),
        child: TextInput(
          validator: (value){
            return null;
          },
            inputController: _searchCurrencyController,
            label: 'Search Currency',
            onChange: (value) {
              String searchKey = value.toString().toLowerCase();
              List<Map<String, String>> searchResult =
                  currencyList.where((Map<String, String> currency) {
                String country = currency['country']!.toLowerCase();
                String code = currency['code']!.toLowerCase();
                return country.contains(searchKey) || code.contains(searchKey);
              }).toList();

              setState(() {
                displayCurrencyList = searchResult;
              });
            }),
            
      ),
    );
  }

  Widget _buildOption(BuildContext context, Map<String, String> currencyObj) {
    String currency = currencyObj['code']!;
    String countryName = currencyObj['country']!;
    String? displayLbel = currencyObj['displayLabel'];

    return SimpleDialogOption(
      padding: EdgeInsets.only(left: AppConfig.padding2XLarge, right: AppConfig.padding2XLarge, top: AppConfig.paddingSmall),
      onPressed: () {
        setState(() {
          _selectedCurrency = currency;
        });

        if (widget.onCurrencyChange != null) {
          widget.onCurrencyChange?.call(currency);
        }

        if (!isNavigatorPopDisbale) {
          Navigator.pop(context);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: _selectedCurrency == currency
              ? AppConfig.buttonSelectedColor
              : Colors.transparent,
          borderRadius: AppConfig.borderRadiusAll,
          border: Border.all(
              color: AppConfig.borderColor2, width: AppConfig.borderWidth),
        ),
        padding: EdgeInsets.symmetric(
            horizontal: AppConfig.padding, vertical: AppConfig.paddingSmall),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Text(
                '$countryName ${displayLbel == null ? '' : '($displayLbel)'}',
                style: AppConfig.fontStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                currency,
                style: AppConfig.fontStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
