import 'package:flutter/material.dart';
import 'package:money_manager_3/custom_painter.dart';
import 'package:money_manager_3/dto/account_dto.dart';
import 'package:money_manager_3/dto/category_dto.dart';
import 'package:money_manager_3/dto/transaction_dto.dart';
import 'package:money_manager_3/enum/index.dart';
import 'package:money_manager_3/helper/config.dart';
import 'package:money_manager_3/helper/index.dart';
import 'package:money_manager_3/service/shared_service.dart';
import 'package:money_manager_3/state/app_state.dart';
import 'package:money_manager_3/widget/account/accoun_selection_dropdown.dart';
import 'package:money_manager_3/widget/category/category_widget.dart';
import 'package:money_manager_3/widget/category/select_category.dart';
import 'package:provider/provider.dart';

class CreateTransaction extends StatefulWidget {
  final TransactionType? transactionType;
  final CategoryDTO? category;
  final TransactionDto? transaction;
  final bool? isTrnsactionEdit;
  final bool? isTrnsactionCopy;

  CreateTransaction({
    this.transactionType,
    this.category,
    this.transaction,
    this.isTrnsactionEdit,
    this.isTrnsactionCopy,
  });

  @override
  _CreateTransactionState createState() => _CreateTransactionState();
}

class _CreateTransactionState extends State<CreateTransaction> {
  DateTime today = DateTime.now();
  Map<String, CategoryDTO> categories = {};
  
  TransactionType? _selectedtransactionType;
  final _formKey = GlobalKey<FormState>();
  String? _selectedAccount;
  String? _selectedCategory;
  DateTime? _selectedDate;
  double? _amount;
  String? _description;
  bool isSubmitButtonPressed = false; // to execute validation function
  TextEditingController _amountController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  bool isTrnsactionEdit = false;
  bool isTrnsactionCopy = false;

