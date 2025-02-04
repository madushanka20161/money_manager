import 'package:flutter/material.dart';
import 'package:money_manager_3/dto/account_dto.dart';
import 'package:money_manager_3/dto/category_dto.dart';
import 'package:money_manager_3/dto/transaction_dto.dart';
import 'package:money_manager_3/enum/index.dart';
import 'package:money_manager_3/service/shared_service.dart';
import 'package:money_manager_3/state/app_state.dart';
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

  // void validate() {
  //   _formKey.currentState!.validate();
  // }

  @override
  Widget build(BuildContext context) {
    final accounts = context.watch<AppState>().accounts;
    categories = context.watch<AppState>().categories;
    final List<AccountDto> accountList = accounts.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Transaction'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                renderIncomeExpensesButton(),
                renderAccountSelection(accountList),
                renderAmountInput(),
                renderCategorySelection(),
                renderDateSelection(),
                renderDescriptionInput(),
                renderSubmitButton(),
              ],
            ),
          ),
        ),
      )
    );
  }

  Widget renderIncomeExpensesButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [TransactionType.expenses, TransactionType.income].map((type) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  _selectedtransactionType == type ? Colors.blue : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _selectedtransactionType = type;
              });
            },
            child: Text(type.displayName),
          ),
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
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  _selectedAccount == null ? Colors.grey : Colors.blue,
                ),
              ),
              onPressed: () async {
                final selectedAccount = await showDialog<String>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Select Account'),
                      content: Container(
                        width: double.minPositive,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: accountList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              title: Text(accountList[index].name),
                              onTap: () {
                                Navigator.pop(context, accountList[index].id);
                              },
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
                if (selectedAccount != null) {
                  setState(() {
                    _selectedAccount = selectedAccount;
                    state.didChange(selectedAccount);
                    state.reset();
                  });
                }
              },
              child: Text(
                _selectedAccount == null
                    ? 'Select Account'
                    : 'Account: $_selectedAccount',
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
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _amount = double.tryParse(value);
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

  Widget renderCategorySelection() {
    return FormField<String>(
      validator: (value) {
        if (_selectedCategory == null) {
          return 'Please select a category';
        }
        return null;
      },
      builder: (FormFieldState<String> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Category'),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: generateCategoryList(state),
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
        DateTime today = DateTime.now();
        DateTime yesterday = today.subtract(Duration(days: 1));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date:'),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      isSameDate(_selectedDate, today) ? Colors.blue : Colors.grey,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedDate = today;
                      state.didChange(_selectedDate);
                      state.reset(); // Clear the error message
                    });
                  },
                  child: Text('${today.month}/${today.day}'),
                ),
                _selectedDate == null || isSameDate(_selectedDate, today) || isSameDate(_selectedDate, yesterday) ?
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      isSameDate(_selectedDate, yesterday) ? Colors.blue : Colors.grey,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedDate = yesterday;
                      state.didChange(_selectedDate);
                      state.reset(); // Clear the error message
                    });
                  },
                  child: Text('${yesterday.month}/${yesterday.day}'),
                ):
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.blue,
                    ),
                  ),
                  onPressed: () {},
                  child: Text('${_selectedDate!.month}/${_selectedDate!.day}'),
                ),
                ElevatedButton(
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
                  child: Icon(Icons.calendar_today),
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
      child: Text('Submit'),
    );
  }

  List<Widget> generateCategoryList(FormFieldState<String> state) {
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
          child: CategoryWidget(
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
          child: Icon(Icons.add),
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