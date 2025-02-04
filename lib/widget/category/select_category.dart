import 'package:flutter/material.dart';
import 'package:money_manager_3/dto/category_dto.dart';
import 'package:money_manager_3/enum/index.dart';
import 'package:money_manager_3/state/app_state.dart';
import 'package:money_manager_3/widget/category/category_widget.dart';
import 'package:money_manager_3/widget/category/create_category.dart';
import 'package:provider/provider.dart';

class SelectCategory extends StatefulWidget {
  final String? categoryId;
  final Function onCategorySelected;
  final TransactionType transactionType;

  SelectCategory({
    required this.categoryId,
    required this.onCategorySelected,
    required this.transactionType
  });

  @override
  _SelectCategoryState createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  Map<String, CategoryDTO> categories = {};

  @override
  Widget build(BuildContext context) {
    categories = context.watch<AppState>().categories;

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Category'),
      ),
      body: Container(
        child: Column(
          children: [
            Wrap(
              children: renderCategoryList(),
            ),
            Container(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateCategory(transactionType: widget.transactionType),
                    ),
                  );
                },
                child: Text('Create Category'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> renderCategoryList() {
    List<CategoryDTO> categoryList = categories.values.where((CategoryDTO category) => category.type == widget.transactionType).toList();
    List<Widget> widgetList = [];
    
    for (CategoryDTO category in categoryList) {
      widgetList.add(
        ElevatedButton(
          onPressed: () {
            widget.onCategorySelected(category.id);
          },
          child: CategoryWidget(
            icon: category.icon, 
            text: category.name,
            isSelected: widget.categoryId == category.id,
            iconColor: category.iconColor,
          )
        ),
      );
    }

    return widgetList;
  }
}