import 'package:flutter/material.dart';
import 'package:money_manager_3/custom_painter.dart';
import 'package:money_manager_3/dto/category_dto.dart';
import 'package:money_manager_3/enum/index.dart';
import 'package:money_manager_3/helper/config.dart';
import 'package:money_manager_3/helper/index.dart';
import 'package:money_manager_3/state/app_state.dart';
import 'package:money_manager_3/widget/category/category_limit.dart';
import 'package:provider/provider.dart';

class CategoryLimitPage extends StatefulWidget {
  @override
  _CategoryLimitPageState createState() => _CategoryLimitPageState();
}

class _CategoryLimitPageState extends State<CategoryLimitPage> {
  Map<String, CategoryDTO> categories = {};
  TransactionType type = TransactionType.expenses;

  @override
  Widget build(BuildContext context) {
    double buttonWidth =
        (MediaQuery.of(context).size.width - 3 * AppConfig.padding) / 2;
    categories = context.watch<AppState>().categories;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Category Limit'),
      ),
      body: Stack(
        children: [
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height),
            painter: DiagonalPainter(),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(AppConfig.padding),
              child: Column(
                children: [
                  renderTopButtonPanel(buttonWidth),
                  renderCategory(context),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget renderCategory(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    List<CategoryDTO> categoryList = getCategoryByType(categories, type);

    return Container(
      height: screenHeight - 161,
      padding: EdgeInsets.only(top: AppConfig.paddingLarge),
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: generateCategoryList(categoryList)),
      ),
    );
  }

  List<Widget> generateCategoryList(List<CategoryDTO> categoryList) {
    List<Widget> widgetList = [];

    for (CategoryDTO category in categoryList) {
      widgetList.add(
        Padding(
          padding: EdgeInsets.only(bottom: AppConfig.padding),
          child: CategoryLimit(category: category),
        ),
      );
    }

    return widgetList;
  }

  Widget renderTopButtonPanel(double buttonWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          style: type == TransactionType.expenses
              ? AppConfig.elevatedButtonSelectedStyle
              : AppConfig.elevatedButtonStyle,
          child: SizedBox(
              height: 50,
              width: buttonWidth,
              child: Center(
                child: Text(
                  capitalizeFirstLetter(TransactionType.expenses.displayName),
                  style: AppConfig.fontStyle,
                ),
              )),
          onPressed: () {
            setState(() {
              type = TransactionType.expenses;
            });
          },
        ),
        ElevatedButton(
          style: type == TransactionType.income
              ? AppConfig.elevatedButtonSelectedStyle
              : AppConfig.elevatedButtonStyle,
          child: SizedBox(
              height: 50,
              width: buttonWidth,
              child: Center(
                child: Text(
                  capitalizeFirstLetter(TransactionType.income.displayName),
                  style: AppConfig.fontStyle,
                ),
              )),
          onPressed: () {
            setState(() {
              type = TransactionType.income;
            });
          },
        ),
      ],
    );
  }
}