  @override
  void initState() {
    super.initState();

    if (widget.transactionType == null) {
      _selectedtransactionType = TransactionType.expenses;
    } else {
      _selectedtransactionType = widget.transactionType;
    }
    
    if (widget.category != null) {
      _selectedCategory = widget.category!.id;
    }

    if (widget.transaction != null) {
      _selectedAccount = widget.transaction!.account.id;
      _selectedCategory = widget.transaction!.category.id;
      _selectedDate = widget.transaction!.date;
      _amount = widget.transaction!.amount;
      _description = widget.transaction!.description;
      _amountController = TextEditingController(text: widget.transaction!.amount.toString());
      _descriptionController = TextEditingController(text: widget.transaction!.description);
    }

    if (widget.isTrnsactionEdit != null) {
      isTrnsactionEdit = widget.isTrnsactionEdit!;
    }

    if (widget.isTrnsactionCopy != null) {
      isTrnsactionCopy = widget.isTrnsactionCopy!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final accounts = context.watch<AppState>().accounts;
    categories = context.watch<AppState>().categories;
    final List<AccountDto> accountList = accounts.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Transaction'),
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
                    renderIncomeExpensesButton(),
                    renderAccountSelection(accountList),
                    renderAmountInput(),
                    renderCategorySelection(context),
                    renderDateSelection(),
                    renderDescriptionInput(),
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

  Widget renderIncomeExpensesButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [TransactionType.expenses, TransactionType.income].map((type) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            fixedSize: Size((MediaQuery.of(context).size.width -40 - 16) / 2, 50),
            backgroundColor:
              _selectedtransactionType == type ? AppConfig.buttonSelectedColor : Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            setState(() {
              _selectedtransactionType = type;
            });
          },
          child: Text(capitalizeFirstLetter(type.displayName), style: TextStyle(color: Colors.white, fontSize: AppConfig.fontSize,),),      
        );
      }).toList(),
    );
  }

  Widget renderAccountSelection(List<AccountDto> accountList) {
    return FormField<String>(
      validator: (value) {
        if (_selectedAccount == null) {
          return 'Please select an account';
        }
        return null;
      },
      builder: (FormFieldState<String> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 10),
              child: AccountSelectionDropdown(
                isError: state.hasError,
                errorMessage: state.errorText,
                mode: 2,
                onAccountSelect: (String id) {
                  _selectedAccount = id;
                  state.didChange(id);
                  state.reset();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget renderAmountInput() {
    return FormField<String>(
      validator: (value) {
        if (value == null || value.isEmpty || double.tryParse(value) == null) {
          return 'Please enter a valid amount';
        }
        return null;
      },
      initialValue: _amountController.text,
      builder: (FormFieldState<String> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 10),
              child: TextFormField(
                controller: _amountController,
                style: TextStyle(color: AppConfig.fontColor, fontSize: AppConfig.fontSize),
                decoration: InputDecoration(
                  labelText: 'Amount',
                  labelStyle: TextStyle(color: AppConfig.fontColor, fontSize: AppConfig.fontSize),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppConfig.buttonSelectedColor),
                  ),
                  
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _amount = double.tryParse(value);
                    state.didChange(value);
                    state.validate();
                  });
                },
              ),
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

  Widget renderCategorySelection(BuildContext context) {
    return FormField<String>(
      validator: (value) {
        if (_selectedCategory == null) {
          return 'Please select a category';
        }
        return null;
      },
      builder: (FormFieldState<String> state) {
        return Container(
          padding: EdgeInsets.only(top: AppConfig.padding),
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(bottom: AppConfig.paddingSmall, left: AppConfig.padding),
                child: Text('Category', style: AppConfig.fontStyle,),
              ),
              Wrap(
                spacing: 10.0,
                runSpacing: 10.0,
                alignment: WrapAlignment.spaceAround,
                children: generateCategoryList(state, context),
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
          )
        );
      },
    );
  }

  bool isSameDate(DateTime? date1, DateTime date2) {
    if (date1 == null) {
      return false;
    }

    return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
  }

  Widget renderDateSelection() {
    return FormField<DateTime>(
      validator: (value) {
        if (_selectedDate == null) {
          return 'Please select a date';
        }
        return null;
      },
      builder: (FormFieldState<DateTime> state) {
        double screenWidth = MediaQuery.of(context).size.width;
        double buttonWidth = (screenWidth - 20 * 2 - 10 * 2) / 3;
        DateTime today = DateTime.now();
        DateTime yesterday = today.subtract(Duration(days: 1));

        Widget dateButton(Function onPressed, Widget child, DateTime displayDate) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              backgroundColor: isSameDate(_selectedDate, displayDate) ? AppConfig.buttonSelectedColor : Colors.transparent,
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              fixedSize: Size(buttonWidth, 50)
            ),
            onPressed: () {
              onPressed();          
            },
            child: child,
          );
        }

        return Container(
          padding: EdgeInsets.only(top: AppConfig.padding),
          width: screenWidth,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(bottom: AppConfig.paddingSmall, left: AppConfig.padding),
                child: Text('Date', style: AppConfig.fontStyle,),
              ),
              Wrap(
                spacing: 10.0,
                runSpacing: 10.0,
                alignment: WrapAlignment.spaceAround,
                children: [
                  dateButton(
                    () {
                      setState(() {
                        _selectedDate = today;
                        state.didChange(_selectedDate);
                        state.reset();
                      });
                    }, 
                    Text(
                      '${today.month} / ${today.day}', 
                      style: AppConfig.fontStyle,
                    ),
                    today
                  ),
                  _selectedDate == null || isSameDate(_selectedDate, today) || isSameDate(_selectedDate, yesterday) ?
                  dateButton(
                    () {
                      setState(() {
                        _selectedDate = yesterday;
                        state.didChange(_selectedDate);
                        state.reset();
                      });
                    }, 
                    Text(
                      '${yesterday.month} / ${yesterday.day}', 
                      style: AppConfig.fontStyle,
                    ),
                    yesterday
                  )
                  :
                  dateButton(
                    () {}
                    ,
                    Text(
                      '${_selectedDate!.month} / ${_selectedDate!.day}',
                      style: AppConfig.fontStyle,
                    ),
                    _selectedDate!
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      fixedSize: Size(buttonWidth, 50)
                    ),
                    onPressed: () async {
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (selectedDate != null) {
                        setState(() {
                          _selectedDate = selectedDate;
                          state.didChange(_selectedDate);
                          state.reset(); // Clear the error message
                        });
                      }
                    },
                    child: Container(
                      width: buttonWidth,
                      height: 50,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.calendar_today,
                        color: AppConfig.fontColor,
                        size: AppConfig.iconSize,
                      ),
                    ),
                  ),
                ],
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
          ),
        );
      },
    );
  }

  Widget renderDescriptionInput() {
    return FormField<String>(
      validator: (value) {
        value!.contains('|') ? 'Description cannot contain | symbol' : null;
        return null;
      },
      initialValue: _descriptionController.text,
      builder: (FormFieldState<String> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: AppConfig.padding),
              child: TextFormField(
                controller: _descriptionController,
                style: TextStyle(color: AppConfig.fontColor, fontSize: AppConfig.fontSize),
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: AppConfig.fontColor, fontSize: AppConfig.fontSize),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppConfig.buttonSelectedColor),
                  ),
                  
                ),
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  setState(() {
                    _description = value;
                    state.didChange(value);
                    state.validate();
                  });
                },
              ),
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
    return Container(
      padding: EdgeInsets.only(top: AppConfig.padding),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          fixedSize: Size(100, 50),
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            String? previousId = isTrnsactionEdit ? widget.transaction?.id : null;
            SharedService.instance.createTransaction(_selectedtransactionType!, _selectedAccount!, _amount!, _selectedCategory!, _selectedDate!, _description, previousId);
            
            if (isTrnsactionEdit == true || isTrnsactionCopy == true) {
              // to skip trnsaction view screen
              int count = 0;
              Navigator.popUntil(context, (route) {
                return count++ == 2;
              });
            } else {
              Navigator.pop(context);
            }
          }
        },
        child: Text('Add', style: AppConfig.fontStyle,),
      ),
    );
  }

  List<Widget> generateCategoryList(FormFieldState<String> state, BuildContext context) {
    double categoryButtonWidth = (MediaQuery.of(context).size.width - 20*2 - 10*3) / 4;
    double categoryButtonHeight = 80;
    List<CategoryDTO> categoryList = categories.values.where((CategoryDTO category) => category.type == _selectedtransactionType).toList();
    List<Widget> widgetList = [];
    int count = 0;
    int maxDisplayCount = 7;
    bool isSelectedCategotyDisplayed = false;

    void addCategoryToList(CategoryDTO data) {
      widgetList.add(
        ElevatedButton(
          onPressed: () {
            setState(() {
              _selectedCategory = data.id;
              state.didChange(_selectedCategory);
              state.reset();
            });
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: CategoryWidget(
            width: categoryButtonWidth,
            height: categoryButtonHeight,
            icon: data.icon,
            text: data.name,
            isSelected: _selectedCategory == data.id,
            iconColor: data.iconColor,
          ),
        ),
      );
    }

    void addCreateButton() {
      widgetList.add(
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SelectCategory(
                  categoryId: _selectedCategory,
                  transactionType: _selectedtransactionType!,
                  onCategorySelected: (categoryId) {
                    setState(() {
                      _selectedCategory = categoryId;
                      state.didChange(_selectedCategory);
                      state.reset();
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Container(
            width: categoryButtonWidth,
            height: categoryButtonHeight,
            alignment: Alignment.center,
            child: Icon(
              Icons.add,
              color: AppConfig.fontColor,
              size: AppConfig.iconSize,
            ),
          ),
        ),
      );
    }
    
    for (CategoryDTO category in categoryList) {
      if (count == maxDisplayCount) {
        if (categoryList.length > maxDisplayCount) {
          addCreateButton();
        }

        break;
      } else if (_selectedCategory != null && count == maxDisplayCount - 1 && !isSelectedCategotyDisplayed) {
        CategoryDTO selectedCategoryDto = categories[_selectedCategory]!;
        addCategoryToList(selectedCategoryDto);
      } else {
        addCategoryToList(category);
      }

      if (_selectedCategory == category.id) {
        isSelectedCategotyDisplayed = true;
      }

      count++;
    }

    if (categoryList.length < maxDisplayCount + 1) {
      addCreateButton();
    }

    return widgetList;
  }
}