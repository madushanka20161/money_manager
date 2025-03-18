import 'package:flutter/material.dart';
import 'package:money_manager_3/custom_painter.dart';
import 'package:money_manager_3/dto/category_dto.dart';
import 'package:money_manager_3/enum/index.dart';
import 'package:money_manager_3/helper/config.dart';
import 'package:money_manager_3/helper/index.dart';
import 'package:money_manager_3/state/app_state.dart';
import 'package:money_manager_3/widget/category/category_widget.dart';
import 'package:money_manager_3/widget/category/create_category.dart';
import 'package:provider/provider.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  Map<String, CategoryDTO> categories = {};
  TransactionType type = TransactionType.expenses;

  @override
  Widget build(BuildContext context) {
    double buttonWidth = (MediaQuery.of(context).size.width - 3 * AppConfig.padding) / 2;
    categories = context.watch<AppState>().categories;

    return Scaffold(
      appBar: AppBar(
        title: Text('Category'),
      ),
      body: Stack(
        children: [
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
            painter: DiagonalPainter(),
          ),
          Padding(
            padding: EdgeInsets.all(AppConfig.padding),
            child: Column(
              children: [
                renderTopButtonPanel(buttonWidth),
                renderCategoryView(context),
                renderBottomButton(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget renderBottomButton() {
    return Padding(
      padding: EdgeInsets.only(top: AppConfig.padding),
      child: ElevatedButton(
        style: AppConfig.elevatedButtonStyle,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CreateCategory(transactionType: type),
            ),
          );
        },
        child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: AppConfig.paddingXLarge * 2,
                vertical: AppConfig.paddingLarge),
            child: Text(
              'Create Category',
              style: AppConfig.fontStyle,
            )),
      ),
    );
  }

  Widget renderCategoryView(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(top: AppConfig.paddingLarge),
        child: ListView(
          children: [
            Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              alignment: WrapAlignment.spaceAround,
              children: renderCategoryList(context),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> renderCategoryList(BuildContext context) {
    double categoryButtonWidth = (MediaQuery.of(context).size.width - AppConfig.padding * 2 - 10*3) / 4;
    double categoryButtonHeight = 80;
    List<CategoryDTO> categoryList = getCategoryByType(categories, type);
    List<Widget> widgetList = [];
    
    for (CategoryDTO category in categoryList) {
      widgetList.add(
        ElevatedButton(
          onPressed: () {},
          style: AppConfig.elevatedButtonStyle,
          child: CategoryWidget(
            width: categoryButtonWidth,
            height: categoryButtonHeight,
            icon: category.icon, 
            text: category.name,
            iconColor: category.iconColor,
            iconColorOpacity: 0.8,
            fontSize: AppConfig.fontSize,
            isTooltip: true,
          )
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